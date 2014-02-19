Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768AbaBSXIW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 18:08:22 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:34290 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbaBSXIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 18:08:21 -0500
X-Originating-IP: 173.246.103.110
Date: Wed, 19 Feb 2014 15:08:09 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Rik van Riel <riel@surriel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Kelley Nielsen <kelleynnn@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, opw-kernel@googlegroups.com, jamieliu@google.com,
        sjenning@linux.vnet.ibm.com, Hugh Dickins <hughd@google.com>
Subject: Re: [OPW kernel] Re: [RFC] mm:prototype for the updated swapoff
 implementation
Message-ID: <20140219230809.GA8221@jtriplet-mobl1>
References: <20140219003522.GA8887@kelleynnn-virtual-machine>
 <20140219132757.58b61f07bad914b3848275e9@linux-foundation.org>
 <530524A3.6090700@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530524A3.6090700@surriel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 04:39:47PM -0500, Rik van Riel wrote:
> On 02/19/2014 04:27 PM, Andrew Morton wrote:
> > On Tue, 18 Feb 2014 16:35:22 -0800 Kelley Nielsen <kelleynnn@gmail.com> wrote:
> > 
> >> The function try_to_unuse() is of quadratic complexity, with a lot of
> >> wasted effort. It unuses swap entries one by one, potentially iterating
> >> over all the page tables for all the processes in the system for each
> >> one.
> >>
> >> This new proposed implementation of try_to_unuse simplifies its
> >> complexity to linear. It iterates over the system's mms once, unusing
> >> all the affected entries as it walks each set of page tables. It also
> >> makes similar changes to shmem_unuse.
> >>
> >> Improvement
> >>
> >> swapoff was called on a swap partition containing about 50M of data,
> >> and calls to the function unuse_pte_range were counted.
> >>
> >> Present implementation....about 22.5M calls.
> >> Prototype.................about  7.0K   calls.
> > 
> > Do you have situations in which swapoff is taking an unacceptable
> > amount of time?  If so, please update the changelog to provide full
> > details on this, with before-and-after timing measurements.
> 
> I have seen plenty of that.  With just a few GB in swap space in
> use, on a system with 24GB of RAM, and about a dozen GB in use
> by various processes, I have seen swapoff take several hours of
> CPU time.

And it's clear what the lower bound on swapoff should be: current amount
of swap in use, divided by maximum disk write speed.  We're definitely
not to *that* point yet; this ought to get us a lot closer.

- Josh Triplett
