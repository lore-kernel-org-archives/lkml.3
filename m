Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664Ab3A1ETa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 23:19:30 -0500
Received: from mail-da0-f42.google.com ([209.85.210.42]:62113 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029Ab3A1ET1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 23:19:27 -0500
Date: Sun, 27 Jan 2013 20:19:28 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Simon Jeons <simon.jeons@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Petr Holasek <pholasek@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 6/11] ksm: remove old stable nodes more thoroughly
In-Reply-To: <1359339147.6763.25.camel@kernel>
Message-ID: <alpine.LNX.2.00.1301272015450.896@eggly.anvils>
References: <alpine.LNX.2.00.1301251747590.29196@eggly.anvils> <alpine.LNX.2.00.1301251800550.29196@eggly.anvils> <1359339147.6763.25.camel@kernel>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Jan 2013, Simon Jeons wrote:
> On Fri, 2013-01-25 at 18:01 -0800, Hugh Dickins wrote:
> > Switching merge_across_nodes after running KSM is liable to oops on stale
> > nodes still left over from the previous stable tree.  It's not something
> 
> Since this patch solve the problem, so the description of
> merge_across_nodes(Value can be changed only when there is no ksm shared
> pages in system) should be changed in this patch.

No.

The code could be changed to unmerge_and_remove_all_rmap_items()
automatically whenever merge_across_nodes is changed; but that's
not what Petr chose to do, and I didn't feel strongly to change it.
