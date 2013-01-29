Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214Ab3A2PFA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 10:05:00 -0500
Received: from mga09.intel.com ([134.134.136.24]:13104 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756742Ab3A2PE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 10:04:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,561,1355126400"; 
   d="scan'208";a="254238235"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, shurd@broadcom.com, mchan@broadcom.com
Subject: Re: [PATCH] 8250/16?50: Add support for Broadcom TruManage redirected serial port
In-Reply-To: <1358460893-11098-1-git-send-email-mchan@broadcom.com>
References: <1358460893-11098-1-git-send-email-mchan@broadcom.com>
User-Agent: Notmuch/0.12+187~ga2502b0 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Tue, 29 Jan 2013 17:06:24 +0200
Message-ID: <87ip6gm3kf.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Chan <mchan@broadcom.com> writes:

> From: Stephen Hurd <shurd@broadcom.com>
>
> Add support for the UART device present in Broadcom TruManage capable
> NetXtreme chips (ie: 5761m 5762, and 5725).
>
> This implementation has a hidden transmit FIFO, so running in single-byte
> interrupt mode results in too many interrupts.  The UART_CAP_HFIFO
> capability was added to track this.  It continues to reload the THR as long
> as the THRE and TSRE bits are set in the LSR up to a specified limit (1024
> is used here).
>
> Signed-off-by: Stephen Hurd <shurd@broadcom.com>
> Signed-off-by: Michael Chan <mchan@broadcom.com>

Greg, this looks like a new feature, yet it was applied to -rc5 and
stable. Any reason for that? I'm asking because this patch doesn't seem
to have received enough reviewing/testing:

[skip platform bits]

> diff --git a/include/uapi/linux/serial_core.h b/include/uapi/linux/serial_core.h
> index 78f99d9..2c6c85f 100644
> --- a/include/uapi/linux/serial_core.h
> +++ b/include/uapi/linux/serial_core.h
> @@ -50,7 +50,8 @@
>  #define PORT_LPC3220	22	/* NXP LPC32xx SoC "Standard" UART */
>  #define PORT_8250_CIR	23	/* CIR infrared port, has its own driver */
>  #define PORT_XR17V35X	24	/* Exar XR17V35x UARTs */
> -#define PORT_MAX_8250	24	/* max port ID */
> +#define PORT_BRCM_TRUMANAGE	24
> +#define PORT_MAX_8250	25	/* max port ID */

This is a bug, TRUMANAGE should be 25 as well as PORT_MAX_8250.

Regards,
--
Alex
