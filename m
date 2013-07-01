Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060Ab3GAHw5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 03:52:57 -0400
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:33554 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457Ab3GAHw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 03:52:56 -0400
X-Greylist: delayed 354 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Jul 2013 03:52:56 EDT
Date: Mon, 1 Jul 2013 17:46:48 +1000 (EST)
From: Finn Thain <fthain@telegraphics.com.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] m68k/mac: Allocate IOP message pool and queues
 dynamically
In-Reply-To: <1372586542-1318-1-git-send-email-geert@linux-m68k.org>
Message-ID: <alpine.LNX.2.00.1307011325520.9968@nippy.intranet>
References: <1372586542-1318-1-git-send-email-geert@linux-m68k.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 30 Jun 2013, Geert Uytterhoeven wrote:

> +static void __init alloc_msg_queue(int iop_num)
> +{
> +	iop_send_queue[iop_num] =
> +		kzalloc(NUM_IOP_CHAN * sizeof(**iop_send_queue), GFP_KERNEL);
> +	iop_listeners[iop_num] =
> +		kzalloc(NUM_IOP_CHAN * sizeof(**iop_listeners), GFP_KERNEL);

Perhaps we should panic on allocation failure? It might upset the static 
checkers otherwise. Can be done in another patch I guess.

> -
> -/*
> - * Register the interrupt handler for the IOPs.
> - * TODO: might be wrong for non-OSS machines. Anyone?
> - */
> -
> -void __init iop_register_interrupts(void)
> -{
> -	if (iop_ism_present) {
> +		/*
> +		 * Register the interrupt handler for the IOPs.
> +		 * TODO: might be wrong for non-OSS machines. Anyone?

My testing with a non-OSS machine (Quadra 950) indicates that the TODO is 
obsolete. And the comment "register the interrupt handler for the IOPs" is 
a bit silly. It merely re-phrases the code. Otherwise, this patch looks 
good to me. Thanks.

Finn
