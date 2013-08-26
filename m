Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451Ab3HZUhQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 16:37:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19048 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570Ab3HZUhO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 16:37:14 -0400
Date: Mon, 26 Aug 2013 16:37:02 -0400
From: Dave Jones <davej@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Hillf Danton <dhillf@gmail.com>, Linux-MM <linux-mm@kvack.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: unused swap offset / bad page map.
Message-ID: <20130826203702.GA15407@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Cyrill Gorcunov <gorcunov@gmail.com>,
	Hillf Danton <dhillf@gmail.com>, Linux-MM <linux-mm@kvack.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <20130819231836.GD14369@redhat.com>
 <CAJd=RBA-UZmSTxNX63Vni+UPZBHwP4tvzE_qp1ZaHBqcNG7Fcw@mail.gmail.com>
 <20130821204901.GA19802@redhat.com>
 <CAJd=RBBNCf5_V-nHjK0gOqS4OLMszgB7Rg_WMf4DvL-De+ZdHA@mail.gmail.com>
 <20130823032127.GA5098@redhat.com>
 <CAJd=RBArkh3sKVoOJUZBLngXtJubjx4-a3G6s7Tn0N=Pr1gU4g@mail.gmail.com>
 <20130823035344.GB5098@redhat.com>
 <CAJd=RBBtY-nJfo9nzG5gtgcvB2bz+sxpK5kX33o1sLeLhvEU1Q@mail.gmail.com>
 <20130826190757.GB27768@redhat.com>
 <20130826201846.GA23724@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130826201846.GA23724@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 12:18:46AM +0400, Cyrill Gorcunov wrote:
 > On Mon, Aug 26, 2013 at 03:08:22PM -0400, Dave Jones wrote:
 > > On Mon, Aug 26, 2013 at 11:45:53AM +0800, Hillf Danton wrote:
 > >  > On Fri, Aug 23, 2013 at 11:53 AM, Dave Jones <davej@redhat.com> wrote:
 > >  > >
 > >  > > It actually seems worse, seems I can trigger it even easier now, as if
 > >  > > there's a leak.
 > >  > >
 > >  > Can you please try the new fix for TLB flush?
 > >  > 
 > >  > commit  2b047252d087be7f2ba
 > >  > Fix TLB gather virtual address range invalidation corner cases
 > > 
 > > No luck.
 > 
 > Hi Dave, could you please put your .config somewhere so i would try
 > to repeat this problem? (i've tried trinity with -C64 but it didn't
 > trigger the issue).

http://paste.fedoraproject.org/34944/77549285
machine I'm using has 8gb ram, 8gb swap, and 4 cores.

Try adding the -C64 to the invocation in scripts/test-multi.sh,
and perhaps up'ing the NR_PROCESSES variable there too.

	Dave

