Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760411Ab3GSRJ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 13:09:26 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:35267 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab3GSRJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 13:09:24 -0400
Message-ID: <51E972C2.4040501@free-electrons.com>
Date: Fri, 19 Jul 2013 19:09:22 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Organization: Free Electrons
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Hector Palacios <hector.palacios@digi.com>
CC: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, marex@denx.de, jic23@kernel.org,
        lars@metafoo.de, fabio.estevam@freescale.com
Subject: Re: [PATCH v2 1/5] iio: mxs-lradc: change the realbits to 12
References: <1374225208-28940-1-git-send-email-hector.palacios@digi.com> <1374225208-28940-2-git-send-email-hector.palacios@digi.com>
In-Reply-To: <1374225208-28940-2-git-send-email-hector.palacios@digi.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/07/2013 11:13, Hector Palacios wrote:
> The LRADC virtual channels have an 18 bit field to store the sum of up
> to 2^5 accumulated samples. The read_raw function however only operates
> over a single sample (12 bit resolution).
> In order to use this field for scaling operations, we need it to be the
> exact resolution value of the LRADC.
> Besides, the driver was using an 18 bit mask (LRADC_CH_VALUE_MASK) to
> report touch coordinates to userland. A 12 bit mask should be used instead
> or else the touch libraries will expect a coordinates range between 0
> and 0x3ffff (18 bits), instead of between 0 and 0xfff (12 bits).
>
> Signed-off-by: Hector Palacios <hector.palacios@digi.com>
> ---
>

Looks good to me:

Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

