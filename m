Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245Ab3BOSE2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 13:04:28 -0500
Received: from mail-ve0-f174.google.com ([209.85.128.174]:49679 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755896Ab3BOSE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 13:04:26 -0500
Message-ID: <511E78A3.9070607@redhat.com>
Date: Fri, 15 Feb 2013 19:04:19 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
CC: Rusty Russell <rusty@rustcorp.com.au>, kvm@vger.kernel.org, mst@redhat.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 0/9] virtio: new API for addition of buffers, scatterlist
 changes
References: <1360671815-2135-1-git-send-email-pbonzini@redhat.com> <87r4kjjuyn.fsf@rustcorp.com.au> <511CAD19.2010902@redhat.com>
In-Reply-To: <511CAD19.2010902@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 14/02/2013 10:23, Paolo Bonzini ha scritto:
>> > How about this as a first step?
>> > 
>> > virtio_ring: virtqueue_add_sgs, to add multiple sgs.
>> > 
>> > virtio_scsi and virtio_blk can really use these, to avoid their current
>> > hack of copying the whole sg array.
>> > 
>> > Signed-off-by: Ruty Russell <rusty@rustcorp.com.au> 
> It's much better than the other prototype you had posted, but I still
> dislike this...  You pay for additional counting of scatterlists when
> the caller knows the number of buffers; and the nested loops aren't
> free, either.

Another problem is that you cannot pass "truncated" scatterlists.  You
must ensure there is an end marker on the last item.  I'm not sure if
the kernel ensures that, given that for_each_sg takes explicitly the
number of scatterlist elements; and it is not as trivial as
"sg_mark_end(foo + nsg - 1);" if the upper layers hand you a chained
scatterlist.

Paolo
