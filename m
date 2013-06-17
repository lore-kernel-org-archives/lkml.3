Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152Ab3FQJIR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 05:08:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31395 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111Ab3FQJIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 05:08:16 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1371413189-2568-3-git-send-email-ddaney.cavm@gmail.com>
References: <1371413189-2568-3-git-send-email-ddaney.cavm@gmail.com> <1371413189-2568-1-git-send-email-ddaney.cavm@gmail.com>
To: ddaney.cavm@gmail.com
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        linux-ia64@vger.kernel.org,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        linux-am33-list@redhat.com, david.s.daney@gmail.com,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH 2/2] mn10300: Fix include dependency in irqflags.h
Date: Mon, 17 Jun 2013 10:07:59 +0100
Message-ID: <27908.1371460079@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ddaney.cavm@gmail.com wrote:

>  #ifndef __ASSEMBLY__
> -#include <linux/smp.h>
> +/* linux/smp.h <- linux/irqflags.h needs asm/smp.h first */
> +#include <asm/smp.h>
>  #endif

If you make this change, is the #ifndef __ASSEMBLY__ still necessary, I
wonder...

David
