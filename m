Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682Ab3FGKa6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 06:30:58 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:53454 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225Ab3FGKa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 06:30:56 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: Doug Anderson <dianders@chromium.org>, Chris Ball <cjb@laptop.org>,
        Olof Johansson <olof@lixom.net>,
        Andrew Bresticker <abrestic@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Will Newton <will.newton@imgtec.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        lgirdwood@gmail.com
Subject: Re: [PATCH 1/2] mmc: dw_mmc: Handle late vmmc regulator with EPROBE_DEFER
Date: Fri, 07 Jun 2013 12:30:52 +0200
Message-ID: <1841650.N6Drbs67FD@flatron>
User-Agent: KMail/4.10.4 (Linux/3.9.4-gentoo; KDE/4.10.4; x86_64; ; )
In-Reply-To: <20130607102404.GO31367@sirena.org.uk>
References: <1370580406-10254-1-git-send-email-dianders@chromium.org> <1664692.GUOAAQ3FLn@flatron> <20130607102404.GO31367@sirena.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 of June 2013 11:24:04 Mark Brown wrote:
> On Fri, Jun 07, 2013 at 12:19:58PM +0200, Tomasz Figa wrote:
> > On Thursday 06 of June 2013 21:46:45 Doug Anderson wrote:
> > > dw_mmc is probed.  This regulator is optional, though a warning will
> > > be printed if it's missing.  The fact that the regulator is optional
> > > means that (at the moment) it's not possible to use a regulator that
> > > probes _after_ dw_mmc.
> > > 
> > > Fix this limitation by adding the ability to make vmmc required.  If
> > > a
> > > vmmc-supply is specified in the device tree we'll assume that vmmc
> > > is
> > > required.
> > 
> > This interesting case makes me think that regulator core should
> > differentiate between regulator lookup failure due to no lookup
> > specified and due to the regulator specified in lookup being
> > unavailable, returning appropriate (different) error codes.
> 
> It does exactly that in so far as it can - you get -ENODEV if there's
> definitely no supply and -EPROBE_DEFER otherwise.

Oh, right, thanks. I somehow felt that it should be doing this already, 
but I was looking at 3.9 on Free Electron's LXR. It does so since commit

1e4b545cdd regulator: core: return err value for regulator_get if there is 
no DT binding

so I think this patch should be reworked to check the returned error code 
instead.

Best regards,
Tomasz

