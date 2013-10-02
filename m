Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab3JBQoG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 12:44:06 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:65305 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716Ab3JBQoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 12:44:03 -0400
Date: Wed, 2 Oct 2013 11:43:59 -0500
From: Kim Phillips <kim.phillips@linaro.org>
To: taras.kondratiuk@linaro.org
Cc: sameo@linux.intel.com, lee.jones@linaro.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-networking@linaro.org,
        d.xie@sta.samsung.com
Subject: Re: [LNG] [PATCH] mfd: twl6030: Fix endianness problem in IRQ
 handler
Message-Id: <20131002114359.681cbdf92bd683373f07cca2@linaro.org>
In-Reply-To: <1380712124-20666-1-git-send-email-taras.kondratiuk@linaro.org>
References: <1380712124-20666-1-git-send-email-taras.kondratiuk@linaro.org>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  2 Oct 2013 14:08:44 +0300
Taras Kondratiuk <taras.kondratiuk@linaro.org> wrote:

> From: Danke Xie <d.xie@sta.samsung.com>
> 
> The current TWL 6030 IRQ handler assumes little endianness.
> This change makes it endian-neutral.
> 
> Signed-off-by: Danke Xie <d.xie@sta.samsung.com>
> Signed-off-by: Taras Kondratiuk <taras.kondratiuk@linaro.org>
> ---

this patch causes a new sparse warning:

make C=2 CF="-D__CHECK_ENDIAN__" drivers/mfd/twl6030-irq.o
...
  CHECK   drivers/mfd/twl6030-irq.c
drivers/mfd/twl6030-irq.c:200:19: warning: cast to restricted __le32

does int_sts in the sts union need to be defined as __le32?

Thanks,

Kim
