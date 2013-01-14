Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757171Ab3ANO3e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 09:29:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43762 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756767Ab3ANO3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 09:29:33 -0500
Message-ID: <50F41639.2010305@redhat.com>
Date: Mon, 14 Jan 2013 09:29:13 -0500
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Josh Triplett <josh@joshtriplett.org>,
        Tim Abbott <tabbott@ksplice.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] module, fix percpu reserved memory exhaustion
References: <1357785669-31848-1-git-send-email-prarit@redhat.com> <87d2xc1itd.fsf@rustcorp.com.au> <50F01EC2.1000908@redhat.com> <87pq1byzum.fsf@rustcorp.com.au>
In-Reply-To: <87pq1byzum.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/11/2013 08:06 PM, Rusty Russell wrote:
> Prarit Bhargava <prarit@redhat.com> writes:
>> On 01/10/2013 10:48 PM, Rusty Russell wrote:
>> The timing were similar.  I didn't see any huge delays, etc.  Can the
>> relocations really cause a long delay?  I thought we were pretty much writing
>> values to memory...
> 
> For x86 that's true, but look at what ppc64 has to do for example.  I'm
> guessing you don't have a giant Nvidia proprietary driver module
> loading, either.

Ah -- I see.  I hadn't thought much about the other arches and I see what ppc64
does ...

> 
>> [I should point out that I'm booting a 32 physical/64 logical, with 64GB of memory]
> 
> I figured it had to be something big ;)

:)  Imagine what happens at 4096 cpus (SGI territory).  I'm wondering about that
kvm commit.  Maybe the systemd/udev rule needs to be rewritten to avoid a 'kvm
loading flood' during boot ... I'll talk with Kay Sievers about it to see if
there's a way around that.

> 
> OTOH, Tested-by: means it actually fixed someone's problem.

Got it.  For the record over-the-weekend testing didn't show any bizarre
results.  The boot times were all around 20-23 seconds.

Tested-by: Prarit Bhargava <prarit@redhat.com>

P.
