Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879AbaIQKBb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 06:01:31 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:46313 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944AbaIQKB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 06:01:29 -0400
MIME-Version: 1.0
In-Reply-To: <54193F4F.9060508@de.ibm.com>
References: <541178D6.6010303@de.ibm.com>
	<CACVXFVO7Oo9GeagPhejngfoeySxOP4EqWz_GN6kYv2956-Wtxg@mail.gmail.com>
	<541352ED.7030800@de.ibm.com>
	<54193F4F.9060508@de.ibm.com>
Date: Wed, 17 Sep 2014 18:01:28 +0800
Message-ID: <CACVXFVOjoAo1d86S=7a3x27aCGVZh03HvVq4dVdRk8VQ+Ou5-w@mail.gmail.com>
Subject: Re: blk-mq crash under KVM in multiqueue block code (with virtio-blk
 and ext4)
From: Ming Lei <tom.leiming@gmail.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        KVM list <kvm@vger.kernel.org>,
        Virtualization List <virtualization@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org >> Linux Kernel Mailing List" 
	<linux-kernel@vger.kernel.org>,
        David Hildenbrand <dahi@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 3:59 PM, Christian Borntraeger
<borntraeger@de.ibm.com> wrote:
> On 09/12/2014 10:09 PM, Christian Borntraeger wrote:
>> On 09/12/2014 01:54 PM, Ming Lei wrote:
>>> On Thu, Sep 11, 2014 at 6:26 PM, Christian Borntraeger
>>> <borntraeger@de.ibm.com> wrote:
>>>> Folks,
>>>>
>>>> we have seen the following bug with 3.16 as a KVM guest. It suspect the blk-mq rework that happened between 3.15 and 3.16, but it can be something completely different.
>>>>
>>>
>>> Care to share how you reproduce the issue?
>>
>> Host with 16GB RAM 32GB swap. 15 guest all with 2 GB RAM (and varying amount of CPUs). All do heavy file I/O.
>> It did not happen with 3.15/3.15 in guest/host and does happen with 3.16/3.16. So our next step is to check
>> 3.15/3.16 and 3.16/3.15 to identify if its host memory mgmt or guest block layer.
>
> The crashed happen pretty randomly, but when they happen it seems that its the same trace as below. This makes memory corruption by host vm less likely and some thing wrong in blk-mq more likely I guess
>

Maybe you can try these patches because atomic op
can be reordered on S390:

http://marc.info/?l=linux-kernel&m=141094730828533&w=2
http://marc.info/?l=linux-kernel&m=141094730828534&w=2

Thanks
-- 
Ming Lei
