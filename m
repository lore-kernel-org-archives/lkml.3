Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756408Ab3GYXoB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 19:44:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40575 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324Ab3GYXn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 19:43:58 -0400
Date: Thu, 25 Jul 2013 16:43:57 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Alexander Z Lam <azl@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Sharp <dhsharp@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: PATCH? debugfs_remove_recursive() must not rely on
 list_empty(d_subdirs)
Message-ID: <20130725234357.GA14958@kroah.com>
References: <20130723205854.GA9036@redhat.com>
 <20130724184640.GA21322@redhat.com>
 <20130725192742.GA14060@redhat.com>
 <20130725200423.GA22274@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130725200423.GA22274@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 10:04:23PM +0200, Oleg Nesterov wrote:
> On 07/25, Oleg Nesterov wrote:
> >
> > To simplify the review, this is how it looks with the patch applied:
> 
> v2. We can use simply use list_for_each_entry_safe() and
> list_next_entry() should be calles under ->i_mutex. Although
> debugfs_remove_recursive() can race with itself anyway, but
> still.
> 
> And the code looks much simpler. But I do not know what did
> I miss.

debugfs has a number of known issues with removing files / directories.
Al has helpfully pointed them out to me, and it's on my list of things
to fix, but it keeps getting pushed down by other things.  Hopefully in
a few weeks...

Anyway, your changes below look good in this version, I don't see
anything obviously wrong with it, but maybe others do?

Care to turn this version into a patch I can test out?

thanks,

greg k-h
