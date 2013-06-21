Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423359Ab3FUQdx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 12:33:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60024 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423252Ab3FUQdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 12:33:52 -0400
Date: Fri, 21 Jun 2013 12:33:30 -0400
From: David Teigland <teigland@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>, akpm@linux-foundation.org,
        tj@kernel.org, axboe@kernel.dk, nab@linux-iscsi.org, bcrl@kvack.org,
        linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH 03/10] idr: Rewrite ida
Message-ID: <20130621163330.GA6503@redhat.com>
References: <1371600150-23557-1-git-send-email-koverstreet@google.com>
 <1371600150-23557-4-git-send-email-koverstreet@google.com>
 <1371634822.2735.9.camel@menhir>
 <20130619233836.GA6986@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130619233836.GA6986@localhost>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 04:38:36PM -0700, Kent Overstreet wrote:
> On Wed, Jun 19, 2013 at 10:40:22AM +0100, Steven Whitehouse wrote:
> > Millions of IDs is something that is fairly normal for DLM, since there
> > will be two DLM locks per cached inode with GFS2 and people tend to use
> > it on pretty large servers with lots of memory,
> 
> Thanks, I wasn't aware of that. Is the 31 bits for the id limitation an
> issue for you? While I'm at changing ids to longs should be fairly
> trivial.

There is a dlm_lkb struct in memory for each id, so 31 bits will not
be a problem.
Dave

