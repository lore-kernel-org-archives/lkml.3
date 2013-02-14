Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934870Ab3BNTV0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 14:21:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55480 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934815Ab3BNTVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 14:21:25 -0500
Message-ID: <511D3928.80402@zytor.com>
Date: Thu, 14 Feb 2013 11:21:12 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] x86: make PTRACE_GETREGSET return 32-bit regs if 64-bit
 process entered kernel with int 80
References: <511CE3D0.8000308@redhat.com> <20130214150046.GA30543@redhat.com> <511D2779.7040504@zytor.com> <20130214191842.GA11620@redhat.com>
In-Reply-To: <20130214191842.GA11620@redhat.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2013 11:18 AM, Oleg Nesterov wrote:
> On 02/14, H. Peter Anvin wrote:
>>
>> On 02/14/2013 07:00 AM, Oleg Nesterov wrote:
>>> On 02/14, Denys Vlasenko wrote:
>>>>
>>>> Determining personality of a ptraced process is a murky area.
>>>> On x86, for years strace was looking at segment selectors,
>>>> which is conceptually wrong: see, for example,
>>>> https://lkml.org/lkml/2012/1/18/320
>>>>
>>
>> One proposal that keeps being on the table is to export a regset with
>> metadatam, including process mode at launch (i386, x86-64, x32).
> 
> Yes... but if this metadata includes TS_COMPAT-is-set, then strace should
> do PTRACE_GETREGSET(REGSET_META) + PTRACE_GETREGSET(REGSET_GENERAL) every
> time. Or REGSET_META should include META+GENERAL.
> 
> IOW, it is not clear to me what this "meta" should actually report.
> 

That is one of the things that needs to be nailed down.  In particular,
what are the things people need.

	-hpa


