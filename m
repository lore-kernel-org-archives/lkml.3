Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757661Ab3B0TmE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 14:42:04 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31211 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756104Ab3B0TmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 14:42:00 -0500
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=U4Gqj4L1R_IA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=4SGMelHJhgIA:10 a=oMXxmQDKa7VE_M4P5f8A:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1361994117.1231.10.camel@gandalf.local.home>
Subject: Re: [for-next][PATCH 0/8] tracing: Addition of multiple buffers
From: Steven Rostedt <rostedt@goodmis.org>
To: David Sharp <dhsharp@google.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>, hcochran@lexmark.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Wed, 27 Feb 2013 14:41:57 -0500
In-Reply-To: <CAJL_ektutOw1Q_NzRBPU2zADjgKZ=H70VCW_6QYpibpQRr+K8g@mail.gmail.com>
References: <20130227172232.707306533@goodmis.org>
	 <CAJL_ektutOw1Q_NzRBPU2zADjgKZ=H70VCW_6QYpibpQRr+K8g@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-02-27 at 11:37 -0800, David Sharp wrote:
> On Wed, Feb 27, 2013 at 9:22 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > With this patch set, a new directory is created in the debug/tracing
> > directory called "instances". Here you can mkdir/rmdir a new directory
> > that will contain some of the files in the debug/tracing directory.
> > Note, this is not totally finished, but it's at a point were it is
> > functional and useful.
> >
> > To add mkdir/rmdir in debugfs, as debugfs does not support these operations,
> 
> Is there some reason not to extend debugfs to support mkdir/rmdir?

Yeah, Greg KH NACK'd the idea, and he's the debugfs maintainer.

He also suggested the tracefs addition, which I do intend on doing, but
until then this is going to be the work around.

-- Steve

> 
> > I had to have the instances' inode use its own inode_operations and add a
> > mkdir and rmdir method. As the instances directory can not be renamed
> > or removed, or modified in any other way, it has the inode mutex released
> > in order to call back to create or remove the debugfs directories.
> > It has its own mutex to protect against multiple instances of this,
> > and I've run many stress tests to make sure it can't crash. I haven't
> > found were it can. The alternative is to have a "new" and "free" file
> > to create and remove directories and it will basically do the exact
> > same thing that the mkdir/rmdir does now, with the exact same protection.
> > I do eventually want to make a tracefs, but that requires a lot of
> > design planning and wont be in the near future (too many other things
> > to do).


