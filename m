Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229AbaE2Khc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 06:37:32 -0400
Received: from relay.parallels.com ([195.214.232.42]:57009 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756341AbaE2Khb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 06:37:31 -0400
Message-ID: <53870DC8.40908@parallels.com>
Date: Thu, 29 May 2014 14:36:56 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>
CC: Vasily Kulikov <segoon@openwall.com>,
        <containers@lists.linux-foundation.org>,
        Serge Hallyn <serge.hallyn@ubuntu.com>, <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, David Howells <dhowells@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v2] /proc/pid/status: show all sets of pid according to
 ns
References: <1401272683-1659-1-git-send-email-chenhanxiao@cn.fujitsu.com> <5385DA19.2060008@parallels.com> <20140528182824.GA5057@cachalot> <53863889.9080509@parallels.com> <20140529055954.GA10354@cachalot> <5386F8EA.8050501@parallels.com> <5386FC0C.9000307@nod.at> <538700B5.5070601@parallels.com> <538703D0.7030308@nod.at> <5387059E.9010105@parallels.com> <538709A5.60000@nod.at>
In-Reply-To: <538709A5.60000@nod.at>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.24.36.87]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2014 02:19 PM, Richard Weinberger wrote:
> Am 29.05.2014 12:02, schrieb Pavel Emelyanov:
>>>> We need to know what pid namespaces a task lives in and how pid, sid and
>>>> pgid look in all of them. A short example with pids only
>>>
>>> So use case is to checkpoint/restore nested containers? :)
>>
>> Yes, but there's one more scenario. AFAIK some applications create pid namespaces 
>> themselves, without starting what is typically called "a container" :) And when 
>> such an applications are run inside, well ... "more real" container (e.g. using
>> openvz, lxc or docker tools) we face this issue.
> 
> Do you know such an application?

There were a couple of them reported on the criu mailing list, but I didn't
track those :(

> I'm a aware of systemd which uses CLONE_NEWNET/NS to implement security features.

Yup, this is its typical behavior.

> We could add a directory like /proc/<pidX>/ns/proc/ which would contain everything
> from /proc/<pidX inside the namespace>/.

But how would it help to find out which $pid directories correspond to which
to properly collect the pid mappings?

> This needs definitely more discussion and must not solved by ad-hoc solutions.

Absolutely.

Thanks,
Pavel
