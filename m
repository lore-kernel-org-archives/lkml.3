Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197AbaGIF7o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 01:59:44 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:38741 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368AbaGIF7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 01:59:42 -0400
Date: Tue, 8 Jul 2014 22:58:04 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Ben Hutchings <ben@decadent.org.uk>
cc: Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, akpm@linux-foundation.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Christoph Lameter <cl@linux.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3.2 099/125] mm: fix crashes from mbind() merging vmas
In-Reply-To: <1404870838.26540.30.camel@deadeye.wl.decadent.org.uk>
Message-ID: <alpine.LSU.2.11.1407082242540.7275@eggly.anvils>
References: <lsq.1404846110.431506873@decadent.org.uk> <alpine.LSU.2.11.1407081336180.31914@eggly.anvils> <alpine.LSU.2.11.1407081420220.31914@eggly.anvils> <1404870838.26540.30.camel@deadeye.wl.decadent.org.uk>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jul 2014, Ben Hutchings wrote:
> On Tue, 2014-07-08 at 14:26 -0700, Hugh Dickins wrote:
> > On Tue, 8 Jul 2014, Hugh Dickins wrote:
> > > On Tue, 8 Jul 2014, Ben Hutchings wrote:
> > > 
> > > > 3.2.61-rc1 review patch.  If anyone has any objections, please let me know.
> > > > 
> > > > ------------------
> > > > 
> > > > From: Hugh Dickins <hughd@google.com>
> > > > 
> > > > commit d05f0cdcbe6388723f1900c549b4850360545201 upstream.
> > > 
> > > I don't think that's correct, I can't see a change to the
> > > "vma = check_range(" in migrate_to_node() which 3.2 and 3.4 trees have.
> > > Does it build (without warning) with CONFIG_NUMA and CONFIG_MIGRATION?
> > > I expect this version I sent yesterday for 3.4.98 will be good for 3.2:
> > 
> > Hah, I now see that 098/125 in your series
> 
> Which, for anyone who missed it, was commit 082708072a42, 'mm: revert
> 0def08e3 ("mm/mempolicy.c: check return code of  check_range")'.
> 
> > removes precisely the "vma = "
> > I was calling attention to.  So all should be okay and you can ignore me.
> 
> Right - of course I'm assuming that the reasoning given for that revert
> is valid for 3.2.

It should be fine: both reverter 082708072a42 and revertee 0def08e3
were cleanups of little importance, it just happens that the revert
made your backport of mine slightly easier, hence you included it.

The revert does add a VM_BUG_ON, at first a worry for -stable,
but in fact it looks safe to me.

(I wish I had done a much simpler patch for mine, but too late for that!)

Hugh
