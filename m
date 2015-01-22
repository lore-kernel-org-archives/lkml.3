Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853AbbAVDuv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 22:50:51 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:7715 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750898AbbAVDum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 22:50:42 -0500
Date: Wed, 21 Jan 2015 22:51:09 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: tj@kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 0/5] tracing: Add new file system tracefs
Message-ID: <20150121225109.6b27b555@grimm.local.home>
In-Reply-To: <20150122031819.GA16561@kroah.com>
References: <20150121171953.823177070@goodmis.org>
	<20150121230007.GA10389@kroah.com>
	<20150121204725.71933044@grimm.local.home>
	<20150121220701.22231849@grimm.local.home>
	<20150122031819.GA16561@kroah.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jan 2015 11:18:19 +0800
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:


> Tejun would know best, he wrote it :)

Oh good, as Bugs Bunny would say "where's the doc?" (or was that
"what's up doc"?)

> 
> What specifically are you looking for?  I think there's at least two
> filesystems using it already, are they not good enough examples?
> 

Well, I see the two biggest users are sysfs and cgroups, where I never
understood how sysfs actually works, and cgroups, the filesystem is
very integrated with the usage of cgroups.

There doesn't seem to be any abi where one can relate to the vfs
system.

I'd like to keep the interface like debugfs had for tracefs, because
all of tracing depends on it, and it would require a full rewrite to
convert it to something that doesn't have the vfs type of paradigm, in
which case, tracefs would not be done for another decade.

That is, I need to create the following interface:

  tracefs_create_file()
  tracefs_create_dir()
  tracefs_remove()
  tracefs_remove_recursive()

and that's all I need for the filesystem. There doesn't seem to be any
documentation on kernfs about how to implement this.

Yes, I can study the code, but I was hoping that there was some
kernfs.txt that described how to create a new fs with it. It just saves
time if there was a document than having to read the code and perhaps
use it in a way it wasn't supposed to be used.

-- Steve
