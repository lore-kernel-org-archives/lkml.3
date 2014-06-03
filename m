Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932713AbaFCOUi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 10:20:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64777 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926AbaFCOUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 10:20:36 -0400
Message-ID: <538DD9AC.8050606@redhat.com>
Date: Tue, 03 Jun 2014 16:20:28 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        David Miller <davem@davemloft.net>
Subject: Re: [PULL 2/2] vhost: replace rcu with mutex
References: <1401744482-17764-1-git-send-email-mst@redhat.com>		<1401744482-17764-3-git-send-email-mst@redhat.com>	 <1401746280.3645.187.camel@edumazet-glaptop2.roam.corp.google.com>	 <538DC422.1050303@redhat.com> <1401803863.3645.208.camel@edumazet-glaptop2.roam.corp.google.com>
In-Reply-To: <1401803863.3645.208.camel@edumazet-glaptop2.roam.corp.google.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 03/06/2014 15:57, Eric Dumazet ha scritto:
> On Tue, 2014-06-03 at 14:48 +0200, Paolo Bonzini wrote:
>> Il 02/06/2014 23:58, Eric Dumazet ha scritto:
>>> This looks dubious
>>>
>>> What about using kfree_rcu() instead ?
>>
>> It would lead to unbound allocation from userspace.
>
> Look at how we did this in commit
> c3059477fce2d956a0bb3e04357324780c5d8eeb

That would make VHOST_SET_MEMORY as slow as before (even though once 
every few times).

>>> translate_desc() still uses rcu_read_lock(), its not clear if the mutex
>>> is really held.
>>
>> Yes, vhost_get_vq_desc must be called with the vq mutex held.
>>
>> The rcu_read_lock/unlock in translate_desc is unnecessary.
>
> Yep, this is what I pointed out. This is not only necessary, but
> confusing and might be incorrectly copy/pasted in the future.
>
> This patch is a partial one and leaves confusion.

I agree.

Paolo
