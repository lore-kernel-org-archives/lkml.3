Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493AbaCXUSr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 16:18:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38358 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754074AbaCXUSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 16:18:45 -0400
Date: Mon, 24 Mar 2014 16:17:57 -0400
From: Don Zickus <dzickus@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@ghostprotocols.net, peterz@infradead.org,
        LKML <linux-kernel@vger.kernel.org>, jolsa@redhat.com,
        jmario@redhat.com, fowles@inreach.com, eranian@google.com,
        andi.kleen@intel.com
Subject: Re: [PATCH 4/6] perf, sort:  Add physid sorting based on mmap2 data
Message-ID: <20140324201757.GC25953@redhat.com>
References: <1395689676-214799-1-git-send-email-dzickus@redhat.com>
 <1395689676-214799-5-git-send-email-dzickus@redhat.com>
 <8761n3pe2w.fsf@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8761n3pe2w.fsf@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 24, 2014 at 12:54:31PM -0700, Andi Kleen wrote:
> Don Zickus <dzickus@redhat.com> writes:
> 
> > In order for the c2c tool to work correctly, it needs to properly
> > sort all the records on uniquely identifiable data addresses.  These
> > unique addresses are converted from virtual addresses provided by the
> > hardware into a kernel address using an mmap2 record as the decoder.
> 
> No documentation for the new option?
> 
> Probably the new mode should be also supported by --sort

I hid the new option further in the changelog, so it isn't obvious.  Sorry
about that.

Sample output: (perf report --stdio --physid-mode)

So the option was '--physid-mode' and if you don't pass in a '--sort' then
it takes the default sort of

'daddr,iaddr,pid,tid,major,minor,inode,inode_gen'

Otherwise you could pass in a combination of the other fields.

The output is not the best way to use the mmap2 data as it just gives you
hottest data addresses.  Our c2c tool really takes the data addresses and
combines them into a cacheline and then processes the cacheline for
interesting bottlenecks (HITMs in our case).

I don't know a good way to present the data and yet still have the sort
useful for our c2c tool.  So I threw this interface together.  I am open
to suggestions.

Cheers,
Don
