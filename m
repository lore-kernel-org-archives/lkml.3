Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089AbaIYTex (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 15:34:53 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:63802 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751537AbaIYTes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 15:34:48 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Wolfram Sang <wsa@the-dreams.de>, Vinod Koul <vinod.koul@intel.com>
Cc: Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        subhransu.s.prusty@intel.com, Alan Stern <stern@rowland.harvard.edu>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Gross <agross@codeaurora.org>, Baruch Siach <baruch@tkos.co.il>,
        Ben Skeggs <bskeggs@redhat.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        "Chew, Chiau Ee" <chiau.ee.chew@intel.com>,
        Chris Ball <chris@printf.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@redhat.com>,
        David Herrmann <dh.herrmann@gmail.com>, dmaengine@vger.kernel.org,
        dri-devel@lists.freedesktop.org, "Du, Wenkai" <wenkai.du@intel.com>,
        Grant Grundler <grundler@chromium.org>,
        Ilia Mirkin <imirkin@alum.mit.edu>, intel-gfx@lists.freedesktop.org,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Jani Nikula <jani.nikula@intel.com>, Jingoo Han <jg1.han@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-nfc@ml01.01.org,
        linux-omap@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        Marcin Wojtas <mw@semihalf.com>,
        Mika Westerberg <mika.westerberg@linux.jf.intel.com>,
        patches@opensource.wolfsonmicro.com,
        Pramod Gurav <pramod.gurav@smartplayin.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Rob Clark <robdclark@gmail.com>,
        Romain Baeriswyl <Romain.Baeriswyl@abilis.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Shinya Kuribayashi <skuribay@pobox.com>,
        Thierry Reding <treding@nvidia.com>,
        Tim Kryger <tim.kryger@linaro.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH 00/27] add pm_runtime_last_busy_and_autosuspend() helper
Date: Thu, 25 Sep 2014 21:54:36 +0200
Message-ID: <32849712.0gtj7BlKY3@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140925142758.GB1316@katana>
References: <1411575342-31048-1-git-send-email-vinod.koul@intel.com> <20140925142201.GD28045@saruman> <20140925142758.GB1316@katana>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 25, 2014 04:27:58 PM Wolfram Sang wrote:
> 
> --Bn2rw/3z4jIqBvZU
> Content-Type: text/plain; charset=us-ascii
> Content-Disposition: inline
> Content-Transfer-Encoding: quoted-printable
> 
> On Thu, Sep 25, 2014 at 09:22:01AM -0500, Felipe Balbi wrote:
> > On Thu, Sep 25, 2014 at 01:27:18PM +0530, Vinod Koul wrote:
> > > On Wed, Sep 24, 2014 at 03:32:19PM -0500, Felipe Balbi wrote:
> > > > > > > OK, I guess this is as good as it gets.
> > > > > > >=20
> > > > > > > What tree would you like it go through?
> > > > > >=20
> > > > > > Do we really need this new helper ? I mean, the very moment when =
> we
> > > > > > decide to implement ->runtime_idle() we will need to get rid of t=
> his
> > > > > > change. I wonder if it's really valid...
> > > > >=20
> > > > > I'm not sure I'm following?  This seems to simply implement what dr=
> ivers
> > > > > have been doing already as one function.  Why would it be invalid t=
> o reduce
> > > > > code duplication?
> > > >=20
> > > > For two reasons:
> > > >=20
> > > > 1) the helper has no inteligence whatsoever. It just calls the same
> > > > functions.
> > > >=20
> > > > 2) the duplication will vanish whenever someone implements
> > > > ->runtime_idle() and have that call pm_runtime_autosuspend() (like PCI
> > > > and USB buses are doing today). This will just be yet another line th=
> at
> > > > needs to change.
> > > >=20
> > > > Frankly though, no strong feelings, I just think it's a commit that
> > > > doesn't bring that any benefits other than looking like one line was
> > > > removed.
> > > and yes that is what it tries to do nothing more nothing less. If in fu=
> ture
> > > there are no users (today we have quite a few), then we can remove the =
> dead
> > > macro, no harm. But that is not the situation today.
> >=20
> > as I said, a commit that's bound to be useless. It's not like you're
> > saving 10 lines of code, it's only one. Replacing two simple lines with
> > a function which takes <joke> almost as many characters to type </joke>.
> >=20
> > IMO, this is pretty useless and I'd rather not see them in the drivers I
> > maintain, sorry.
> 
> It is not a NACK from me; yet from a high-level perspective I agree with
> Felipe.

OK

I'd rather not merge something that driver people don't want to use.

Vinod?

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
