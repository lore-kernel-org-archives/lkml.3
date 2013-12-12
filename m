Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860Ab3LLSEd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 13:04:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34492 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809Ab3LLSEb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 13:04:31 -0500
Message-ID: <52A9FA9E.6090604@redhat.com>
Date: Thu, 12 Dec 2013 19:04:14 +0100
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: nicolas.dichtel@6wind.com
CC: Francesco Fusco <ffusco@redhat.com>, jesse@nicira.com,
        netdev@vger.kernel.org, dev@openvswitch.org,
        Thomas Graf <tgraf@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 1/2] lib: introduce arch optimized hash library
References: <1386860946-1621-1-git-send-email-ffusco@redhat.com> <1386860946-1621-2-git-send-email-ffusco@redhat.com> <52A9F84F.8060500@6wind.com>
In-Reply-To: <52A9F84F.8060500@6wind.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2013 06:54 PM, Nicolas Dichtel wrote:
...
> Is it possible to trace that this comes from the DPDK?
> At least in the commit log, like it was done in the v1.

Hm, that got lost; but we can put that back into the commit log.
In any case, we properly included the header comment, of course.

>> +static inline u32 crc32_u32(u32 crc, u32 val)
>> +{
>> +    asm ("crc32l %1,%0\n" : "+r" (crc) : "rm" (val));
> I'm not an expert, but is it not possible to use intrisics functions, like it is
> done in the original code?

Intrinsics are not used/available in the kernel, so we used asm
as everywhere else.
