Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634Ab3A0Vz0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 16:55:26 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43658 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756545Ab3A0VzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 16:55:24 -0500
Date: Sun, 27 Jan 2013 13:55:19 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Simon Jeons <simon.jeons@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Petr Holasek <pholasek@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        Rik van Riel <riel@redhat.com>, David Rientjes <rientjes@google.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 1/11] ksm: allow trees per NUMA node
In-Reply-To: <1359256581.4159.16.camel@kernel>
Message-ID: <alpine.LNX.2.00.1301271352520.17144@eggly.anvils>
References: <alpine.LNX.2.00.1301251747590.29196@eggly.anvils> <alpine.LNX.2.00.1301251753380.29196@eggly.anvils> <1359249282.4159.4.camel@kernel> <alpine.LNX.2.00.1301261826000.7411@eggly.anvils> <1359256581.4159.16.camel@kernel>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Jan 2013, Simon Jeons wrote:
> On Sat, 2013-01-26 at 18:54 -0800, Hugh Dickins wrote:
> > 
> > So you'd like us to add code for moving a node from one tree to another
> > in ksm_migrate_page() (and what would it do when it collides with an
> 
> Without numa awareness, I still can't understand your explanation why
> can't insert the node to the tree just after page migration instead of
> inserting it at the next scan.

The node is already there in the right (only) tree in that case.

> 
> > existing node?), code which will then be removed a few patches later
> > when ksm page migration is fully enabled?
