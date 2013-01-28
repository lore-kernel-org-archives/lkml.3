Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854Ab3A1Dfl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 22:35:41 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:57206 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431Ab3A1Dff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 22:35:35 -0500
Date: Sun, 27 Jan 2013 19:35:31 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Simon Jeons <simon.jeons@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Petr Holasek <pholasek@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 5/11] ksm: get_ksm_page locked
In-Reply-To: <1359333371.6763.12.camel@kernel>
Message-ID: <alpine.LNX.2.00.1301271932070.896@eggly.anvils>
References: <alpine.LNX.2.00.1301251747590.29196@eggly.anvils> <alpine.LNX.2.00.1301251759470.29196@eggly.anvils> <1359254187.4159.10.camel@kernel> <alpine.LNX.2.00.1301271355430.17144@eggly.anvils> <1359333371.6763.12.camel@kernel>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Jan 2013, Simon Jeons wrote:
> On Sun, 2013-01-27 at 14:08 -0800, Hugh Dickins wrote:
> > On Sat, 26 Jan 2013, Simon Jeons wrote:
> > > 
> > > Why the parameter lock passed from stable_tree_search/insert is true,
> > > but remove_rmap_item_from_tree is false?
> > 
> > The other way round?  remove_rmap_item_from_tree needs the page locked,
> > because it's about to modify the list: that's secured (e.g. against
> > concurrent KSM page reclaim) by the page lock.
> 
> How can KSM page reclaim path call remove_rmap_item_from_tree? I have
> already track every callsites but can't find it.

It doesn't.  Please read what I said above again.

> BTW, I'm curious about
> KSM page reclaim, it seems that there're no special handle in vmscan.c
> for KSM page reclaim, is it will be reclaimed similiar with normal
> page? 

Look for PageKsm in mm/rmap.c.
