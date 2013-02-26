Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724Ab3BZFln (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 00:41:43 -0500
Received: from ozlabs.org ([203.10.76.45]:36206 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134Ab3BZFlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 00:41:42 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Asias He <asias@redhat.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 02/16] virtio_ring: virtqueue_add_sgs, to add multiple sgs.
In-Reply-To: <20130224221255.GA5300@redhat.com>
References: <1361260594-601-1-git-send-email-rusty@rustcorp.com.au> <1361260594-601-3-git-send-email-rusty@rustcorp.com.au> <20130224221255.GA5300@redhat.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Tue, 26 Feb 2013 15:44:26 +1030
Message-ID: <87bob7fyh9.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> writes:
> On Tue, Feb 19, 2013 at 06:26:20PM +1030, Rusty Russell wrote:
>> virtio_scsi can really use this, to avoid the current hack of copying
>> the whole sg array.  Some other things get slightly neater, too.
>> 
>> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
>
> Hmm, this makes add_buf a bit slower. virtio_test results
> (I'll send a patch to update the test shortly):
>
> Before:
> 0.09user 0.01system 0:00.12elapsed 91%CPU (0avgtext+0avgdata 480maxresident)k
> 0inputs+0outputs (0major+145minor)pagefaults 0swaps
>
> After:
> 0.11user 0.01system 0:00.13elapsed 90%CPU (0avgtext+0avgdata 480maxresident)k
> 0inputs+0outputs (0major+145minor)pagefaults 0swaps

Interesting: how much of this is due to the shim in virtqueue_add_buf()
to clean up the sg arrays?

(Perhaps we should make virtio_test run for longer, too).

BTW, you might be interested in:
        https://github.com/rustyrussell/stats.git

Which provides a useful filter for multiple results.

Cheers,
Rusty.
