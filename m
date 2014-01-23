Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064AbaAWBxE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 20:53:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44124 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752950AbaAWBxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 20:53:01 -0500
Date: Wed, 22 Jan 2014 20:52:41 -0500
From: Dave Jones <davej@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: Sasha Levin <sasha.levin@oracle.com>, khlebnikov@openvz.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: mm: BUG: Bad rss-counter state
Message-ID: <20140123015241.GA947@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	David Rientjes <rientjes@google.com>,
	Sasha Levin <sasha.levin@oracle.com>, khlebnikov@openvz.org,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <52E06B6F.90808@oracle.com>
 <alpine.DEB.2.02.1401221735450.26172@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1401221735450.26172@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 05:39:25PM -0800, David Rientjes wrote:
 
 > > While fuzzing with trinity running inside a KVM tools guest using latest -next
 > > kernel,
 > > I've stumbled on a "mm: BUG: Bad rss-counter state" error which was pretty
 > > non-obvious
 > > in the mix of the kernel spew (why?).
 > > 
 > 
 > It's not a fatal condition and there's only a few possible stack traces 
 > that could be emitted during the exit() path.  I don't see how we could 
 > make it more visible other than its log-level which is already KERN_ALERT.
 > 
 > > I've added a small BUG() after the printk() in check_mm(), and here's the full
 > > output:
 > > 
 > 
 > Worst place to add it :)  At line 562 of kernel/fork.c in linux-next 
 > you're going to hit BUG() when there may be other counters that are also 
 > bad and they don't get printed.  
 > 
 > > [  318.334905] BUG: Bad rss-counter state mm:ffff8801e6dec000 idx:0 val:1
 > 
 > So our mm has a non-zero MM_FILEPAGES count, but there's nothing that was 
 > cited that would tell us what that is so there's not much to go on, unless 
 > someone already recognizes this as another issue.  Is this reproducible on 
 > 3.13 or only on linux-next?

Sasha, is this the current git tree version of Trinity ?
(I'm wondering if yesterdays munmap changes might be tickling this bug).

	Dave

