Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866AbaIQUQP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 16:16:15 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:60170 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756391AbaIQUQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 16:16:13 -0400
Message-ID: <5419EC19.9050100@kernel.dk>
Date: Wed, 17 Sep 2014 14:16:25 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: David Hildenbrand <dahi@linux.vnet.ibm.com>,
        Ming Lei <tom.leiming@gmail.com>
CC: Christian Borntraeger <borntraeger@de.ibm.com>,
        rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, KVM list <kvm@vger.kernel.org>,
        Virtualization List <virtualization@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org >> Linux Kernel Mailing List" 
	<linux-kernel@vger.kernel.org>
Subject: Re: blk-mq crash under KVM in multiqueue block code (with virtio-blk
 and ext4)
References: <541178D6.6010303@de.ibm.com>	<CACVXFVO7Oo9GeagPhejngfoeySxOP4EqWz_GN6kYv2956-Wtxg@mail.gmail.com>	<541352ED.7030800@de.ibm.com>	<54193F4F.9060508@de.ibm.com>	<20140917140034.10125d00@thinkpad-w530>	<20140917215226.426f6ce7@tom-ThinkPad-T410>	<54199923.9010201@kernel.dk>	<CACVXFVPh3SSp3V7hHJaPnp-koyh7n7hqf+Ugv9CMg2gO_8MwXg@mail.gmail.com> <20140917210954.6e622fb5@thinkpad-w530>
In-Reply-To: <20140917210954.6e622fb5@thinkpad-w530>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2014 01:09 PM, David Hildenbrand wrote:
>>> 0. That should already be sufficient to hinder blk_mq_tag_to_rq and the calling
>>> method to do the wrong thing.
>>
>> Yes, clearing rq->cmd_flags should be enough.
>>
>> And looks better to move rq initialization to __blk_mq_free_request()
>> too, otherwise timeout still may see old cmd_flags and rq->q before
>> rq's new initialization.
> 
> Yes, __blk_mq_free_request() should also reset at least rq->cmd_flags, and I
> think we can remove the initialization from  __blk_mq_alloc_request().

And then we come full circle, that's how the code originally started out
(and it is the saner way to do things). So yes, I'd greatly applaud that.


-- 
Jens Axboe

