Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935932Ab3DJKSQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 06:18:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44704 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935724Ab3DJKSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 06:18:13 -0400
Message-ID: <51653C5D.4060408@suse.cz>
Date: Wed, 10 Apr 2013 12:18:05 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH/RFC] m68k: Add -ffreestanding to KBUILD_CFLAGS
References: <1365585879-5321-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1365585879-5321-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Added Andi to CC)

On 10.4.2013 11:24, Geert Uytterhoeven wrote:
[...]
> E.g. gcc turned
> 
>     strncat(name, "%d", 2);
> 
> into a call to strlen() and a 16-bit store, causing a link failure, as
> arch/m68k/include/asm/string.h provides strlen() using a macro:
> 
>     ERROR: "strlen" [net/ipv4/ip_tunnel.ko] undefined!
[...]
> QUESTION: Should we re-enable -ffreestanding in the main Makefile instead?
> 
> It was removed in
> 
> commit 6edfba1b33c701108717f4e036320fc39abe1912
> Author: Andi Kleen <ak@suse.de>
> Date:   Sat Mar 25 16:29:49 2006 +0100
> 
>     [PATCH] x86_64: Don't define string functions to builtin

My understanding is, that with -fnobuiltin, the compiler is not allowed
to make assumptions about functions if it does not see their definition,
even if they resemble standard functions. E.g. on x86_64, strlen() is
out-of-line, so gcc would have to assume, that strcmp() has side
effects. How about just naming the m68k inline function 'strlen'?

Michal
