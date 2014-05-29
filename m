Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757207AbaE2KUq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 06:20:46 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756095AbaE2KUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 06:20:44 -0400
Message-ID: <538709A5.60000@nod.at>
Date: Thu, 29 May 2014 12:19:17 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Pavel Emelyanov <xemul@parallels.com>
CC: Vasily Kulikov <segoon@openwall.com>,
        containers@lists.linux-foundation.org,
        Serge Hallyn <serge.hallyn@ubuntu.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, David Howells <dhowells@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v2] /proc/pid/status: show all sets of pid according to
 ns
References: <1401272683-1659-1-git-send-email-chenhanxiao@cn.fujitsu.com> <5385DA19.2060008@parallels.com> <20140528182824.GA5057@cachalot> <53863889.9080509@parallels.com> <20140529055954.GA10354@cachalot> <5386F8EA.8050501@parallels.com> <5386FC0C.9000307@nod.at> <538700B5.5070601@parallels.com> <538703D0.7030308@nod.at> <5387059E.9010105@parallels.com>
In-Reply-To: <5387059E.9010105@parallels.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 29.05.2014 12:02, schrieb Pavel Emelyanov:
>>> We need to know what pid namespaces a task lives in and how pid, sid and
>>> pgid look in all of them. A short example with pids only
>>
>> So use case is to checkpoint/restore nested containers? :)
> 
> Yes, but there's one more scenario. AFAIK some applications create pid namespaces 
> themselves, without starting what is typically called "a container" :) And when 
> such an applications are run inside, well ... "more real" container (e.g. using
> openvz, lxc or docker tools) we face this issue.

Do you know such an application?
I'm a aware of systemd which uses CLONE_NEWNET/NS to implement security features.

We could add a directory like /proc/<pidX>/ns/proc/ which would contain everything
from /proc/<pidX inside the namespace>/.

This needs definitely more discussion and must not solved by ad-hoc solutions.

Thanks,
//richard
