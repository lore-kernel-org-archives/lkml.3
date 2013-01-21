Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab3AUXqw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 18:46:52 -0500
Received: from relais.videotron.ca ([24.201.245.36]:10585 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569Ab3AUXqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 18:46:50 -0500
X-Greylist: delayed 3600 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Jan 2013 18:46:50 EST
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Mon, 21 Jan 2013 17:46:48 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
To: Matt Sealey <matt@genesi-usa.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] crypto: fix FTBFS with ARM SHA1-asm and THUMB2_KERNEL
In-reply-to: <1358787763-1226-1-git-send-email-matt@genesi-usa.com>
Message-id: <alpine.LFD.2.02.1301211739470.6300@xanadu.home>
References: <1358787763-1226-1-git-send-email-matt@genesi-usa.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jan 2013, Matt Sealey wrote:

> The optimized assembler SHA1 code for ARM does not conform to Thumb2
> register usage requirements, so it cannot be built when the kernel is
> configured with THUMB2_KERNEL.
> 
> Fix the FTBFS for now by preventing misconfigurations of the kernel.
> 
> Signed-off-by: Matt Sealey <matt@genesi-usa.com>

A .arm directive at the top of the assembly code would be a better 
"fix", as that wouldn't reduce functionality.

Yet, I'd invite you to have a look at commit 638591cd7b in linux-next.


Nicolas
