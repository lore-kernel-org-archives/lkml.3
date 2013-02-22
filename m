Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757534Ab3BVUjO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 15:39:14 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:46040 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757435Ab3BVUjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 15:39:12 -0500
Date: Fri, 22 Feb 2013 12:38:26 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Ric Mason <ric.masonn@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Petr Holasek <pholasek@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/7] ksm: responses to NUMA review
In-Reply-To: <5126E987.7020809@gmail.com>
Message-ID: <alpine.LNX.2.00.1302221227530.6100@eggly.anvils>
References: <alpine.LNX.2.00.1302210013120.17843@eggly.anvils> <5126E987.7020809@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Feb 2013, Ric Mason wrote:
> On 02/21/2013 04:17 PM, Hugh Dickins wrote:
> > Here's a second KSM series, based on mmotm 2013-02-19-17-20: partly in
> > response to Mel's review feedback, partly fixes to issues that I found
> > myself in doing more review and testing.  None of the issues fixed are
> > truly show-stoppers, though I would prefer them fixed sooner than later.
> 
> Do you have any ideas ksm support page cache and tmpfs?

No.  It's only been asked as a hypothetical question: I don't know of
anyone actually needing it, and I wouldn't have time to do it myself.

It would be significantly more invasive than just dealing with anonymous
memory: with anon, we already have the infrastructure for read-only pages,
but we don't at present have any notion of read-only pagecache.

Just doing it in tmpfs?  Well, yes, that might be easier: since v3.1's
radix_tree rework, shmem/tmpfs mostly goes through its own interfaces
to pagecache, so read-only pagecache, and hence KSM, might be easier
to implement there than more generally.

Hugh
