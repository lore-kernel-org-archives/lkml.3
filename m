Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981Ab3E0RHU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 13:07:20 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:56012 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456Ab3E0RHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 13:07:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Subject: Re: [PATCH 02/14] misc/ep93xx_pwm: use {read,write}* instead of __raw_* versions for io
Date: Mon, 27 May 2013 19:07:14 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Ryan Mallon <rmallon@gmail.com>,
        "mcrapet@gmail.com" <mcrapet@gmail.com>
References: <201305241621.50447.hartleys@visionengravers.com> <201305271718.41851.arnd@arndb.de> <ADE657CA350FB648AAC2C43247A983F0021DA666D43C@AUSP01VMBX24.collaborationhost.net>
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F0021DA666D43C@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201305271907.14742.arnd@arndb.de>
X-Provags-ID: V02:K0:4Wv1Kli78iNP+DfPCu5+h8S6jGuFT05tkHdmz7ZevTA
 on6wU8pr4vZT5jd/DN0uv+JKRAAW51AnrH9A4B/Yk6S6z7zM62
 PI/BiAEGvKVZC/yevyK98D/XLclJLnLDqmd+ZHnWDrBUb3ilT6
 ZRVgWCNFpI9YnhvQZ12/YUZ57xMv614wzHAL0NZuj3g/5FuawP
 ov5ZhsJrKQE+Fw9H/42wnTU1TJikZDINy690H0FTggDwowRe2X
 eweDqtnD88lyOKIHUuE5iwejdwtR+I2kojXPKEHWBbMyw4psnP
 AgcrX2sFhBIQxvXze3BEVoWIWUCDDeC0QS3JHOvwGvw+SKFj+5
 MP5RMpTfCiQyMMVkqMUo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 May 2013, H Hartley Sweeten wrote:
> On Monday, May 27, 2013 8:18 AM, Arnd Bergmann wrote:
> > On Saturday 25 May 2013, H Hartley Sweeten wrote:
> >> @@ -42,13 +42,13 @@ struct ep93xx_pwm {
> >>  static inline void ep93xx_pwm_writel(struct ep93xx_pwm *pwm,
> >>                 unsigned int val, unsigned int off)
> >>  {
> >> -       __raw_writel(val, pwm->mmio_base + off);
> >> +       writel(val, pwm->mmio_base + off);
> >>  }
> >
> > Just an idea: since you are adding the writel in a lot of places in subsequent
> > patches, you could rename 'mmio_base' to the shorter 'base' first, which would
> > make the resulting code actually smaller.
> 
> Hmm.. It would make the source file a bit smaller but the compiled size would
> be the same.

Right.

> But, I'll probably rename the variable when I convert this driver to the PWM
> framework.

Ok.

	Arnd

