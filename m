Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738Ab3BUG4H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 01:56:07 -0500
Received: from ozlabs.org ([203.10.76.45]:60165 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752211Ab3BUG4D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 01:56:03 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Asias He <asias@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 04/16] virtio-blk: use virtqueue_start_buf on bio path
In-Reply-To: <51249510.4020505@redhat.com>
References: <1361260594-601-1-git-send-email-rusty@rustcorp.com.au> <1361260594-601-5-git-send-email-rusty@rustcorp.com.au> <51249510.4020505@redhat.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 21 Feb 2013 16:53:14 +1030
Message-ID: <87d2vugp7x.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Asias He <asias@redhat.com> writes:

> On 02/19/2013 03:56 PM, Rusty Russell wrote:
>> (This is a respin of Paolo Bonzini's patch, but it calls
>> virtqueue_add_sgs() instead of his multi-part API).
...
> (This subject needs to be changed to reflect using of virtqueue_add_sgs)

Thanks, done.

>> -static inline int __virtblk_add_req(struct virtqueue *vq,
>> -			     struct virtblk_req *vbr,
>> -			     unsigned long out,
>> -			     unsigned long in)
>> +static int __virtblk_add_req(struct virtqueue *vq,
>> +			     struct virtblk_req *vbr)
>>  {
>> -	return virtqueue_add_buf(vq, vbr->sg, out, in, vbr, GFP_ATOMIC);
>> +	struct scatterlist hdr, tailer, *sgs[3];
>
> 'status' might be better than 'tailer'. We are using status in other
> places.

Indeed, done.

> Reviewed-by: Asias He <asias@redhat.com>

Thanks,
Rusty.
