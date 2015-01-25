Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755684AbbAYT7j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 14:59:39 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:37430 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754517AbbAYT7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 14:59:37 -0500
Date: Sun, 25 Jan 2015 19:59:32 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/5 v2] tracing: Automatically mount tracefs on
 debugfs/tracing
Message-ID: <20150125195932.GH29656@ZenIV.linux.org.uk>
References: <20150123155525.795129339@goodmis.org>
 <20150123162414.580817092@goodmis.org>
 <20150124030041.GB5009@kroah.com>
 <20150124063330.2c986ea2@grimm.local.home>
 <20150125132206.GA16249@kroah.com>
 <20150125143830.760c448a@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150125143830.760c448a@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 25, 2015 at 02:38:30PM -0500, Steven Rostedt wrote:
> On Sun, 25 Jan 2015 21:22:07 +0800
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> 
> 
> > If we could do it in a non-racy way, that would be good, otherwise I
> > don't see us being able to even take this patch :(
> 
> Is it still racy even if it's only done at boot up? This path only gets
> hit the first time it is called. "if (tr->flags &TRACE_ARRAY_FL_GLOBAL)"
> is the top level tracing directory ("tracing") and is only called
> during boot up (fs_initcall) and never hit again. I could even make
> this called directly by that code so we could label it "__init" to make
> sure that it is to be never hit. Or is this racy even when done by
> fs_initcall?
> 
> Waiting for Al to comment on this, because, I can't add this feature
> until debugfs/tracing still containing the tracing information,
> otherwise it will break all the tools that interact with the tracing
> infrastructure, and we all know how happy Linus feels about such
> changes.

Actually, I'm almost done massaging that sucker into adding
debugfs_create_automount().  The only remaining question is what arguments
do we put it; for now I'm giving it dentry_operations + data (to go into
inode->i_private), but it might be better to give it a pointer just to
d_automount() callback + data for it...
