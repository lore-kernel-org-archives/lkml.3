Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476AbaCXPay (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 11:30:54 -0400
Received: from smtp.adetelgroup.com ([94.247.26.71]:24519 "EHLO
	hbg-pa71.hmc-pa.adm" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752785AbaCXPaw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 11:30:52 -0400
Date: Mon, 24 Mar 2014 16:30:49 +0100 (CET)
From: CHAUMETTE Hubert <hchaumette@adeneo-embedded.com>
To: Eric =?utf-8?Q?B=C3=A9nard?= <eric@eukrea.com>
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        shawn guo <shawn.guo@linaro.org>, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Message-ID: <1762157698.5689069.1395675049240.JavaMail.zimbra@adeneo-embedded.com>
In-Reply-To: <20140321222320.14370739@e6520eb>
References: <1395421687-12934-1-git-send-email-hchaumette@adeneo-embedded.com> <20140321222320.14370739@e6520eb>
Subject: Re: [PATCH] ARM: i.MX6: update KSZ9031 phy fixup
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Mailer: Zimbra 8.0.6_GA_5922 (ZimbraWebClient - FF24 (Linux)/8.0.6_GA_5922)
Thread-Topic: i.MX6: update KSZ9031 phy fixup
Thread-Index: 9CGjHjvpqLnG5Sxh7swxcvNqEExmbA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

----- Original Message -----
> From: "Eric Bénard" <eric@eukrea.com>
> To: "Hubert Chaumette" <hchaumette@adeneo-embedded.com>
> Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk, "shawn guo" <shawn.guo@linaro.org>,
> linux-kernel@vger.kernel.org, kernel@pengutronix.de
> Sent: Friday, March 21, 2014 10:23:20 PM
> Subject: Re: [PATCH] ARM: i.MX6: update KSZ9031 phy fixup
> 
> Hi Hubert,
> 
> Le Fri, 21 Mar 2014 18:08:07 +0100,
> Hubert Chaumette <hchaumette@adeneo-embedded.com> a écrit :
> 
> > 
> > Update KSZ9031RN phy fixup for Congatec conga-QEVAL and conga-QMX6 combo :
> > set RGMII GTX_CLK and RX_CLK pad skew to +0.96ns.
> > 
> > Signed-off-by: Hubert Chaumette <hchaumette@adeneo-embedded.com>
> > ---
> >  arch/arm/mach-imx/mach-imx6q.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/arch/arm/mach-imx/mach-imx6q.c
> > b/arch/arm/mach-imx/mach-imx6q.c
> > index 76e5db4..db307c2 100644
> > --- a/arch/arm/mach-imx/mach-imx6q.c
> > +++ b/arch/arm/mach-imx/mach-imx6q.c
> > @@ -77,6 +77,9 @@ static int ksz9031rn_phy_fixup(struct phy_device *dev)
> >          mmd_write_reg(dev, 2, 5, 0);
> >          mmd_write_reg(dev, 2, 8, 0x003ff);
> >  
> > +        /* For Congatec conga-QMX6 board */
> > +        mmd_write_reg(dev, 0x02, 0x06, 0xffff);
> > +
> >          return 0;
> >  }
> >  
> that's board specific (the needed delay depends on the routing delay on
> the PCB), so this should not go in a generic file.
> 
> Eric
> 

I admit it may need to be in a separate function, but this file already contains
board-specific fixups (for imx6q sabrelite, Data Modul eDM-QMX6).

Anyway, do you have any suggestion for the location I should put it ?

Regards,

Hubert
