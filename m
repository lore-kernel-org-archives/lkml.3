Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354AbbAVMcS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 07:32:18 -0500
Received: from mail-qa0-f45.google.com ([209.85.216.45]:40672 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201AbbAVMcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 07:32:16 -0500
Date: Thu, 22 Jan 2015 07:32:12 -0500
From: Tejun Heo <tj@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 0/5] tracing: Add new file system tracefs
Message-ID: <20150122123212.GB25645@htj.dyndns.org>
References: <20150121171953.823177070@goodmis.org>
 <20150121230007.GA10389@kroah.com>
 <20150121204725.71933044@grimm.local.home>
 <20150121220701.22231849@grimm.local.home>
 <20150122031819.GA16561@kroah.com>
 <20150121225109.6b27b555@grimm.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150121225109.6b27b555@grimm.local.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Steven.

On Wed, Jan 21, 2015 at 10:51:09PM -0500, Steven Rostedt wrote:
> > Tejun would know best, he wrote it :)
> 
> Oh good, as Bugs Bunny would say "where's the doc?" (or was that
> "what's up doc"?)

I didn't write any while extracting it out of sysfs.  Sorry about
that.  I should get to it.

> > What specifically are you looking for?  I think there's at least two
> > filesystems using it already, are they not good enough examples?
> 
> Well, I see the two biggest users are sysfs and cgroups, where I never
> understood how sysfs actually works, and cgroups, the filesystem is
> very integrated with the usage of cgroups.

Yes, cgroup's usage is rather complicated.  I wouldn't suggest it as a
good example.  sysfs's usage is a bit complicated too in part because
of the namespace support.

> There doesn't seem to be any abi where one can relate to the vfs
> system.
> 
> I'd like to keep the interface like debugfs had for tracefs, because
> all of tracing depends on it, and it would require a full rewrite to
> convert it to something that doesn't have the vfs type of paradigm, in
> which case, tracefs would not be done for another decade.
> 
> That is, I need to create the following interface:
> 
>   tracefs_create_file()

kernfs_create_file()

>   tracefs_create_dir()

kernfs_create_dir()

>   tracefs_remove()
>   tracefs_remove_recursive()

kernfs_remove[_by_name]() - recursive by default

> and that's all I need for the filesystem. There doesn't seem to be any
> documentation on kernfs about how to implement this.
> 
> Yes, I can study the code, but I was hoping that there was some
> kernfs.txt that described how to create a new fs with it. It just saves
> time if there was a document than having to read the code and perhaps
> use it in a way it wasn't supposed to be used.

Yeah yeah, I hear you.  I'll write one up.

Thanks.

-- 
tejun
