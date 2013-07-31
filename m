Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596Ab3GaMSJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 08:18:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43436 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751338Ab3GaMSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 08:18:07 -0400
Message-ID: <51F9005F.30501@zytor.com>
Date: Wed, 31 Jul 2013 05:17:35 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mike Rapoport <mike.rapoport@gmail.com>
CC: Rusty Russell <rusty@rustcorp.com.au>,
        Ramkumar Ramachandra <artagnon@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [QUERY] lguest64
References: <CALkWK0n7zedKD4tnxKh-qMuDnMJ5RXjnPJ9EUWT=cCgiokX11A@mail.gmail.com> <51E97779.3020103@zytor.com> <87zjte9iah.fsf@rustcorp.com.au> <CABpLfohrweJd0=0eFJDO7dv2HHxx_mbP0uySMDrsZZZXExdXug@mail.gmail.com>
In-Reply-To: <CABpLfohrweJd0=0eFJDO7dv2HHxx_mbP0uySMDrsZZZXExdXug@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2013 02:39 AM, Mike Rapoport wrote:
> 
> The use case I had in mind is to use lguest as a nested hypervisor in
> public clouds. As of today, major public clouds do not support nested
> virtualization and it's not clear at all if they will expose this
> ability in their deployments. Addition of 64-bit support for lguest
> won't require changes to pvops and, as far as I can tell, won't change
> the number of pvops users...
> 

"We can add a pvops user and that won't change the number of pvops
users" What?!

>> Yes, the subset of x86-64 machines for which there isn't hardware
>> virtualization support is pretty uninteresting.
> 
> There are plenty virtual machines in EC2, Rackspace, HP and other
> clouds that do not have hardware virtualization. I believe that
> running a hypervisor on them may be pretty interesting.

The big problem with pvops is that they are a permanent tax on future
development -- a classic case of "the hooks problem."  As such it is
important that there be a real, significant, use case with enough users
to make the pain worthwhile.  With Xen looking at sunsetting PV support
with a long horizon, it might currently be possible to remove pvops some
time in the early 2020s or so timeframe.  Introducing and promoting a
new user now would definitely make that impossible.

So it matters that the use case be real.

	-hpa

