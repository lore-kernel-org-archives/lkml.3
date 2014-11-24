Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991AbaKXPSm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 10:18:42 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:46336 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753772AbaKXPSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 10:18:39 -0500
Date: Mon, 24 Nov 2014 10:18:31 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, Seth Jennings <sjenning@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Petr Mladek <pmladek@suse.cz>, Vojtech Pavlik <vojtech@suse.cz>,
        Namhyung Kim <namhyung@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
        Ingo Molnar <mingo@kernel.org>, Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH ftrace/core v6 5/5] kselftest, ftrace: Add ftrace
 IPMODIFY flag test
Message-ID: <20141124101831.69f6db23@gandalf.local.home>
In-Reply-To: <20141124100727.19531a3b@gandalf.local.home>
References: <20141121102502.11844.82696.stgit@localhost.localdomain>
	<20141121102537.11844.9781.stgit@localhost.localdomain>
	<20141121160329.575fd043@gandalf.local.home>
	<54729CDE.5030700@hitachi.com>
	<20141123232932.1ed70d18@gandalf.local.home>
	<54733C80.6060509@hitachi.com>
	<20141124100727.19531a3b@gandalf.local.home>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Nov 2014 10:07:27 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Mon, 24 Nov 2014 23:11:12 +0900
> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
>  
> > So, if your server directory is mounted with noexec, it's an environmental
> > problem. I guess you can not build any kernel drivers on that testbox, can you?
> > 
> 
> You're right about the noexec, even though my fstab has "exec" in it ??

Ha! I hit this bug!

  https://bugzilla.redhat.com/show_bug.cgi?id=769636

If I remove "user" from the flags, it mounts exec.

This test box runs Fedora 18.

-- Steve

