Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942Ab3A2Bin (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 20:38:43 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:49229 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513Ab3A2Bik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 20:38:40 -0500
Date: Mon, 28 Jan 2013 17:38:43 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Petr Holasek <pholasek@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        Rik van Riel <riel@redhat.com>, David Rientjes <rientjes@google.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 1/11] ksm: allow trees per NUMA node
In-Reply-To: <20130128150854.6813b1ca.akpm@linux-foundation.org>
Message-ID: <alpine.LNX.2.00.1301281717320.4947@eggly.anvils>
References: <alpine.LNX.2.00.1301251747590.29196@eggly.anvils> <alpine.LNX.2.00.1301251753380.29196@eggly.anvils> <20130128150854.6813b1ca.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jan 2013, Andrew Morton wrote:
> On Fri, 25 Jan 2013 17:54:53 -0800 (PST)
> Hugh Dickins <hughd@google.com> wrote:
> 
> > +/* Zeroed when merging across nodes is not allowed */
> > +static unsigned int ksm_merge_across_nodes = 1;
> 
> I spose this should be __read_mostly.  If __read_mostly is not really a
> synonym for __make_write_often_storage_slower.  I continue to harbor
> fear, uncertainty and doubt about this...

Could do.  No strong feeling, but I think I'd rather it share its
cacheline with other KSM-related stuff, than be off mixed up with
unrelateds.  I think there's a much stronger case for __read_mostly
when it's a library thing accessed by different subsystems.

You're right that this variable is accessed significantly more often
that the other KSM tunables, so deserves a __read_mostly more than
they do.  But where to stop?  Similar reluctance led me to avoid
using "unlikely" throughout ksm.c, unlikely as some conditions are
(I'm aghast to see that Andrea sneaked in a "likely" :).

Hugh
