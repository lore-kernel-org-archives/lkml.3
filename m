Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948Ab3LSWXr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 17:23:47 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:52411 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754228Ab3LSWXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 17:23:43 -0500
From: arno@natisbad.org (Arnaud Ebalard)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Rutland <mark.rutland@arm.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Jason Cooper <jason@lakedaemon.net>, Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>, rtc-linux@googlegroups.com,
        Linus Walleij <linus.walleij@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        devicetree@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        linux-arm-kernel@lists.infradead.org, Rob Landley <rob@landley.net>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Peter Huewe <peter.huewe@infineon.com>,
        Thierry Reding <treding@nvidia.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCHv7] rtc: Add support for Intersil ISL12057 I2C RTC chip
References: <72207bc152a06638f0e0e21a6e00d4c2054a1a71.1387489507.git.arno@natisbad.org>
	<20131219140726.e7d7ccf765da9b6be0ac3fa5@linux-foundation.org>
X-PGP-Key-URL: http://natisbad.org/arno@natisbad.org.asc
X-Fingerprint: D3A5 B68A 839B 38A5 815A 781B B77C 0748 A7AE 341B
X-Hashcash: 1:20:131219:jason@lakedaemon.net::rKXD6Um1MOUjqAdY:000000000000000000000000000000000000000000Wxx
X-Hashcash: 1:20:131219:akpm@linux-foundation.org::qcCzuNAf9N3Dx4nW:0000000000000000000000000000000000000BB8
X-Hashcash: 1:20:131219:a.zummo@towertech.it::1XOEpyD78n5UJ7rw:000000000000000000000000000000000000000000kum
X-Hashcash: 1:20:131219:linux-doc@vger.kernel.org::OrwfuPXBjc0yslsW:0000000000000000000000000000000000000nPh
X-Hashcash: 1:20:131219:jgunthorpe@obsidianresearch.com::n8at/8JzuRdvRbds:0000000000000000000000000000000mBC
X-Hashcash: 1:20:131219:grant.likely@linaro.org::AeydiSd6f6s0WAsc:000000000000000000000000000000000000001ilQ
X-Hashcash: 1:20:131219:broonie@kernel.org::rieQ5HQJgYzc3/hp:00000000000000000000000000000000000000000002BMV
X-Hashcash: 1:20:131219:rob@landley.net::DNS/UJ7/IPozybe7:002OeD
X-Hashcash: 1:20:131219:devicetree@vger.kernel.org::lMbOsR75g8wnuPQm:000000000000000000000000000000000002MD2
X-Hashcash: 1:20:131219:peter.huewe@infineon.com::7PFCPrfrBfqukVtc:00000000000000000000000000000000000002NSF
X-Hashcash: 1:20:131219:galak@codeaurora.org::knrXi/KwWAwKdsJ4:000000000000000000000000000000000000000003nT3
X-Hashcash: 1:20:131219:pawel.moll@arm.com::ZNBrPbsdB7udbSg9:000000000000000000000000000000000000000000045do
X-Hashcash: 1:20:131219:linux@roeck-us.net::Z2bqX4+S4hVRhx6g:000000000000000000000000000000000000000000046R4
X-Hashcash: 1:20:131219:linux-arm-kernel@lists.infradead.org::Kr5i5yvJj88IH7e+:00000000000000000000000003gee
X-Hashcash: 1:20:131219:rtc-linux@googlegroups.com::XEyTNwXXWUZVGw+H:000000000000000000000000000000000005oMM
X-Hashcash: 1:20:131219:treding@nvidia.com::zgiXVXmL88H31ouU:00000000000000000000000000000000000000000006g2t
X-Hashcash: 1:20:131219:ijc+devicetree@hellion.org.uk::7nu04W09Sjoq/uek:000000000000000000000000000000008Ay/
X-Hashcash: 1:20:131219:mark.rutland@arm.com::9adzSBPBnfwsCKPv:000000000000000000000000000000000000000009Ak5
X-Hashcash: 1:20:131219:linux-kernel@vger.kernel.org::9p8HQ6Y/0Ohnw1IW:0000000000000000000000000000000008c3X
X-Hashcash: 1:20:131219:linus.walleij@linaro.org::DEyKi8Tn3LDOddET:00000000000000000000000000000000000008r+6
X-Hashcash: 1:20:131219:swarren@wwwdotorg.org::3lPgfKV64/Ja7gQN:00000000000000000000000000000000000000008lEZ
X-Hashcash: 1:20:131219:rob.herring@calxeda.com::9cjAZtmqSw58Qeyp:000000000000000000000000000000000000008Vk8
Date: Thu, 19 Dec 2013 23:22:56 +0100
In-Reply-To: <20131219140726.e7d7ccf765da9b6be0ac3fa5@linux-foundation.org>
	(Andrew Morton's message of "Thu, 19 Dec 2013 14:07:26 -0800")
Message-ID: <87ob4c1nwf.fsf@natisbad.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Andrew Morton <akpm@linux-foundation.org> writes:

> On Thu, 19 Dec 2013 22:53:16 +0100 Arnaud Ebalard <arno@natisbad.org> wrote:
>
>> +static int isl12057_i2c_validate_chip(struct regmap *regmap)
>> +{
>> +	u8 regs[ISL12057_MEM_MAP_LEN];
>> +	u8 mask[ISL12057_MEM_MAP_LEN] = { 0x80, 0x80, 0x80, 0xf8,
>> +					  0xc0, 0x60, 0x00, 0x00,
>> +					  0x00, 0x00, 0x00, 0x00,
>> +					  0x00, 0x00, 0x60, 0x7c };
>> +	int ret, i;
>> +
>> +	ret = regmap_bulk_read(regmap, 0, regs, ISL12057_MEM_MAP_LEN);
>> +	if (ret)
>> +		return ret;
>> +
>> +	for (i = 0; i < ISL12057_MEM_MAP_LEN; ++i) {
>> +		if (regs[i] & mask[i])	/* check if bits are cleared */
>> +			return -ENODEV;
>> +	}
>> +
>> +	return 0;
>> +}
>
> When I build this for x86_64, mask[] is assembled on-stack at runtime:
>
> 	leaq	-48(%rbp), %r14	#, tmp130
> 	xorl	%esi, %esi	#
> 	movl	$16, %ecx	#,
> 	movq	%rax, %rdi	# regmap,
> 	incq	.LPBX1+552(%rip)	# *.LPBX1
> 	movb	$-128, -64(%rbp)	#, mask
> 	movq	%r14, %rdx	# tmp130,
> 	movb	$-128, -63(%rbp)	#, mask
> 	movb	$-128, -62(%rbp)	#, mask
> 	movb	$-8, -61(%rbp)	#, mask
> 	movb	$-64, -60(%rbp)	#, mask
> 	movb	$96, -59(%rbp)	#, mask
> 	movb	$0, -58(%rbp)	#, mask
> 	movb	$0, -57(%rbp)	#, mask
> 	movb	$0, -56(%rbp)	#, mask
> 	movb	$0, -55(%rbp)	#, mask
> 	movb	$0, -54(%rbp)	#, mask
> 	movb	$0, -53(%rbp)	#, mask
> 	movb	$0, -52(%rbp)	#, mask
> 	movb	$0, -51(%rbp)	#, mask
> 	movb	$96, -50(%rbp)	#, mask
> 	movb	$124, -49(%rbp)	#, mask
> 	call	regmap_bulk_read	#
>
> If we make `mask' static const, that all gets done at compile time instead:
>
> 	leaq	-48(%rbp), %r14	#, tmp134
> 	xorl	%esi, %esi	#
> 	movl	$16, %ecx	#,
> 	movq	%rax, %rdi	# regmap,
> 	incq	.LPBX1+552(%rip)	# *.LPBX1
> 	movq	%r14, %rdx	# tmp134,
> 	call	regmap_bulk_read	#
>
> much nicer.

Damned. That's a good argument for a v8 ;-) Give me some minutes to
assemble one.

Cheers,

a+
