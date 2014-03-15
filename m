Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727AbaCOPNi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 11:13:38 -0400
Received: from imap.thunk.org ([74.207.234.97]:41785 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754648AbaCOPNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 11:13:37 -0400
Date: Sat, 15 Mar 2014 11:13:22 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        Venkatesh Srinivas <venkateshs@google.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org,
        Frank Swiderski <fes@google.com>
Subject: Re: [PATCH] virtio-blk: make the queue depth the max supportable by
 the hypervisor
Message-ID: <20140315151322.GA17270@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Christoph Hellwig <hch@infradead.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Venkatesh Srinivas <venkateshs@google.com>,
	Rusty Russell <rusty@rustcorp.com.au>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	virtio-dev@lists.oasis-open.org,
	virtualization@lists.linux-foundation.org,
	Frank Swiderski <fes@google.com>
References: <1394841445-16142-1-git-send-email-venkateshs@google.com>
 <1394854471-25700-1-git-send-email-tytso@mit.edu>
 <20140315135723.GA10475@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140315135723.GA10475@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 15, 2014 at 06:57:23AM -0700, Christoph Hellwig wrote:
> I don't think this should be a module parameter.  The default sizing
> should be based of the parameters of the actual virtqueue, and if we
> want to allow tuning it it should be by a sysfs attribute, preferable
> using the same semantics as SCSI.

I wanted that too, but looking at the multiqueue code, it wasn't all
obvious how to safely adjust the queue depth once the virtio-blk
device driver is initialized and becomes active.  There are all sorts
data structures including bitmaps, etc. that would have to be resized,
and I decided it would be too difficult / risky for me to make it be
dynamically resizeable.

So I settled on a module parameter thinking it would mostly only used
by testers / benchmarkers.

Can someone suggest a way to do a dynamic resizing of the virtio-blk
queue depth easily / safely?

    	    	      	     	- Ted
