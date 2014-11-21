Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757806AbaKUCoy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 21:44:54 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:47582 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757101AbaKUCox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 21:44:53 -0500
X-Greylist: delayed 321 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Nov 2014 21:44:52 EST
Message-ID: <546EA71E.6000004@hitachi.com>
Date: Fri, 21 Nov 2014 11:44:46 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Seth Jennings <sjenning@redhat.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Petr Mladek <pmladek@suse.cz>, Miroslav Benes <mbenes@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>, live-patching@vger.kernel.org,
        x86@kernel.org, kpatch@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 0/3] Kernel Live Patching
References: <1416522580-5593-1-git-send-email-sjenning@redhat.com>
In-Reply-To: <1416522580-5593-1-git-send-email-sjenning@redhat.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Seth,

(2014/11/21 7:29), Seth Jennings wrote:
> Summary:
> 
> This patchset implements an ftrace-based mechanism and kernel interface for
> doing live patching of kernel and kernel module functions.  It represents the
> greatest common functionality set between kpatch [1] and kGraft [2] and can
> accept patches built using either method.  This solution was discussed in the
> Live Patching Mini-conference at LPC 2014 [3].
> 
> The model consists of a live patching "core" that provides an interface for
> other "patch" kernel modules to register patches with the core.
> 
> Patch modules contain the new function code and create an klp_patch structure
> containing the required data about what functions to patch, where the new code
> for each patched function resides, and in which kernel object (vmlinux or
> module) the function to be patch resides.  The patch module then invokes the
> klp_register_patch() function to register with the core, then klp_enable_patch()
> to have the core redirect the execution paths using ftrace.
> 
> An example patch module can be found here:
> https://github.com/spartacus06/livepatch/blob/master/patch/patch.c

Hmm, I think we should import this example under samples/livepatch/ or
tools/testing/selftests/livepatch/ for self testing, so that others
can easily see what will happen. :)

Thank you,


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


