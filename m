Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794AbbAVPYl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 10:24:41 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:33925 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436AbbAVPYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 10:24:35 -0500
Date: Thu, 22 Jan 2015 10:24:31 -0500
From: Tejun Heo <tj@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 0/5] tracing: Add new file system tracefs
Message-ID: <20150122152431.GC4507@htj.dyndns.org>
References: <20150121171953.823177070@goodmis.org>
 <20150121230007.GA10389@kroah.com>
 <20150121204725.71933044@grimm.local.home>
 <20150121220701.22231849@grimm.local.home>
 <20150122031819.GA16561@kroah.com>
 <20150121225109.6b27b555@grimm.local.home>
 <20150122123212.GB25645@htj.dyndns.org>
 <20150122093249.6f4041a8@gandalf.local.home>
 <20150122145547.GB4507@htj.dyndns.org>
 <20150122101530.2175cf2b@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150122101530.2175cf2b@gandalf.local.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 10:15:30AM -0500, Steven Rostedt wrote:
> > kernfs provides two sets of file operations.  One is seq_file based
> > and the other is direct read/write.  In both cases, bouncing data
> > between userland and kernel is handled by kernfs.  If you already have
> > existing read write ops implemented doing custom buffer handling and
> > direct userland memory access, it'll take some adaptation but for a
> > lot of cases this would consolidate duplicate code paths.
> 
> Does it also handle splice? That's a key part of the tracing code.

It doesn't yet.  We can add it as a part of kernfs_syscall_ops tho
which exists to support these specialized bypass operations.  kernfs
doesn't do much with these.  It just passes over the calls to the
registered callbacks.

Thanks.

-- 
tejun
