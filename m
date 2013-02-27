Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760797Ab3B0Thc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 14:37:32 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:47573 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981Ab3B0Tha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 14:37:30 -0500
MIME-Version: 1.0
In-Reply-To: <20130227172232.707306533@goodmis.org>
References: <20130227172232.707306533@goodmis.org>
From: David Sharp <dhsharp@google.com>
Date: Wed, 27 Feb 2013 11:37:06 -0800
Message-ID: <CAJL_ektutOw1Q_NzRBPU2zADjgKZ=H70VCW_6QYpibpQRr+K8g@mail.gmail.com>
Subject: Re: [for-next][PATCH 0/8] tracing: Addition of multiple buffers
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>, hcochran@lexmark.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 9:22 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> With this patch set, a new directory is created in the debug/tracing
> directory called "instances". Here you can mkdir/rmdir a new directory
> that will contain some of the files in the debug/tracing directory.
> Note, this is not totally finished, but it's at a point were it is
> functional and useful.
>
> To add mkdir/rmdir in debugfs, as debugfs does not support these operations,

Is there some reason not to extend debugfs to support mkdir/rmdir?

> I had to have the instances' inode use its own inode_operations and add a
> mkdir and rmdir method. As the instances directory can not be renamed
> or removed, or modified in any other way, it has the inode mutex released
> in order to call back to create or remove the debugfs directories.
> It has its own mutex to protect against multiple instances of this,
> and I've run many stress tests to make sure it can't crash. I haven't
> found were it can. The alternative is to have a "new" and "free" file
> to create and remove directories and it will basically do the exact
> same thing that the mkdir/rmdir does now, with the exact same protection.
> I do eventually want to make a tracefs, but that requires a lot of
> design planning and wont be in the near future (too many other things
> to do).
