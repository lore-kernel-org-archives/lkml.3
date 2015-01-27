Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256AbbA0Cdu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 21:33:50 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:31978 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751116AbbA0Cds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 21:33:48 -0500
Date: Mon, 26 Jan 2015 21:34:19 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 00/16 v3] tracing: Add new file system tracefs
Message-ID: <20150126213419.531774eb@grimm.local.home>
In-Reply-To: <20150126183739.1d17fd82@gandalf.local.home>
References: <20150126150913.653681560@goodmis.org>
	<20150126193049.GN29656@ZenIV.linux.org.uk>
	<20150126214020.GO29656@ZenIV.linux.org.uk>
	<20150126183739.1d17fd82@gandalf.local.home>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jan 2015 18:37:39 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:


> > the first call of tracing_init_dentry().  Prior to that it's NULL.
> > BTW, may I politely inquire what the fuck are those contortions in
> > tracing_init_dentry_tr() about?  Looks like a stunningly convoluted
> > way to trigger that automount point creation early in
> > tracer_init_tracefs(). Why not do that right there explicitly?
> 
> Yeah, that could be cleaned up. Before the tracefs code, it made much
> more sense to keep that as a single function. Now that
> global_array.dir is treated differently as the subdirs, it does make
> sense to have global_arry.dir initialized in a separate function.
> 
> I'll update my patch series to do this.

Now I remember why I did this (as I changed the code and everything
blew up). The files in the tracing directory can be created by several
users (do a grep for fs_initcall() in kernel/trace/*.c). The first
caller to add a file initializes the tracing directory.

I guess I can have all the other callers use fs_initcall_sync(). I'm
assuming those come after fs_initcall().

-- Steve
