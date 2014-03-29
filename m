Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406AbaC2RMV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 13:12:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10595 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752342AbaC2RMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 13:12:18 -0400
Date: Sat, 29 Mar 2014 18:11:52 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Don Zickus <dzickus@redhat.com>
Cc: acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        jmario@redhat.com, fowles@inreach.com, peterz@infradead.org,
        eranian@google.com, andi.kleen@intel.com
Subject: Re: [PATCH 4/6 V2] perf, sort:  Add physid sorting based on mmap2
 data
Message-ID: <20140329171152.GG2022@krava.redhat.com>
References: <1395689676-214799-5-git-send-email-dzickus@redhat.com>
 <1395694638-220799-1-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395694638-220799-1-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 24, 2014 at 04:57:18PM -0400, Don Zickus wrote:
> In order for the c2c tool to work correctly, it needs to properly
> sort all the records on uniquely identifiable data addresses.  These
> unique addresses are converted from virtual addresses provided by the
> hardware into a kernel address using an mmap2 record as the decoder.
> 
> Once a unique address is converted, we can sort on them based on
> various rules.  Then it becomes clear which address are overlapping
> with each other across mmap regions or pid spaces.
> 
> This patch just creates the rules and inserts the records into a
> sort entry for safe keeping until later patches process them.
> 
> The general sorting rule is:

SNIP

> +
> +static int64_t
> +sort__physid_major_cmp(struct hist_entry *left, struct hist_entry *right)
> +{
> +	struct map *l = left->mem_info->daddr.map;
> +	struct map *r = right->mem_info->daddr.map;
> +
> +	return r->maj - l->maj;

I got segfault here, and consequently in all other sorting
functions, because it failed to resolve map earlier in
ip__resolve_data

we need to check it here, or before adding to the tree

thanks,
jirka
