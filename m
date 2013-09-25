Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836Ab3IYJS6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 05:18:58 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:38542 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab3IYJS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 05:18:56 -0400
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-15
X-AuditID: cbfec7f4-b7f0a6d000007b1b-ed-5242aa7e66f7
Content-transfer-encoding: 8BIT
Message-id: <5242AA7C.4010905@samsung.com>
Date: Wed, 25 Sep 2013 11:18:52 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
To: =?ISO-8859-15?Q?J=FCrgen_Beisert?= <jbe@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, Kukjin Kim <kgene.kim@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>
Subject: Re: ARM/Samsung/S3C24xx: Linux-3.11 crashes when using PWM
References: <201309251029.44265.jbe@pengutronix.de>
In-reply-to: <201309251029.44265.jbe@pengutronix.de>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMLMWRmVeSWpSXmKPExsVy+t/xq7p1q5yCDBZM4rOYtO4Ak8XBLQuZ
	LXoXXGWz2PT4GqvF5V1z2CxmnN/H5MDm8XfVC2aPzUvqPfr/Gnj0bVnF6PF5k1wAaxSXTUpq
	TmZZapG+XQJXxtJ3l5kKjrFVHJ4s2MC4gLWLkYNDQsBEYv1uiy5GTiBTTOLCvfVsXYxcHEIC
	SxklNs/8xgyS4BUQlPgx+R4LSD2zgLzEkUvZIGFmAV2Jdy2bWSHqPzFKrNi8jB2iXkvi6beN
	YDaLgKrE3RO/mUBsNgFDid6jfYwgtqhAgMTiJefYQWaKCFhLXF1pCDKHWWATo8TDq7dZQGqE
	BZwlZt15C1YvJGAsceXNSjYQmxPo5tPbrzJPYBSYheS8WQjnzUJy3gJG5lWMoqmlyQXFSem5
	hnrFibnFpXnpesn5uZsYIQH9ZQfj4mNWhxgFOBiVeHgFjjoGCbEmlhVX5h5ilOBgVhLhDV/s
	FCTEm5JYWZValB9fVJqTWnyIkYmDU6qBUbnovK7Jopr+S9fNHnBH9Ot8+M+be77cSNiZ+dCp
	xytnase1crI9vdgSESUqGuXz+bLQ2m93di7VemvYdqJFyE1avfKloMMx0bsLp9ieCuJZJHmi
	t5aB4Xa9XNt3m5SJXZLlZ7u0n2+awOVtISL9O3tzpdSbkMtROewKYqsZry/7dvnupxkblViK
	MxINtZiLihMBcbVWREYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jürgen,

On 25/09/13 10:29, Jürgen Beisert wrote:
> Change one single line:
> 
> diff --git a/arch/arm/mach-s3c24xx/mach-mini2440.c b/arch/arm/mach-s3c24xx/mach-mini2440.c
> index a83db46..d8273da 100644
> --- a/arch/arm/mach-s3c24xx/mach-mini2440.c
> +++ b/arch/arm/mach-s3c24xx/mach-mini2440.c
> @@ -519,6 +519,7 @@ static struct platform_device *mini2440_devices[] __initdata = {
>         &s3c_device_iis,
>         &uda1340_codec,
>         &mini2440_audio,
> +       &s3c_device_timer[0],
>  };

I think you need to add instead:

	&samsung_device_pwm,

IIRC I had this working, can't verify at the moment as I don't
have access to the board right now. Please see commit:

7fa33bdb4c44155e390c9ebbc5aa4c5cfc73f6fa
ARM: SAMSUNG: Modify board files to use new PWM platform device

--
Regards,
Sylwester
