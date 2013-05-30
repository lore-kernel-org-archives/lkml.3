Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759660Ab3E3AnW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 20:43:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6824 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752593Ab3E3AnQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 20:43:16 -0400
Date: Wed, 29 May 2013 21:42:50 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Jon Arne =?UTF-8?B?SsO4cmdlbnNlbg==?= <jonarne@jonarne.no>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        hans.verkuil@cisco.com, prabhakar.csengg@gmail.com,
        g.liakhovetski@gmx.de, ezequiel.garcia@free-electrons.com,
        timo.teras@iki.fi
Subject: Re: [RFC 3/3] saa7115: Implement i2c_board_info.platform data
Message-ID: <20130529214250.435b252b@redhat.com>
In-Reply-To: <1369860078-10334-4-git-send-email-jonarne@jonarne.no>
References: <1369860078-10334-1-git-send-email-jonarne@jonarne.no>
	<1369860078-10334-4-git-send-email-jonarne@jonarne.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, 29 May 2013 22:41:18 +0200
Jon Arne Jørgensen <jonarne@jonarne.no> escreveu:

> Implement i2c_board_info.platform_data handling in the driver so we can
> make device specific changes to the chips we support.
> 

...

> +struct saa7115_platform_data {
> +	/* Horizontal time constant */
> +	u8 saa7113_r08_htc;
> +
> +	u8 saa7113_r10_vrln;
> +	u8 saa7113_r10_ofts;
> +
> +	u8 saa7113_r12_rts0;
> +	u8 saa7113_r12_rts1;
> +
> +	u8 saa7113_r13_adlsb;
> +};

While this works, it makes harder to analyze what's changed there,
as the above nomenclature is too obfuscated.

The better would be if you could, instead, name the bits (or bytes)
that will require different data, like (I just got some random
bits from reg08, on saa7113 datasheet - I didn't actually checked
what bits are you using):

	unsigned pll_closed: 1;
	unsigned fast_mode: 1;
	unsigned fast_locking: 1;


-- 

Cheers,
Mauro
