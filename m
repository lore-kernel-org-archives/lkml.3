Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965077AbaE2Psa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 11:48:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39577 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932848AbaE2Ps3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 11:48:29 -0400
Date: Thu, 29 May 2014 08:52:05 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Rob Herring <robherring2@gmail.com>
Cc: Satish Patel <satish.patel@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Landley <rob@landley.net>, Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH v3 1/5] sc_phy:SmartCard(SC) PHY interface to SC
 controller
Message-ID: <20140529155205.GB32214@kroah.com>
References: <1401267437-22489-1-git-send-email-satish.patel@ti.com>
 <1401267437-22489-2-git-send-email-satish.patel@ti.com>
 <20140528185334.GA30763@kroah.com>
 <5386F0FE.7040003@ti.com>
 <CAL_Jsq+E7a=wh_yzQyaSEVAwfa34BYZ4DxvLOfJGFVDsf1dZ+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_Jsq+E7a=wh_yzQyaSEVAwfa34BYZ4DxvLOfJGFVDsf1dZ+A@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 08:47:31AM -0500, Rob Herring wrote:
> On Thu, May 29, 2014 at 3:34 AM, Satish Patel <satish.patel@ti.com> wrote:
> >
> >
> > On 5/29/2014 12:23 AM, Greg KH wrote:
> >>
> >> On Wed, May 28, 2014 at 02:27:13PM +0530, Satish Patel wrote:
> >>>
> >>> SmartCard controller uses this interface to communicate with
> >>> SmartCard via PHY
> >>>
> >>> Some SmartCard PHY has multiple slots for cards.
> >>> This inerface also enables controller to communicate
> >>> with one or more SmartCard connected over phy.
> >>>
> >>> interface structure includes following APIs
> >>> - set/get config
> >>> - activate/deactivate smart card
> >>> - warm reset
> >>> - register_notify (for card insert/remove/overheat)
> >>> - unregister_notify
> >>>
> >>> Signed-off-by: Satish Patel <satish.patel@ti.com>
> >>> ---
> >>>   Documentation/sc_phy.txt |  171
> >>> ++++++++++++++++++++++++++++++++++++++++++++++
> >>>   include/linux/sc_phy.h   |  136 ++++++++++++++++++++++++++++++++++++
> >>>   2 files changed, 307 insertions(+)
> >>>   create mode 100644 Documentation/sc_phy.txt
> >>>   create mode 100644 include/linux/sc_phy.h
> >>
> >>
> >> These are .h files, but where is the "api" functions that use
> >> these structures defined at?
> >>
> > This is like template/wrappers, smart card phy driver will write API
> > functions. And smartcard controller will call these functions.
> > With proposed approach, smartcard controller can communicate with any smart
> > card phy (TI/NxP) without change in code. Using DT entry smartcard and PHY
> > will gets connected with each other.
> > Refer diagram given @Documentation/sc_phy.txt.
> >
> >
> >> confused,
> 
> I believe the api Greg is wondering about is the notifier which as I
> commented is not a good design.

That, and the fact that if this really is an "api", there are no .c
files for it like a "normal" api is in the kernel.

> There is now a phy subsystem. I don't know if it has what you need,
> but you should look at it to determine if it will work or could be
> extended to work.

I agree.  Satish, what's wrong with our existing phy layer?

greg k-h
