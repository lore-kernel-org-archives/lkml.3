Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920Ab3GXUaK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 16:30:10 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:50917 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788Ab3GXUaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 16:30:05 -0400
Date: Wed, 24 Jul 2013 13:30:03 -0700
From: David Brown <davidb@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH 2/4] msm_serial: Fix sparse warnings
Message-ID: <20130724203003.GC10926@codeaurora.org>
References: <1374691051-28544-1-git-send-email-sboyd@codeaurora.org>
 <1374691051-28544-3-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1374691051-28544-3-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 11:37:29AM -0700, Stephen Boyd wrote:
>drivers/tty/serial/msm_serial.c:302:6: warning: symbol 'msm_set_mctrl' was
>not declared. Should it be static?
>drivers/tty/serial/msm_serial.c:597:17: warning: incorrect type in argument 2
>(different address spaces)
>drivers/tty/serial/msm_serial.c:597:17: expected void volatile [noderef] <asn:2>*addr
>drivers/tty/serial/msm_serial.c:597:17: got unsigned int *
>drivers/tty/serial/msm_serial.c:608:33: warning: incorrect type in argument 1
>(different address spaces)
>drivers/tty/serial/msm_serial.c:608:33: expected void volatile [noderef] <asn:2>*addr
>drivers/tty/serial/msm_serial.c:608:33: got unsigned int *gsbi_base
>drivers/tty/serial/msm_serial.c:648:37: warning: incorrect type in assignment
>(different address spaces)
>drivers/tty/serial/msm_serial.c:648:37: expected unsigned int *gsbi_base
>drivers/tty/serial/msm_serial.c:648:37: got void [noderef] <asn:2>*
>
>Mark the ioremapped memory as __iomem and use writel instead of
>iowrite because we're not dealing with PCI devices. Also, mark
>msm_set_mctrl() static because it isn't used outside this file.
>
>Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>---
> drivers/tty/serial/msm_serial.c | 17 +++++++----------
> 1 file changed, 7 insertions(+), 10 deletions(-)

Acked-by: David Brown <davidb@codeaurora.org>

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
