Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263Ab3IZBuT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 21:50:19 -0400
Received: from one.firstfloor.org ([193.170.194.197]:48615 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab3IZBuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 21:50:18 -0400
Date: Thu, 26 Sep 2013 03:50:16 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>, Andi Kleen <andi@firstfloor.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, mgorman@suse.de,
        dave@sr71.net, hannes@cmpxchg.org, tony.luck@intel.com,
        matthew.garrett@nebula.com, riel@redhat.com,
        srinivas.pandruvada@linux.intel.com, willy@linux.intel.com,
        kamezawa.hiroyu@jp.fujitsu.com, lenb@kernel.org, rjw@sisk.pl,
        gargankita@gmail.com, paulmck@linux.vnet.ibm.com,
        svaidy@linux.vnet.ibm.com, isimatu.yasuaki@jp.fujitsu.com,
        santosh.shilimkar@ti.com, kosaki.motohiro@gmail.com,
        linux-pm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Results] [RFC PATCH v4 00/40] mm: Memory Power Management
Message-ID: <20130926015016.GM18242@two.firstfloor.org>
References: <20130925231250.26184.31438.stgit@srivatsabhat.in.ibm.com>
 <52437128.7030402@linux.vnet.ibm.com>
 <20130925164057.6bbaf23bdc5057c42b2ab010@linux-foundation.org>
 <20130925234734.GK18242@two.firstfloor.org>
 <52438AA9.3020809@linux.intel.com>
 <20130925182129.a7db6a0fd2c7cc3b43fda92d@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130925182129.a7db6a0fd2c7cc3b43fda92d@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 06:21:29PM -0700, Andrew Morton wrote:
> On Wed, 25 Sep 2013 18:15:21 -0700 Arjan van de Ven <arjan@linux.intel.com> wrote:
> 
> > On 9/25/2013 4:47 PM, Andi Kleen wrote:
> > >> Also, the changelogs don't appear to discuss one obvious downside: the
> > >> latency incurred in bringing a bank out of one of the low-power states
> > >> and back into full operation.  Please do discuss and quantify that to
> > >> the best of your knowledge.
> > >
> > > On Sandy Bridge the memry wakeup overhead is really small. It's on by default
> > > in most setups today.
> > 
> > btw note that those kind of memory power savings are content-preserving,
> > so likely a whole chunk of these patches is not actually needed on SNB
> > (or anything else Intel sells or sold)
> 
> (head spinning a bit).  Could you please expand on this rather a lot?

As far as I understand there is a range of aggressiveness. You could
just group memory a bit better (assuming you can sufficiently predict
the future or have some interface to let someone tell you about it).

Or you can actually move memory around later to get as low footprint
as possible.

This patchkit seems to do both, with the later parts being on the
aggressive side (move things around) 

If you had non content preserving memory saving you would 
need to be aggressive as you couldn't afford any mistakes.

If you had very slow wakeup you also couldn't afford mistakes,
as those could cost a lot of time.

On SandyBridge is not slow and it's preserving, so some mistakes are ok.

But being aggressive (so move things around) may still help you saving
more power -- i guess only benchmarks can tell. It's a trade off between
potential gain and potential worse case performance regression.
It may also depend on the workload.

At least right now the numbers seem to be positive.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
