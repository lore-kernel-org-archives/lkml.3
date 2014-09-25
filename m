Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050AbaIYBOM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 21:14:12 -0400
Received: from ozlabs.org ([103.22.144.67]:47368 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434AbaIYBOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 21:14:11 -0400
In-Reply-To: <1408482065-18457-1-git-send-email-bobby.prani@gmail.com>
To: Pranith Kumar <bobby.prani@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
From: Michael Ellerman <mpe@ellerman.id.au>
Cc: Andew Morton <akpm@linux-foundation.org>
Subject: Re: powerpc: Fix build failure when MEMORY_HOTPLUG=y
Message-Id: <20140925011409.F1A20140143@ozlabs.org>
Date: Thu, 25 Sep 2014 11:14:09 +1000 (EST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-19-08 at 21:01:05 UTC, Pranith Kumar wrote:
> ARCH_ENABLE_MEMORY_HOTPLUG is enabled by default for powerpc. This causes build
> failures when SPARSEMEM=n as memory hotplug needs definition which are defined
> only when SPARSEMEM=y. The error is as follows:

> arch/powerpc/platforms/pseries/hotplug-memory.c:27:31: error: 'SECTION_SIZE_BITS' undeclared (first use in this function)
> arch/powerpc/platforms/pseries/hotplug-memory.c:27:31: note: each undeclared identifier is reported only once for each function it appears in

I don't see how you can even build pseries without SPARSEMEM=y ?

The three options are:

	default DISCONTIGMEM_MANUAL if ARCH_DISCONTIGMEM_DEFAULT
	default SPARSEMEM_MANUAL if ARCH_SPARSEMEM_DEFAULT
	default FLATMEM_MANUAL

We don't have DISCONTIGMEM.

FLATMEM_MANUAL depends on !ARCH_SPARSEMEM_ENABLE.

We turn on ARCH_SPARSEMEM_ENABLE, and it's not user editable.

cheers
