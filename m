Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751803Ab3FWOlC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 10:41:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43179 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478Ab3FWOk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 10:40:59 -0400
Date: Sun, 23 Jun 2013 16:36:34 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Dave Jones <davej@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>
Subject: Re: frequent softlockups with 3.10rc6.
Message-ID: <20130623143634.GA2000@redhat.com>
References: <20130619164540.GB22483@redhat.com> <20130619175356.GA23673@redhat.com> <20130619181302.GE5146@linux.vnet.ibm.com> <20130620001212.GB12151@redhat.com> <20130620161652.GA4462@linux.vnet.ibm.com> <20130621151119.GA1596@redhat.com> <20130621195949.GA15519@redhat.com> <20130622013731.GA22918@redhat.com> <20130622173129.GA29375@redhat.com> <20130622215905.GA28238@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130622215905.GA28238@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22, Dave Jones wrote:
>
> On Sat, Jun 22, 2013 at 07:31:29PM +0200, Oleg Nesterov wrote:
>
>  > > [ 7485.261299] WARNING: at include/linux/nsproxy.h:63 get_proc_task_net+0x1c8/0x1d0()
>  >
>  > Hmm. The test case tries to create the symlink in /proc/*/net/ ?
>
> hit it with symlink, but also some other syscalls. eg:

Yes, this is fine, the warnings without lockup are not interesting.
I thought that, perhaps, an exiting task can trigger this WARN()
from task_work_run(). And this would be fine too! But this could
provide more info if lockup happens after that. So please ignore.

>  > But it seems you can't ?
>  >
>  > Dave, I am sorry but all I can do is to ask you to do more testing.
>  > Could you please reproduce the lockup again on the clean Linus's
>  > current ? (and _without_ reverting 8aac6270, of course).
>
> I'll give it a shot.  Just rebuilt clean tree, and restarted the tests.

Thanks a lot.

Oleg.

