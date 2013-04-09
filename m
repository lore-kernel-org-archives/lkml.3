Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935347Ab3DIX6K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 19:58:10 -0400
Received: from mx90.inbox01.com ([198.174.52.90]:41044 "EHLO mx90.inbox01.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765050Ab3DIX6I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 19:58:08 -0400
X-Greylist: delayed 508 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Apr 2013 19:58:08 EDT
From: Greg Veintimilla <gveintimilla@freewave.com>
To: Sekhar Nori <nsekhar@ti.com>, Prabhakar lad <prabhakar.csengg@gmail.com>
CC: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH v9 1/2] ARM: davinci: dm365: add support for v4l2 video
	display
Thread-Topic: [PATCH v9 1/2] ARM: davinci: dm365: add support for v4l2 video
	display
Thread-Index: AQHONRhAzUoaRZfAakexNcZMwQjru5jOj4Jg
Date: Tue, 9 Apr 2013 23:49:35 +0000
Message-ID: <DA5C8125AAC0C2489F8E8E003A30ECAA022E22@MB21.inbox01.com>
References: <1365412636-3468-1-git-send-email-prabhakar.csengg@gmail.com>
	<1365412636-3468-2-git-send-email-prabhakar.csengg@gmail.com>
 <51640004.6020604@ti.com>
In-Reply-To: <51640004.6020604@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [199.117.8.14]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please remove me from this list. Thanks

-----Original Message-----
From: davinci-linux-open-source-bounces+ttran=freewave.com@linux.davincidsp.com [mailto:davinci-linux-open-source-bounces+ttran=freewave.com@linux.davincidsp.com] On Behalf Of Sekhar Nori
Sent: Tuesday, April 09, 2013 5:48 AM
To: Prabhakar lad
Cc: DLOS; LKML; LAK
Subject: Re: [PATCH v9 1/2] ARM: davinci: dm365: add support for v4l2 video display

On 4/8/2013 2:47 PM, Prabhakar lad wrote:
> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>
> Create platform devices for various video modules like venc,osd, vpbe
> and v4l2 driver for dm365.
>
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> Acked-by: Sekhar Nori <nsekhar@ti.com>
> ---

> diff --git a/arch/arm/mach-davinci/davinci.h
> b/arch/arm/mach-davinci/davinci.h index 12d544b..a9de512 100644
> --- a/arch/arm/mach-davinci/davinci.h
> +++ b/arch/arm/mach-davinci/davinci.h
> @@ -36,8 +36,13 @@
>  #include <media/davinci/vpbe_osd.h>
>
>  #define DAVINCI_SYSTEM_MODULE_BASE   0x01c40000
> +#define SYSMOD_VDAC_CONFIG           0x2c
>  #define SYSMOD_VIDCLKCTL             0x38
>  #define SYSMOD_VPSS_CLKCTL           0x44
> +#define VPSS_VENCCLKEN_ENABLE                BIT(3)
> +#define VPSS_DACCLKEN_ENABLE         BIT(4)
> +#define VPSS_PLLC2SYSCLK5_ENABLE     BIT(5)
> +

Prabhakar, I noticed it only after I applied these patches, but these bit definitions in between list of register offsets is distracting. Can you please move them down after the register offsets when you send the pull request? You can add a comment /* VPSS CLKCTL bit definitions */ before you start the bit definitions.

>  #define SYSMOD_VDD3P3VPWDN           0x48
>  #define SYSMOD_VSCLKDIS                      0x6c
>  #define SYSMOD_PUPDCTL1                      0x7c

Thanks,
Sekhar
_______________________________________________
Davinci-linux-open-source mailing list
Davinci-linux-open-source@linux.davincidsp.com
http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source
IMPORTANT NOTICE:  This communication, including any attachments, is the property of FreeWave Technologies, Inc. and may contain proprietary, confidential, or privileged information. Unauthorized use or disclosure of this communication is strictly prohibited and may be unlawful. Information contained herein may be subject to a Proprietary Information / Non-Disclosure Agreement and shall be maintained in confidence and not disclosed to third parties without the written consent of FreeWave Technologies, Inc. If you have received this communication in error, please immediately notify the sender and destroy all copies of the communication and any attachments.
