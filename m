Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596AbaFKXEd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 19:04:33 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:35290 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210AbaFKXEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 19:04:32 -0400
Date: Wed, 11 Jun 2014 16:04:29 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mark Salter <msalter@redhat.com>, Michal Nazarewicz <mina86@mina86.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
cc: Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm64: fix MAX_ORDER for 64K pagesize
In-Reply-To: <alpine.DEB.2.02.1406111557030.27885@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.02.1406111604060.27885@chino.kir.corp.google.com>
References: <1402522435-13884-1-git-send-email-msalter@redhat.com> <alpine.DEB.2.02.1406111557030.27885@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jun 2014, David Rientjes wrote:

> Any reason to not switch this to
> 
> 	ARM64_64K_PAGES && TRANSPARENT_HUGEPAGE && CMA
> 

(ARM64_64K_PAGES) && (TRANSPARENT_HUGEPAGE || CMA)

> instead?  If pageblock_order > MAX_ORDER because of 
> HPAGE_SHIFT > PAGE_SHIFT, then cma is always going to be passing a 
> too-large-order to free_pages_prepare() via this path.
> 
> Adding Michal and Marek to the cc.
> 
