Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690AbaKCRUH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 12:20:07 -0500
Received: from down.free-electrons.com ([37.187.137.238]:55087 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751041AbaKCRUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 12:20:03 -0500
Message-ID: <5457B940.2030105@free-electrons.com>
Date: Mon, 03 Nov 2014 18:20:00 +0100
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: linux-arm-kernel@lists.infradead.org, Tawfik Bayouk <tawfik@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Lior Amsalem <alior@marvell.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        devicetree@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/17] irqchip: irq-armada-370-xp: use proper return value
 for ->set_affinity()
References: <1414151970-6626-1-git-send-email-thomas.petazzoni@free-electrons.com> <1414151970-6626-4-git-send-email-thomas.petazzoni@free-electrons.com>
In-Reply-To: <1414151970-6626-4-git-send-email-thomas.petazzoni@free-electrons.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On 24/10/2014 13:59, Thomas Petazzoni wrote:
> The ->set_affinity() hook of 'struct irq_chip' is supposed to return
> one of IRQ_SET_MASK_OK or IRQ_SET_MASK_OK_NOCOPY. However, the code
> currently simply returns 0. This patch fixes that by using
> IRQ_SET_MASK_OK, which tells the IRQ core that it is responsible for
> updating irq_data.affinity.

It seems that this driver is not the only one to return 0 instead of
IRQ_SET_MASK_OK in the >set_affinity(). I found also irq-xtensa-mx.c,
irq-metag.c and irq-metag-ext.c.


> 
> Note that this patch does not cause any change to the compiled code,
> as IRQ_SET_MASK_OK has the value 0. This is therefore just a simple
> cleanup.
> 
> Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/irqchip/irq-armada-370-xp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Gregory CLEMENT <gregory.clement@free-electrons.com>


Thanks,

Gregory

-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
