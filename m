Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932390AbaLDPoJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 10:44:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57447 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753442AbaLDPoG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 10:44:06 -0500
Message-ID: <54808123.8000704@redhat.com>
Date: Thu, 04 Dec 2014 16:43:31 +0100
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Thomas Graf <tgraf@suug.ch>
CC: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "Theodore Ts'o" <tytso@mit.edu>, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Where exactly will arch_fast_hash be used
References: <20141204081147.GA19030@gondor.apana.org.au> <20141204152637.GA32140@casper.infradead.org> <20141204152929.GA22075@gondor.apana.org.au> <20141204153938.GC32140@casper.infradead.org>
In-Reply-To: <20141204153938.GC32140@casper.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2014 04:39 PM, Thomas Graf wrote:
> On 12/04/14 at 11:29pm, Herbert Xu wrote:
>> On Thu, Dec 04, 2014 at 03:26:37PM +0000, Thomas Graf wrote:
>>>
>>> As Daniel pointed out, this work originated for the OVS edge use
>>> case where security is of less concern and the rehashing is
>>> sufficient. Identifying collisions is less of interest as the user
>>> space fall back provides a greater surface for an attack.
>>
>> Well in that case the current setup I think is very misleading.
>> It's inviting unsuspecting kernel developers to use it as a hash
>> function for general hash tables, which AFAICS is something that
>> it fails at miserably.
>
> Well, it's called fast hash and not secure hash ;-) but a clear hint
> definitely wouldn't hurt.

Hm, I thought the kernel doc on arch_fast_hash() in include/linux/hash.h
would give enough of a hint ...
