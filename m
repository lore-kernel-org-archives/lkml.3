Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760293AbaKATVT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 15:21:19 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:55222 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759209AbaKATVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 15:21:16 -0400
Date: Sat, 01 Nov 2014 15:21:12 -0400 (EDT)
Message-Id: <20141101.152112.741323581543029110.davem@davemloft.net>
To: aneesh.kumar@linux.vnet.ibm.com
Cc: akpm@linux-foundation.org, steve.capper@linaro.org, aarcange@redhat.com,
        benh@kernel.crashing.org, mpe@ellerman.id.au, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH V4 1/2] mm: Update generic gup implementation to handle
 hugepage directory
From: David Miller <davem@davemloft.net>
In-Reply-To: <1414570785-18966-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1414570785-18966-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sat, 01 Nov 2014 12:21:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Date: Wed, 29 Oct 2014 13:49:44 +0530

> Update generic gup implementation with powerpc specific details.
> On powerpc at pmd level we can have hugepte, normal pmd pointer
> or a pointer to the hugepage directory.
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
> Changes from V3:
> * Drop arm and arm64 changes
> * Add hugepte assumption to the function 

Wait, what are you doing here?

You can't assume that a pmd is something you can just go:

	__pte(pmd_val(x))

with.  Not at all.

You have to use the correct pmd_*() accessors at all times on
this object.

Platforms can encode PMDs however they like.  In fact, on sparc64,
we used to have 32-bit PMDs with a special encoding for huge
PMDs that looked nothing at all like a 64-bit PTE.

Please code this in a portable manner to support the powerpc
facilities, don't add assumptions that are not necessarily
universally true.
