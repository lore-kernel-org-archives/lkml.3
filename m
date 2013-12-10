Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343Ab3LJNw4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 08:52:56 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:65528 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776Ab3LJNwx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 08:52:53 -0500
X-AuditID: cbfec7f4-b7f966d0000003d9-c5-52a71cb36d86
From: Tomasz Figa <t.figa@samsung.com>
To: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Chander Kashyap <chander.kashyap@linaro.org>
Subject: Re: [PATCH] serial: samsung: move clock deactivation below uart
 registration
Date: Tue, 10 Dec 2013 14:52:40 +0100
Message-id: <4640026.L8HxPz97OG@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11.3 (Linux/3.11.5-gentoo; KDE/4.11.3; x86_64; ; )
In-reply-to: <201312050054.39327.heiko@sntech.de>
References: <201312050054.39327.heiko@sntech.de>
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=iso-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCLMWRmVeSWpSXmKPExsVy+t/xy7qbZZYHGbRvErN4uP4mi0Xz4vVs
	Fv8fvWa1+Px7F6tF74KrbBaXd81hs5hxfh+TxZnFvewOHB53ru1h89g/dw27R9+WVYwe26/N
	Y/Y4s+AIu8fnTXIBbFFcNimpOZllqUX6dglcGaf37mMq6Oas2HHpNFMD4yr2LkZODgkBE4lt
	S04wQdhiEhfurWfrYuTiEBJYyiix8cYDVgini0miafUNNpAqNgE1ic8Nj8BsEQEziWdL9rOC
	2MwCnUwSu+cGgdjCAuESTy4uZQSxWQRUJY7sPQFWzyugKTF7zkEWEJtfQF3i3banYJtFBdwk
	XuzbAnYRp4ChxMOWU2BxIQEDiYaj/ewQvYISPybfY4HYpS3x5N0FqL06Er3fvzFPYBSchaRs
	FpKyWUjKFjAyr2IUTS1NLihOSs811CtOzC0uzUvXS87P3cQIiYkvOxgXH7M6xCjAwajEw1vA
	sCxIiDWxrLgy9xCjBAezkgjvthdAId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYzKzzMnewdve1hV
	a5XOfHmSc5EQ89sjub+eL9r8dD+vMUuw3XHJS+IlKUzfJuZPPP5DcLP0EtYjPvtvFaUyCp0W
	Nry/4O2BiECtZNnc7vV+986L5pVMX3Mhoef/imWOK7c6HJx7rL69cWN1iaK5SouhStCX1w93
	7RE93LO50l0+u2DZobg0+wVKLMUZiYZazEXFiQB9Fav6ZwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Heiko,

On Thursday 05 of December 2013 00:54:38 Heiko Stübner wrote:
> Commit 60e93575476f (serial: samsung: enable clock before clearing pending
> interrupts during init) added handling of the controller clock during init.
> 
> On most systems this clock is also one of the baud_clock sources and
> possibly used by the earlycon and thus already enabled by the bootloader.
> 
> Therefore a gap exists between s3c24xx_serial_init_port disabling the
> clock and an attached console reenabling it, making the transition from
> earlycon to regular console possibly hang the system - as seen on my
> S3C2442 based Freerunner today.
> 
> Therefore move the disabling of the clock from s3c24xx_serial_init_port
> below the uart port registration, effectively creating an overlap and
> keeping the clock running non-stop if the console wants to grab this port.
> 
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> ---
>  drivers/tty/serial/samsung.c |    8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)

Makes sense.

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz

