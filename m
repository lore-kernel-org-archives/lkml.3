Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235Ab3HGIlE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 04:41:04 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:48525 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757186Ab3HGIlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 04:41:00 -0400
Date: Wed, 7 Aug 2013 09:40:54 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Zubair Lutfullah <zubair.lutfullah@gmail.com>
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, bigeasy@linutronix.de
Subject: Re: [PATCH] mfd: ti_am335x_tscadc: fix spin lock and reg_cache
Message-ID: <20130807084054.GA18668@lee--X1>
References: <1375729845-6992-1-git-send-email-zubair.lutfullah@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1375729845-6992-1-git-send-email-zubair.lutfullah@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Aug 2013, Zubair Lutfullah wrote:

> Reg_cache variable is used to lock step enable register
> from being accessed and written by both TSC and ADC
> at the same time.
> However, it isn't updated anywhere in the code at all.
> 
> If both TSC and ADC are used, eventually 1FFFF is always
> written enabling all 16 steps uselessly causing a mess.
> 
> Patch fixes it by correcting the locks and updates the
> variable by reading the step enable register
> 
> Signed-off-by: Zubair Lutfullah <zubair.lutfullah@gmail.com>
> ---
>  drivers/mfd/ti_am335x_tscadc.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Better that it comes from somewhere.

Applied, thanks.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
