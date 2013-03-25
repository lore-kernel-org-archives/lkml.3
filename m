Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758419Ab3CYO1k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 10:27:40 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:60122 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758340Ab3CYO1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 10:27:39 -0400
Message-ID: <51505ED2.70208@redhat.com>
Date: Mon, 25 Mar 2013 15:27:30 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Bart Van Assche <bvanassche@acm.org>
CC: Wanlong Gao <gaowanlong@cn.fujitsu.com>, linux-scsi@vger.kernel.org,
        kvm@vger.kernel.org, mst@redhat.com, linux-kernel@vger.kernel.org,
        JBottomley@parallels.com, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH V7 4/5] virtio-scsi: introduce multiqueue support
References: <1364038124-32479-1-git-send-email-gaowanlong@cn.fujitsu.com> <1364038124-32479-5-git-send-email-gaowanlong@cn.fujitsu.com> <514FFC06.9030703@acm.org>
In-Reply-To: <514FFC06.9030703@acm.org>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 25/03/2013 08:25, Bart Van Assche ha scritto:
>>
>> +        queue_num = smp_processor_id();
>> +        while (unlikely(queue_num >= vscsi->num_queues))
>> +            queue_num -= vscsi->num_queues;
>> +
>> +        tgt->req_vq = vq = &vscsi->req_vqs[queue_num];
>> +    }
>> +
>> +    spin_unlock_irqrestore(&tgt->tgt_lock, flags);
>> +    return vq;
>> +}
> 
> Is there any reason why the smp_processor_id() % vscsi->num_queues
> computation in virtscsi_pick_vq() has been implemented as a loop instead
> of as an arithmetic operation ? If so, I would appreciate it if that
> could be explained in a comment.

The expectation is that vscsi->num_queues is the same as the number of
CPUs in the virtual machine; see patch 5 too.

Paolo
