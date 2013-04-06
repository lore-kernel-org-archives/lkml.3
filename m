Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321Ab3DFFSL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 01:18:11 -0400
Received: from ozlabs.org ([203.10.76.45]:43033 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752161Ab3DFFSK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 01:18:10 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Sebastian Wankerl <sisewank@cip.cs.fau.de>
Cc: linux-kernel@vger.kernel.org, Philip Kranz <philip.kranz@googlemail.com>,
        i4passt@lists.informatik.uni-erlangen.de
Subject: Re: [PATCH] Add non-zero module sections to sysfs
In-Reply-To: <515EE63A.6050307@cip.cs.fau.de>
References: <1364994499-23708-1-git-send-email-sisewank@cip.cs.fau.de> <87mwtf3ya1.fsf@rustcorp.com.au> <515D4A7F.5070102@cip.cs.fau.de> <87vc81lj7x.fsf@rustcorp.com.au> <515EE63A.6050307@cip.cs.fau.de>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Sat, 06 Apr 2013 15:01:43 +1030
Message-ID: <87zjxcjn4g.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastian Wankerl <sisewank@cip.cs.fau.de> writes:
> On 04/05/13 06:00, Rusty Russell wrote:
>> Sebastian Wankerl <sisewank@cip.cs.fau.de> writes:
>>> On 04/04/13 03:00, Rusty Russell wrote:
>>>> Sebastian Wankerl <sisewank@cip.cs.fau.de> writes:
>>>>> Add non-zero module sections to sysfs on architectures unequal to PARISC.
>>>>> KGDB needs all module sections for proper module debugging. Therefore, commit 
>>>>> 35dead4235e2b67da7275b4122fed37099c2f462 is revoked except for PARISC
>>>>> architecture.
>>>> #ifdef CONFIG_PARISC in the middle of kernel/module.c is super-ugly, and
>>>> wrong.
>>> I don't see why this is wrong. It used to load all sections to sysfs
>>> until the patch mentioned. Actually, it is the PARISC build chain which
>>> is broken.
>
> We worked on that topic further. Now we have another suggestion: would
> it be okay to add a field to struct module for use by kgdb where we save
> the section names for our use. This seems to be the most valuable
> solution as solving the sysfs stuff is rather hard.

It is hard.  But being a kernel hacker isn't just about making newbies
eat flaming death; sometimes we need to solve problems.

We'll see what we can do; but we'll continue this in the branch of the
thread that cc's linux-parisc...

Thanks,
Rusty.
