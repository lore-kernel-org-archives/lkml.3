Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630AbaI2OME (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 10:12:04 -0400
Received: from outbound-smtp04.blacknight.com ([81.17.249.35]:54505 "EHLO
	outbound-smtp04.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754595AbaI2OMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 10:12:01 -0400
Message-ID: <542968AE.3090407@nexus-software.ie>
Date: Mon, 29 Sep 2014 15:11:58 +0100
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] x86: Quark: Enable correct cache size/type reporting
References: <1411956372-16469-1-git-send-email-pure.logic@nexus-software.ie> <1411956372-16469-2-git-send-email-pure.logic@nexus-software.ie> <20140929134008.GA7764@redhat.com>
In-Reply-To: <20140929134008.GA7764@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/09/14 14:40, Dave Jones wrote:
> On Mon, Sep 29, 2014 at 03:06:12AM +0100, Bryan O'Donoghue wrote:
>   > Quark X1000 lacks cpuid(4). It has cpuid(2) but returns no cache
>   > descriptors we can work with i.e. cpuid(2) returns
>   > eax=0x00000001 ebx=0x00000000 ecx=0x00000000 edx=0x00000000
>   >
>   > Quark X1000 contains a 16k 4-way set associative unified L1 cache
>   > with 256 sets
>   >
>   > This patch emulates cpuid(4) in a similar way to other x86
>   > processors like AMDs which don't support cpuid(4). The Quark code
>   > is based on the existing AMD code.
>
> This looks like it would work, but I wonder if it would be a lot
> simpler to do something like what we do in centaur_size_cache()
> which is the other case I recall where we had to override
> the CPUs definition of cache size.

Hi Dave.

It's working alright :)

My feeling is that we'll probably end up with less changes/new code 
taking the approach of quirking.
