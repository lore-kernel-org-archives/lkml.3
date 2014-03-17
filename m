Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154AbaCQA5G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 20:57:06 -0400
Received: from ozlabs.org ([203.10.76.45]:55300 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755856AbaCQA5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 20:57:04 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Theodore Ts'o" <tytso@mit.edu>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Venkatesh Srinivas <venkateshs@google.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org,
        Frank Swiderski <fes@google.com>
Subject: Re: [PATCH] virtio-blk: make the queue depth the max supportable by the hypervisor
In-Reply-To: <1394854471-25700-1-git-send-email-tytso@mit.edu>
References: <1394841445-16142-1-git-send-email-venkateshs@google.com> <1394854471-25700-1-git-send-email-tytso@mit.edu>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Mon, 17 Mar 2014 11:12:15 +1030
Message-ID: <87siqhu048.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Ts'o <tytso@mit.edu> writes:
> The current virtio block sets a queue depth of 64, which is
> insufficient for very fast devices.  It has been demonstrated that
> with a high IOPS device, using a queue depth of 256 can double the
> IOPS which can be sustained.
>
> As suggested by Venkatash Srinivas, set the queue depth by default to
> be one half the the device's virtqueue, which is the maximum queue
> depth that can be supported by the channel to the host OS (each I/O
> request requires at least two VQ entries).
>
> Also allow the queue depth to be something which can be set at module
> load time or via a kernel boot-time parameter, for
> testing/benchmarking purposes.

Note that with indirect descriptors (which is supported by Almost
Everyone), we can actually use the full index, so this value is a bit
pessimistic.  But it's OK as a starting point.

Cheers,
Rusty.
