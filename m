Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145AbaJXEzD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 00:55:03 -0400
Received: from asavdk3.altibox.net ([109.247.116.14]:44891 "EHLO
	asavdk3.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbaJXEzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 00:55:01 -0400
Date: Fri, 24 Oct 2014 06:54:55 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Miller <davem@davemloft.net>
Cc: mroos@linux.ee, linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: unaligned accesses in SLAB etc.
Message-ID: <20141024045454.GA8138@ravnborg.org>
References: <20141022.163949.1761351331649936601.davem@davemloft.net>
 <alpine.LRH.2.11.1410230221360.28745@adalberg.ut.ee>
 <20141023.130258.548864295965807596.davem@davemloft.net>
 <20141023.172258.1371479087269518956.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141023.172258.1371479087269518956.davem@davemloft.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A minor detail.

> [PATCH] sparc64: Fix register corruption in top-most kernel stack frame during boot.
> 
> -	call	start_kernel
> +	call start_early_boot

Maybe add a comment about stack use - as per your nice patch description.

> +void __init start_early_boot(void)

This will likely result in sparse complaining about:
fuction not declared - should it be static?

A prototype in include/asm/setup.h would be nice.

Other than this - very nice detective work!

	Sam
