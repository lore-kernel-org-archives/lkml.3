Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717Ab3EXFpK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 01:45:10 -0400
Received: from relay.parallels.com ([195.214.232.42]:44869 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016Ab3EXFpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 01:45:08 -0400
Message-ID: <519EFE46.2070507@parallels.com>
Date: Fri, 24 May 2013 09:44:38 +0400
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: "J. Bruce Fields" <bfields@fieldses.org>
CC: Jeff Layton <jlayton@redhat.com>, Boaz Harrosh <bharrosh@panasas.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, <viro@zeniv.linux.org.uk>,
        <serge.hallyn@canonical.com>, <lucas.demarchi@profusion.mobi>,
        <rusty@rustcorp.com.au>, <linux-kernel@vger.kernel.org>,
        <oleg@redhat.com>, <linux-fsdevel@vger.kernel.org>,
        <akpm@linux-foundation.org>, <devel@openvz.org>
Subject: Re: [RFC PATCH] fs: call_usermodehelper_root helper introduced
References: <878v36ex6n.fsf@xmission.com> <519DCE5D.6070204@parallels.com> <87k3mq9fsu.fsf@xmission.com> <519DF109.9010309@parallels.com> <20130523073108.13afafa6@tlielax.poochiereds.net> <519DFFA9.3010606@parallels.com> <20130523075620.21abf79a@tlielax.poochiereds.net> <519E0474.5000606@parallels.com> <519E0AB0.7040704@panasas.com> <20130523090526.63fc153e@corrin.poochiereds.net> <20130523195547.GA13640@fieldses.org>
In-Reply-To: <20130523195547.GA13640@fieldses.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.18.163]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

23.05.2013 23:55, J. Bruce Fields пишет:
> On Thu, May 23, 2013 at 09:05:26AM -0400, Jeff Layton wrote:
>> On Thu, 23 May 2013 15:25:20 +0300
>>> I'm not familiar with nfsdcltrack but I would imagine it receives it's information from
>>> Kernel as a command line parameters.
>>>
>>> Would it not be the simplest approach to add a --chroot=/path/to/root optional
>>> parameter to nfsdcltrack so it should access an alternate DB relative to
>>> --chroot.
>>>
>>> This would address Eric's concern of not executing user-privileged executable
>>> from Kernel. I think
>>>
>>> Just my $0.017
>>> Boaz
>>>
>>
>> I think that sounds reasonable. Is it always the case
>> that /path/to/root is reachable from the "primary" namespace?
>
> I don't think we can assume that.
>

Yes, we can't. For example in case of different mount namespaces.

>> If not, you may need to do something more exotic there.
>
> We should be able to pass a file descriptor and then work relative to
> that.
>

We can't do this either.
Moreover, passing a file descriptor is something, that solves (?) completely different problem.
Imagine the following:
1) We have a host, based on, say RHEL6, which nfs-utils has doesn't have "/sbin/nfsdcltrack" and all.
2) And we have a container in it, based on, say, Fedora-19, which nfs-utils has this binary.

In case of starting NFSd in Fedora CT, we won't be able to execute the desired binary without root swapping.
Because we won't be able to even lookup it in the host file system.

So, as I said previously, the main problem here is not how to modify the userspace binary, but how to lookup and execute the right (!) one.
And I don't see, how we can do this (simple enough) without root swap.


-- 
Best regards,
Stanislav Kinsbursky
