Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988AbaD1NPE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 09:15:04 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:50519 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755757AbaD1NPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 09:15:00 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-3a-535e545241d3
Message-id: <1398690896.12945.2.camel@AMDC1943>
Subject: Re: [PATCH 1/2] mfd: max14577: Fix IRQ handling after resume if this
 is not a wakeup source
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Sangbeom Kim <sbkim73@samsung.com>,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Mon, 28 Apr 2014 15:14:56 +0200
In-reply-to: <20140428121053.GA21279@lee--X1>
References: <1398175162-20244-1-git-send-email-k.kozlowski@samsung.com>
 <20140428121053.GA21279@lee--X1>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu1
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsVy+t/xy7pBIXHBBi3HxCw2zljPanG26Q27
	xf2vRxktLu+aw2ax9shddovT3awWF1d8YXJg97hzbQ+bx7yTgR59W1YxenzeJBfAEsVlk5Ka
	k1mWWqRvl8CV8Xf1SfaCfq6KhtmH2BoY/7F3MXJySAiYSNz9fwrKFpO4cG89G4gtJLCUUeLG
	FT4I+zOjxNNLjiA2r4C+xOk/W5hAbGGBNImGt1vA6tkEjCU2L18CZHNwiAioSJx7Y97FyMXB
	LPCPUWLVoa3MIDUsAqoS7z6+AtvFKaAr0d/6nAVifpbErDcfGEFsZgF1iUnzFjFD3KMsMW//
	MSaIvYISPybfY4GokZfYvOYt8wRGgVlIWmYhKZuFpGwBI/MqRtHU0uSC4qT0XEO94sTc4tK8
	dL3k/NxNjJCg/rKDcfExq0OMAhyMSjy8KxRigoVYE8uKK3MPMUpwMCuJ8E53jQsW4k1JrKxK
	LcqPLyrNSS0+xMjEwSnVwKidYe5+/todJtWi+HWqn6xap/TJ7BaZtXZ1VaHNponCyc3n1JZO
	TK65Hmzk/LTrZeUTqUsGzTJvJlxU9X/PaHLC/7zk2VsiMyLy13iYsV37cj/GsqzOr+pEScaC
	w/t+r+1eoNGtIrVrBd+6wHlusyyfLIntXS5ve/NCq+W349lyniwnFSwD5yixFGckGmoxFxUn
	AgB/evHQSAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pon, 2014-04-28 at 13:10 +0100, Lee Jones wrote:
> > During suspend the IRQ should be disabled even if this is not a wakeup
> > source. This is a proper way of fixing the IRQ handling issue during
> > resume (IRQ handler fails because I2C bus did not resume yet).
> > 
> > When device is suspended and max14577 interrupt is signaled the irq chip
> > will try to handle it regardless of wakeup source. Device could be woken
> > up by different IRQ but still the IRQ handler will try to read the
> > registers over I2C bus and fail because I2C bus won't be ready yet:
> > 	max14577 2-0025: Failed to read IRQ status: -5
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > ---
> >  drivers/mfd/max14577.c | 29 +++++++++++++----------------
> >  1 file changed, 13 insertions(+), 16 deletions(-)
> 
> It's pretty worrying that these two patches are so alike and they
> actually change different files. Is there any way we can unify more of
> the code?
> 
> Patch applied, thanks.

This whole problem happens also on other MAXIM devices on our boards so
actually the real issue could sit in I2C bus controller or S3C PM
suspend/resume code. This is however the easiest fix for now...

Thanks for applying the patches.

Best regards,
Krzysztof

