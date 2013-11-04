Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614Ab3KDOzF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 09:55:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8460 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752554Ab3KDOzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 09:55:03 -0500
Message-ID: <5277B53D.7030100@redhat.com>
Date: Mon, 04 Nov 2013 09:54:53 -0500
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Josh Boyer <jwboyer@redhat.com>
CC: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Russ Anderson <rja@sgi.com>
Subject: Re: [PATCH] x86: Allow NR_CPUS=1024
References: <20131101141148.GH8652@hansolo.jdub.homelinux.org> <20131103101825.GA6605@gmail.com> <20131103102132.GA6807@gmail.com> <20131103155729.GB9944@hansolo.jdub.homelinux.org> <20131104065343.GC13030@gmail.com> <20131104140141.GC9944@hansolo.jdub.homelinux.org> <20131104141051.GA19355@gmail.com> <20131104141615.GD9944@hansolo.jdub.homelinux.org>
In-Reply-To: <20131104141615.GD9944@hansolo.jdub.homelinux.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/04/2013 09:16 AM, Josh Boyer wrote:
> On Mon, Nov 04, 2013 at 03:10:51PM +0100, Ingo Molnar wrote:
>>
>> * Josh Boyer <jwboyer@redhat.com> wrote:
>>
>>>> Why touch MAXSMP at all? It's really just a shortcut for 'configure 
>>>> the kernel silly large', via a single option, nothing else. You are 
>>>> not forced to use it and it should not affect configurability of 
>>>> NR_CPUS.
>>>>
>>>> What we _really_ want here is to fix NR_CPUS setting: to extend its 
>>>> range and to enforce that NR_CPUS cannot be set larger than 512 
>>>> without setting CONFIG_CPUMASK_OFFSTACK.
>>>
>>> OK.  I was just thinking that if we've come to the conclusion that 4096 
>>> CPUs isn't silly large anymore, we should make MAXSMP be something we 
>>> consider silly large. [...]
>>
>> MAXSMP is also supposed to track the real hardware max as well on x86 - 
>> i.e. we should only increase it to 8192 etc. if such hardware exists.
> 
> Russ, does SGI (or anyone else that you know of) have x86 hardware with
> more than 4096 CPUs?

I can answer this for Russ.  Yes, SGI has boxes that hit 5120.

P.

> 
> If so, I can actually make a bump to the MAXSMP count a separate patch.
> 
> josh
