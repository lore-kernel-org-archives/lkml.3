Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934131Ab3FSJnF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 05:43:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35862 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933755Ab3FSJnC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 05:43:02 -0400
Subject: Re: [PATCH 03/10] idr: Rewrite ida
From: Steven Whitehouse <swhiteho@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: akpm@linux-foundation.org, tj@kernel.org, axboe@kernel.dk,
        nab@linux-iscsi.org, bcrl@kvack.org, linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Fengguang Wu <fengguang.wu@intel.com>
In-Reply-To: <1371600150-23557-4-git-send-email-koverstreet@google.com>
References: <1371600150-23557-1-git-send-email-koverstreet@google.com>
	 <1371600150-23557-4-git-send-email-koverstreet@google.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Wed, 19 Jun 2013 10:40:22 +0100
Message-ID: <1371634822.2735.9.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 2013-06-18 at 17:02 -0700, Kent Overstreet wrote:
> This is a new, from scratch implementation of ida that should be
> simpler, faster and more space efficient.
> 
[...]

> 
> This does mean that the entire bitmap is stored in one contiguous memory
> allocation - and as currently implemented we won't be able to allocate
> _quite_ as many ids as with the previous implementation.
> 
> I don't expect this to be an issue in practice since anywhere this is
> used, an id corresponds to a struct allocation somewher else - we can't
> allocate an unbounded number of ids, we'll run out of memory somewhere
> else eventually, and I expect that to be the limiting factor in
> practice.
> 
> If a user/use case does come up where this matters I can add some
> sharding (or perhaps add a separate big_ida implementation) - but the
> extra complexity would adversely affect performance for the users that
> don't need > millions of ids, so I intend to leave the implementation as
> is until if and when this becomes an issue.
> 

Millions of IDs is something that is fairly normal for DLM, since there
will be two DLM locks per cached inode with GFS2 and people tend to use
it on pretty large servers with lots of memory,

Steve.


