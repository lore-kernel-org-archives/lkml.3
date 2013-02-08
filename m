Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947112Ab3BHU6q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 15:58:46 -0500
Received: from fieldses.org ([174.143.236.118]:37815 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947017Ab3BHU6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 15:58:45 -0500
Date: Fri, 8 Feb 2013 15:58:45 -0500
To: Tom Horsley <horsley1953@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: BUG  at net/sunrpc/svc_xprt.c:921
Message-ID: <20130208205844.GD21040@fieldses.org>
References: <20130207075651.3016819a@tomh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130207075651.3016819a@tomh>
User-Agent: Mutt/1.5.21 (2010-09-15)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2013 at 07:56:51AM -0500, Tom Horsley wrote:
> I noticed some previous messages with this subject, but the
> walkback I'm getting doesn't match exactly the ones shown
> in the threads I saw, so I figured I'd send this in.
> 
> This happens on both my Fedora 18 and Fedora 17 partitions
> when mounting filesystems from very old servers that
> need the proto=udp option to talk.
> 
> The redhat bugzilla is here:
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=908451
> 
> There is a photo of the walkback in that bugzilla:
> 
> svc_delete_xprt+0x12a
> svc_recv+0x101
> ? nfs_callback_authenticate+0x50
> nfs4_callback_svc+0x3b
> kthread+0xc0
> ? ftrace_raw_event_xen_mmu_flush_tlb_others+0x50
> ? kthread_create_on_node+0x120
> ret_from_fork+0x7c
> ? kthread_create_on_node+0x120

OK, yes this is the

	if (test_and_set_bit(XPT_DEAD, &xprt->xpt_flags))
	      BUG();

in svc_delete_xprt() and is a known (but unfixed) problem.  Stanislav
has some patches, that should be fixed soon....

--b.
