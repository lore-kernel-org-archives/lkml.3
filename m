Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646Ab3KYKZY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 05:25:24 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:39064 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867Ab3KYKZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 05:25:22 -0500
Message-ID: <52932586.2010301@linux.vnet.ibm.com>
Date: Mon, 25 Nov 2013 18:25:10 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, avi.kivity@gmail.com,
        "pbonzini@redhat.com Bonzini" <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Eric Dumazet <dada1@cosmosbay.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v3 07/15] KVM: MMU: introduce nulls desc
References: <1382534973-13197-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1382534973-13197-8-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20131122191429.GA13308@amt.cnet> <65EE805B-B5DB-4BD0-A057-E5FF78D96D67@linux.vnet.ibm.com> <20131125101943.GS2108@redhat.com>
In-Reply-To: <20131125101943.GS2108@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13112510-9574-0000-0000-00000ABE1D4C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2013 06:19 PM, Gleb Natapov wrote:
> On Mon, Nov 25, 2013 at 02:11:31PM +0800, Xiao Guangrong wrote:
>>>
>>> For example, nothing prevents lockless walker to move into some
>>> parent_ptes chain, right?
>>
>> No.
>>
>> The nulls can help us to detect this case, for parent_ptes, the nulls points
>> to "shadow page" but for rmaps, the nulls points to slot.arch.rmap. There
>> is no chance that the �rmap" is used as shadow page when slot-lock is held.
>>
> But meanwhile we will write protect non-last level sptes, no? Better to

It will meet the non-last sptes but does not write-protect them since
we have do is_last_spte() check before cmpxchg.

> create separate slab caches for rmap and parent_ptes lists.

Yes, this is a good idea. Thanks you, Gleb!

