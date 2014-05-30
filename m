Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792AbaE3Iil (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 04:38:41 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:48232 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbaE3Iii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 04:38:38 -0400
Date: Fri, 30 May 2014 10:38:30 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Righi <andrea@betterlinux.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
        Thorsten Diehl <thorsten.diehl@de.ibm.com>,
        Ian Kent <raven@themaw.net>,
        "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: Re: [PATCH 2/2] fs: proc/stat: use usual seq_file ops rather than
 single_open
Message-ID: <20140530083830.GA4732@osiris>
References: <20140521122521.GB7471@osiris>
 <20140521143229.GA32011@infradead.org>
 <20140528085841.GA4219@osiris>
 <20140528090153.GC4219@osiris>
 <20140528153704.b2a3f46dc39ebf8f681d528a@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140528153704.b2a3f46dc39ebf8f681d528a@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14053008-5024-0000-0000-0000002D4A0F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 03:37:04PM -0700, Andrew Morton wrote:
> On Wed, 28 May 2014 11:01:53 +0200 Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> > With this patch it should not happen anymore that reading /proc/stat
> > fails because of a failing high order memory allocation.
> 
> So this deletes the problematic allocation which [1/2] kind-of fixed,
> yes?

Yes.

> I agree with Ian - there's a hotplugging race.  And [1/2] doesn't do
> anything to address the worst-case allocation size.  So I think we may
> as well do this all in a single patch.

Fine with me. However the hotplugging race in 1/2 doesn't matter: if the
result doesn't fit into the preallocated buffer the seq_file infrastructure
would simply allocate a buffer twice as large as before and retry.

The point of patch 1/2 was to have a patch that probably solves the problem
almost always ;) , without having the problems you describe below.

> Without having looked closely at the code I worry a bit about the
> effects.  /proc/pid/stat is a complex thing and its contents will vary

It's /proc/stat not /proc/pid/stat.

> So..  can we take this up for 3.16-rc1?  See if we can get some careful
> review done then and test it for a couple of months?

Sure.

> Meanwhile, the changelog looks a bit hastily thrown together - some
> smoothing would be nice, and perhaps some work spent identifying
> possible behavioural changes.  Timing changes, locking canges, effects
> of concurrent fork/exit activity etc?

Well... I'll try to come up with something better. Even though I only
forward ported an existing patch to address a memory allocation failure.
Oh oh...

