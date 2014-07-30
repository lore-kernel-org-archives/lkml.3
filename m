Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200AbaG3KhY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 06:37:24 -0400
Received: from g2t2353.austin.hp.com ([15.217.128.52]:19195 "EHLO
	g2t2353.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbaG3KhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 06:37:23 -0400
Message-ID: <1406716641.9336.17.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH] mm: BUG when __kmap_atomic_idx crosses boundary
From: Davidlohr Bueso <davidlohr@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chintan Pandya <cpandya@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Date: Wed, 30 Jul 2014 03:37:21 -0700
In-Reply-To: <20140730020615.2f943cf7.akpm@linux-foundation.org>
References: <1406710355-4360-1-git-send-email-cpandya@codeaurora.org>
	 <20140730020615.2f943cf7.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2014-07-30 at 02:06 -0700, Andrew Morton wrote:
> On Wed, 30 Jul 2014 14:22:35 +0530 Chintan Pandya <cpandya@codeaurora.org> wrote:
> 
> > __kmap_atomic_idx >= KM_TYPE_NR or < ZERO is a bug.
> > Report it even if CONFIG_DEBUG_HIGHMEM is not enabled.
> > That saves much debugging efforts.
> 
> Please take considerably more care when preparing patch changelogs.
> 
> kmap_atomic() is a very commonly called function so we'll need much
> more detail than this to justify adding overhead to it.
> 
> I don't think CONFIG_DEBUG_HIGHMEM really needs to exist.  We could do
> s/CONFIG_DEBUG_HIGHMEM/CONFIG_DEBUG_VM/g and perhaps your secret bug
> whatever it was would have been found more easily.

Agreed, it would be nice to fold DEBUG_HIGHMEM into DEBUG_VM. However
you'd still need some kind of intermediate option as DEBUG_VM must still
exist if !HIGHMEM.

Thanks,
Davidlohr


