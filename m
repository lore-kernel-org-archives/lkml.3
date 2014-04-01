Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860AbaDAC6o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 22:58:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60924 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153AbaDAC6m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 22:58:42 -0400
Date: Mon, 31 Mar 2014 22:58:12 -0400
From: Don Zickus <dzickus@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        jmario@redhat.com, fowles@inreach.com, peterz@infradead.org,
        eranian@google.com, andi.kleen@intel.com
Subject: Re: [PATCH 4/6 V2] perf, sort:  Add physid sorting based on mmap2
 data
Message-ID: <20140401025812.GU25953@redhat.com>
References: <1395689676-214799-5-git-send-email-dzickus@redhat.com>
 <1395694638-220799-1-git-send-email-dzickus@redhat.com>
 <20140329171152.GG2022@krava.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140329171152.GG2022@krava.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 29, 2014 at 06:11:52PM +0100, Jiri Olsa wrote:
> On Mon, Mar 24, 2014 at 04:57:18PM -0400, Don Zickus wrote:
> > In order for the c2c tool to work correctly, it needs to properly
> > sort all the records on uniquely identifiable data addresses.  These
> > unique addresses are converted from virtual addresses provided by the
> > hardware into a kernel address using an mmap2 record as the decoder.
> > 
> > Once a unique address is converted, we can sort on them based on
> > various rules.  Then it becomes clear which address are overlapping
> > with each other across mmap regions or pid spaces.
> > 
> > This patch just creates the rules and inserts the records into a
> > sort entry for safe keeping until later patches process them.
> > 
> > The general sorting rule is:
> 
> SNIP
> 
> > +
> > +static int64_t
> > +sort__physid_major_cmp(struct hist_entry *left, struct hist_entry *right)
> > +{
> > +	struct map *l = left->mem_info->daddr.map;
> > +	struct map *r = right->mem_info->daddr.map;
> > +
> > +	return r->maj - l->maj;
> 
> I got segfault here, and consequently in all other sorting
> functions, because it failed to resolve map earlier in
> ip__resolve_data
> 
> we need to check it here, or before adding to the tree

Crap.  I checked it before, when I had one big function.  I forgot to
carry that though.  Honestly I would love to block these before they made
it to the sort routine but don't know a good way without adding checks to
all the builtins.

Cheers,
Don
