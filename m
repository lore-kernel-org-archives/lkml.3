Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751281AbaLROwn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 09:52:43 -0500
Received: from resqmta-po-08v.sys.comcast.net ([96.114.154.167]:37939 "EHLO
	resqmta-po-08v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751108AbaLROwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 09:52:42 -0500
Date: Thu, 18 Dec 2014 08:52:40 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Dave Hansen <dave.hansen@intel.com>
cc: Fenghua Yu <fenghua.yu@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Glenn Williamson <glenn.p.williamson@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH v2] X86-32: Allocate 256 bytes for pgd in PAE paging
In-Reply-To: <54921EF2.9070004@intel.com>
Message-ID: <alpine.DEB.2.11.1412180850290.2593@gentwo.org>
References: <1418852859-18852-1-git-send-email-fenghua.yu@intel.com> <54921EF2.9070004@intel.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Dec 2014, Dave Hansen wrote:

> IOW, do *ALL* of the sl*b allocators in all of their forms with all of
> their debugging options guarantee 32-byte alignment when allocating
> 256-byte objects?

No. For that the arch has to set a macro call ARCH_KMALLOC_MINALIGN or
ARCH_DMA_MINALIGN. Default alignment is to a word boundary.

> I know we at least try to align to a cacheline, which would be good
> enough, but I'm fuzzy on what we *guarantee*.

Sorry we only do this if requested for a slab cache.

