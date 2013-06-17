Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932838Ab3FQL7i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 07:59:38 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:54761 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932700Ab3FQL7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 07:59:35 -0400
X-Nat-Received: from [202.181.97.72]:60050 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1371470364.18701
To: cl@linux.com
Cc: glommer@parallels.com, penberg@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-next-20130422] Bug in SLAB?
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <0000013e89a4ae3c-f2abd075-e096-42b5-891d-e2e5e2af9ecb-000000@email.amazonses.com>
	<201305100654.FCI28926.HOtMVOJLFFFSQO@I-love.SAKURA.ne.jp>
	<201305102138.BDF90621.LFFOFtHSQOMVOJ@I-love.SAKURA.ne.jp>
	<0000013e8f295277-653bcbfa-e1cc-4c05-8e6d-eb6a5a661f6f-000000@email.amazonses.com>
	<201305272153.HEH51089.OHFQMOOtFLSFVJ@I-love.SAKURA.ne.jp>
In-Reply-To: <201305272153.HEH51089.OHFQMOOtFLSFVJ@I-love.SAKURA.ne.jp>
Message-Id: <201306172059.GJB64038.LHJOVOFMtFOFSQ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Mon, 17 Jun 2013 20:59:14 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 17062013 #10352088, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa wrote:
> Christoph Lameter wrote:
> > Subject: SLAB: Fix init_lock_keys
> > 
> > init_lock_keys goes too far in initializing values in kmalloc_caches because
> > it assumed that the size of the kmalloc array goes up to MAX_ORDER. However, the size
> > of the kmalloc array for SLAB may be restricted due to increased page sizes or CONFIG_FORCE_MAX_ZONEORDER.
> > 
> > Reported-by: Tetsuo Handa <penguin-kernel@I-Love.SAKURA.ne.jp>
> > Signed-off-by: Christoph Lameter <cl@linux.com>
> > 
> > Index: linux/mm/slab.c
> > ===================================================================
> > --- linux.orig/mm/slab.c	2013-05-09 09:06:20.000000000 -0500
> > +++ linux/mm/slab.c	2013-05-09 09:08:08.338606055 -0500
> > @@ -565,7 +565,7 @@ static void init_node_lock_keys(int q)
> >  	if (slab_state < UP)
> >  		return;
> > 
> > -	for (i = 1; i < PAGE_SHIFT + MAX_ORDER; i++) {
> > +	for (i = 1; i <= KMALLOC_SHIFT_HIGH; i++) {
> >  		struct kmem_cache_node *n;
> >  		struct kmem_cache *cache = kmalloc_caches[i];
> > 
> > 
> Looks OK to me. Please send this one to 3.10-rcX.
> 
It's already 3.10-rc6. Please be sure to send.
