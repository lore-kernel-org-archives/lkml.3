Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757665Ab3ENOlE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 10:41:04 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:62420 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909Ab3ENOlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 10:41:03 -0400
Date: Tue, 14 May 2013 15:40:57 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Ulf Hansson <ulf.hansson@stericsson.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Paer-Olof Haakansson <par-olof.hakansson@stericsson.com>
Subject: Re: [PATCH] mfd: db8500-prcmu: Update stored DSI PLL divider value
Message-ID: <20130514144057.GH28781@gmail.com>
References: <1368537295-23459-1-git-send-email-ulf.hansson@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1368537295-23459-1-git-send-email-ulf.hansson@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 May 2013, Ulf Hansson wrote:

> From: Ulf Hansson <ulf.hansson@linaro.org>
> 
> Previously the DSI PLL divider rate was initialised statically and
> assumed to be 1. Before the common clock framework were enabled for
> ux500, a call to clk_set_rate() would always update the HW registers
> no matter what the current setting was.
> 
> This patch makes sure the actual hw settings and the sw assumed
> settings are matched.
> 
> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
> Signed-off-by: Paer-Olof Haakansson <par-olof.hakansson@stericsson.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/mfd/db8500-prcmu.c |    2 ++
>  1 file changed, 2 insertions(+)

I understand that this is causing an issue for the Multimedia guys who
use this. As it's causing an issue and you are 'the' ST-E clock guru,
I'll tentatively apply this to my v3.10 -fixes branch.

If anyone has any arguments against it, please step forward.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
