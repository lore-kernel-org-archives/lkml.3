Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757270AbaE2LMo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 07:12:44 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:40102 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbaE2LMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 07:12:43 -0400
Date: Thu, 29 May 2014 15:12:37 +0400
From: Vasily Kulikov <segoon@openwall.com>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Richard Weinberger <richard.weinberger@gmail.com>,
        containers@lists.linux-foundation.org,
        Serge Hallyn <serge.hallyn@ubuntu.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, David Howells <dhowells@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v2] /proc/pid/status: show all sets of pid according to ns
Message-ID: <20140529111236.GA14576@cachalot>
References: <1401272683-1659-1-git-send-email-chenhanxiao@cn.fujitsu.com>
 <5385DA19.2060008@parallels.com>
 <20140528182824.GA5057@cachalot>
 <53863889.9080509@parallels.com>
 <20140529055954.GA10354@cachalot>
 <5386F8EA.8050501@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5386F8EA.8050501@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 13:07 +0400, Pavel Emelyanov wrote:
> On 05/29/2014 09:59 AM, Vasily Kulikov wrote:
> > On Wed, May 28, 2014 at 23:27 +0400, Pavel Emelyanov wrote:
> > ] We need a direct method of getting the pid inside containers.
> > ] If some issues occurred inside container guest, host user
> > ] could not know which process is in trouble just by guest pid:
> > ] the users of container guest only knew the pid inside containers.
> > ] This will bring obstacle for trouble shooting.
> > 
> > A new syscall might complicate trouble shooting by admin.
> 
> Pure syscall -- yes. What if we teach the ps and top utilities to show additional
> info? I think that would help.

I like the idea with low level non-shell API which can be used by
utility like ps (or implementation of a new tool to work with complex
namespace hierarchies).  It should fit for troublesooting.  Then there
should be no reason to implement two different APIs for observation from
shell via FS and from applications.

However, maybe it is possible to implement not via new syscall but
by implementation of new symlink in sysfs?  Then both ps-like tool and
CRIU-like tool is able to obtain the ns information by the same means.
Maybe sort of a symlink to a parent namespace or a process which is
inside of the parent namespace?  Then a process may identify IDs using
following steps:

1) identify target NS by walking current procfs
2) do setns(2)/chroot(2)
3) look at procfs to identify target IDs in the target NS

It would be impossible to identify foreign IDs for unprivileged
processes, however.

Thanks,

-- 
Vasily Kulikov
http://www.openwall.com - bringing security into open computing environments
