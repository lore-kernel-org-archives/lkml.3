Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565AbaCON5Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 09:57:25 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:46006 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755691AbaCON5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 09:57:24 -0400
Date: Sat, 15 Mar 2014 06:57:23 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        Venkatesh Srinivas <venkateshs@google.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org,
        Frank Swiderski <fes@google.com>
Subject: Re: [PATCH] virtio-blk: make the queue depth the max supportable by
 the hypervisor
Message-ID: <20140315135723.GA10475@infradead.org>
References: <1394841445-16142-1-git-send-email-venkateshs@google.com>
 <1394854471-25700-1-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394854471-25700-1-git-send-email-tytso@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 11:34:31PM -0400, Theodore Ts'o wrote:
> The current virtio block sets a queue depth of 64, which is
> insufficient for very fast devices.  It has been demonstrated that
> with a high IOPS device, using a queue depth of 256 can double the
> IOPS which can be sustained.
> 
> As suggested by Venkatash Srinivas, set the queue depth by default to
> be one half the the device's virtqueue, which is the maximum queue
> depth that can be supported by the channel to the host OS (each I/O
> request requires at least two VQ entries).

I don't think this should be a module parameter.  The default sizing
should be based of the parameters of the actual virtqueue, and if we
want to allow tuning it it should be by a sysfs attribute, preferable
using the same semantics as SCSI.

