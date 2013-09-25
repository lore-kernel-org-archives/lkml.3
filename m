Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008Ab3IYJjM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 05:39:12 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38137 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989Ab3IYJjL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 05:39:11 -0400
From: =?iso-8859-15?q?J=FCrgen_Beisert?= <jbe@pengutronix.de>
Organization: Pengutronix e.K.
To: linux-kernel@vger.kernel.org
Subject: Re: ARM/Samsung/S3C24xx: Linux-3.11 crashes when using PWM
Date: Wed, 25 Sep 2013 11:40:36 +0200
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene.kim@samsung.com>, linux-samsung-soc@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>
References: <201309251029.44265.jbe@pengutronix.de> <5242AA7C.4010905@samsung.com>
In-Reply-To: <5242AA7C.4010905@samsung.com>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201309251140.36582.jbe@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5e26:aff:fe2b:7cc4
X-SA-Exim-Mail-From: jbe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sylwester,

On Wednesday 25 September 2013 11:18:52 Sylwester Nawrocki wrote:
> On 25/09/13 10:29, Jürgen Beisert wrote:
> > Change one single line:
> >
> > diff --git a/arch/arm/mach-s3c24xx/mach-mini2440.c
> > b/arch/arm/mach-s3c24xx/mach-mini2440.c index a83db46..d8273da 100644
> > --- a/arch/arm/mach-s3c24xx/mach-mini2440.c
> > +++ b/arch/arm/mach-s3c24xx/mach-mini2440.c
> > @@ -519,6 +519,7 @@ static struct platform_device *mini2440_devices[]
> > __initdata = { &s3c_device_iis,
> >         &uda1340_codec,
> >         &mini2440_audio,
> > +       &s3c_device_timer[0],
> >  };
>
> I think you need to add instead:
>
> 	&samsung_device_pwm,
>
> IIRC I had this working, can't verify at the moment as I don't
> have access to the board right now. Please see commit:
>
> 7fa33bdb4c44155e390c9ebbc5aa4c5cfc73f6fa
> ARM: SAMSUNG: Modify board files to use new PWM platform device

Seems valid for 3.12, but not for 3.11.

Regards,
Juergen

-- 
Pengutronix e.K.                              | Juergen Beisert             |
Linux Solutions for Science and Industry      | http://www.pengutronix.de/  |
