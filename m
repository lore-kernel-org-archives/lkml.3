Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760265AbaCUI0T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 04:26:19 -0400
Received: from mga11.intel.com ([192.55.52.93]:9560 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751756AbaCUI0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 04:26:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,702,1389772800"; 
   d="scan'208";a="503513731"
Date: Fri, 21 Mar 2014 10:26:09 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: jon@ringle.org
Cc: gregkh@linuxfoundation.org, jslaby@suse.cz, shc_work@mail.ru,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        devicetree@vger.kernel.org, Jon Ringle <jringle@gridpoint.com>
Subject: Re: [PATCH v2] tty: serial: sc16is7xx
Message-ID: <20140321082609.GA3801@xps8300>
References: <1395324333-21221-1-git-send-email-jon@ringle.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1395324333-21221-1-git-send-email-jon@ringle.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Mar 20, 2014 at 10:05:33AM -0400, jon@ringle.org wrote:
> From: Jon Ringle <jringle@gridpoint.com>
> 
> The SC16IS7xx is a slave I2C-bus/SPI interface to a single-channel
> high performance UART. The SC16IS7xx’s internal register set is
> backward-compatible with the widely used and widely popular 16C450.

So couldn't this be just a probe driver for 8250?

> +/* SC16IS7XX register definitions */
> +#define SC16IS7XX_RHR_REG		(0x00) /* RX FIFO */
> +#define SC16IS7XX_THR_REG		(0x00) /* TX FIFO */
> +#define SC16IS7XX_IER_REG		(0x01) /* Interrupt enable */
> +#define SC16IS7XX_IIR_REG		(0x02) /* Interrupt Identification */
> +#define SC16IS7XX_FCR_REG		(0x02) /* FIFO control */
> +#define SC16IS7XX_LCR_REG		(0x03) /* Line Control */
> +#define SC16IS7XX_MCR_REG		(0x04) /* Modem Control */
> +#define SC16IS7XX_LSR_REG		(0x05) /* Line Status */
> +#define SC16IS7XX_MSR_REG		(0x06) /* Modem Status */
> +#define SC16IS7XX_SPR_REG		(0x07) /* Scratch Pad */

At least there should not be any need to redefine those register or
their bits. Just include serial_reg.h.

Thanks,

-- 
heikki
