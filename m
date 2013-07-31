Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758365Ab3GaJj0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 05:39:26 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:41046 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab3GaJjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 05:39:24 -0400
MIME-Version: 1.0
In-Reply-To: <87zjte9iah.fsf@rustcorp.com.au>
References: <CALkWK0n7zedKD4tnxKh-qMuDnMJ5RXjnPJ9EUWT=cCgiokX11A@mail.gmail.com>
	<51E97779.3020103@zytor.com>
	<87zjte9iah.fsf@rustcorp.com.au>
Date: Wed, 31 Jul 2013 12:39:23 +0300
Message-ID: <CABpLfohrweJd0=0eFJDO7dv2HHxx_mbP0uySMDrsZZZXExdXug@mail.gmail.com>
Subject: Re: [QUERY] lguest64
From: Mike Rapoport <mike.rapoport@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Ramkumar Ramachandra <artagnon@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 4:28 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> "H. Peter Anvin" <hpa@zytor.com> writes:
>> On 07/19/2013 02:06 AM, Ramkumar Ramachandra wrote:
>>> Hi,
>>>
>>> I tried building lguest to play with it, but was disappointed to find
>>> this in the Kconfig:
>>>
>>>   depends on X86_32
>>>
>>> Why is this [1]?  What is so hard about supporting 64-bit machines?  I
>>> found a five-year old tree that claims to do lguest64 [2], but didn't
>>> investigate further.
>>>

Sorry for jumping late, but, coincidentally, I was thinking about
extending lguest for 64-bits and while googling about the subj, I've
crossed this thread...

>> Please don't have us deal with another lguest unless there is a use case
>> for it.  We want to reduce pvops and pvops users, not increase them...
>>
>>       -hpa

The use case I had in mind is to use lguest as a nested hypervisor in
public clouds. As of today, major public clouds do not support nested
virtualization and it's not clear at all if they will expose this
ability in their deployments. Addition of 64-bit support for lguest
won't require changes to pvops and, as far as I can tell, won't change
the number of pvops users...

> Yes, the subset of x86-64 machines for which there isn't hardware
> virtualization support is pretty uninteresting.

There are plenty virtual machines in EC2, Rackspace, HP and other
clouds that do not have hardware virtualization. I believe that
running a hypervisor on them may be pretty interesting.

> Cheers,
> Rusty.


-- 
Sincerely yours,
Mike.
