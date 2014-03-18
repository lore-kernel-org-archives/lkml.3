Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932549AbaCRRiG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 13:38:06 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:41685 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932474AbaCRRiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 13:38:01 -0400
Message-ID: <53288476.10801@converseincode.com>
Date: Tue, 18 Mar 2014 10:37:58 -0700
From: Behan Webster <behanw@converseincode.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: David Laight <David.Laight@ACULAB.COM>,
        "davem@davemloft.net" <davem@davemloft.net>
CC: "pablo@netfilter.org" <pablo@netfilter.org>,
        "kaber@trash.net" <kaber@trash.net>,
        "kadlec@blackhole.kfki.hu" <kadlec@blackhole.kfki.hu>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "netfilter@vger.kernel.org" <netfilter@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "pageexec@freemail.hu" <pageexec@freemail.hu>,
        Mark Charlebois <charlebm@gmail.com>,
        =?UTF-8?B?Vmluw61jaXVzIFRpbnRp?= <viniciustinti@gmail.com>
Subject: Re: [PATCH v2] net: netfilter: LLVMLinux: vlais-netfilter
References: <022D9517-4804-47BB-B789-CCF25F25C1ED@me.com> <1395123121-27053-1-git-send-email-behanw@converseincode.com> <063D6719AE5E284EB5DD2968C1650D6D0F6E0065@AcuExch.aculab.com> <53285C79.2060907@converseincode.com> <063D6719AE5E284EB5DD2968C1650D6D0F6E0286@AcuExch.aculab.com>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D0F6E0286@AcuExch.aculab.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/14 08:24, David Laight wrote:
> From: Behan Webster
>> On 03/18/14 02:41, David Laight wrote:
>>> From:  behanw@converseincode.com
>>>> From: Mark Charlebois <charlebm@gmail.com>
>>>>
>>>> Replaced non-standard C use of Variable Length Arrays In Structs (VLAIS) in
>>>> xt_repldata.h with a C99 compliant flexible array member and then calculated
>>>> offsets to the other struct members. These other members aren't referenced by
>>>> name in this code, however this patch maintains the same memory layout and
>>>> padding as was previously accomplished using VLAIS.
>>>>
>>>> Had the original structure been ordered differently, with the entries VLA at
>>>> the end, then it could have been a flexible member, and this patch would have
>>>> been a lot simpler. However since the data stored in this structure is
>>>> ultimately exported to userspace, the order of this structure can't be changed.
>>> Why not just remove the last element and allocate space for it after the
>>> structure?
>> Because that would still be employing VLAIS to solve the problem. The
>> last element may be a zero-length array (a flexible member), not a VLA.
>> Sadly both the last 2 elements in the struct need to be manually
>> calculated, which is what we've done.
> So make the last element a 'flexible member' and then work out where
> the final field goes.
> Something like:
> 	struct p {
> 		struct a a;
> 		struct b b[];
> 	} p = malloc(sizeof *p + n * sizeof (struct b) + alignof (struct c)
> 		+ sizeof (struct c);
> 	struct c *c = (void *)&p->b[n] + (-offsetof(struct p, b[n]) & (alignof(struct c) - 1);
Oh, I see. Will fix.

Thanks!

Behan

-- 
Behan Webster
behanw@converseincode.com

