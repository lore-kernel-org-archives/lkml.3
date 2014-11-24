Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417AbaKXQSf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 11:18:35 -0500
Received: from lists.s-osg.org ([54.187.51.154]:56419 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753794AbaKXQSd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 11:18:33 -0500
Message-ID: <54735A4F.8090602@osg.samsung.com>
Date: Mon, 24 Nov 2014 09:18:23 -0700
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>
CC: Josh Poimboeuf <jpoimboe@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, Seth Jennings <sjenning@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Petr Mladek <pmladek@suse.cz>, Vojtech Pavlik <vojtech@suse.cz>,
        Namhyung Kim <namhyung@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
        Ingo Molnar <mingo@kernel.org>, Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH ftrace/core v6 5/5] kselftest, ftrace: Add ftrace IPMODIFY
 flag test
References: <20141121102502.11844.82696.stgit@localhost.localdomain> <20141121102537.11844.9781.stgit@localhost.localdomain> <20141121160329.575fd043@gandalf.local.home> <54729CDE.5030700@hitachi.com> <20141123232932.1ed70d18@gandalf.local.home> <54733C80.6060509@hitachi.com>
In-Reply-To: <54733C80.6060509@hitachi.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2014 07:11 AM, Masami Hiramatsu wrote:
> (CC'ed Shuah, since this is related to kselftest)
> 
> 
> So, if your server directory is mounted with noexec, it's an environmental
> problem. I guess you can not build any kernel drivers on that testbox, can you?
> 
> Anyway, this gives us a good question, "should test binaries be made by
> server or client(testbox) environment?" This ipmodify driver is a binary
> and it should be built with the kernel binary (by server) I think.
> But yes, I missed the Makefile didn't allow that (this always referred
> installed running kernel builddir).
> 
> I hope to have CONFIG_KSELFTEST_BINARIES for Kconfig, or make prep_kselftest
> target to build these binaries with kernel...
> 
> Shuah, what would you think about this?

I am working on patch series to add an install target to the
main kernel makefile, so these tests can be built and installed
on a target just like we do with kernel and modules. I hope to
get this in 3.19 or definitely into 3.20

This probably will help address the problem you are seeing.
Install target is needed for qemu type environments as well.

thanks,
-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
