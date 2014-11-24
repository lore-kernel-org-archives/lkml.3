Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114AbaKXN2H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 08:28:07 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:60369 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588AbaKXN2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 08:28:03 -0500
Message-ID: <5473325B.7070609@hitachi.com>
Date: Mon, 24 Nov 2014 22:27:55 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Seth Jennings <sjenning@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Vojtech Pavlik <vojtech@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>, Petr Mladek <pmladek@suse.cz>,
        Miroslav Benes <mbenes@suse.cz>, Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>, live-patching@vger.kernel.org,
        x86@kernel.org, kpatch@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 2/3] kernel: add support for live patching
References: <1416522580-5593-1-git-send-email-sjenning@redhat.com> <1416522580-5593-3-git-send-email-sjenning@redhat.com> <alpine.DEB.2.11.1411241209050.6439@nanos>
In-Reply-To: <alpine.DEB.2.11.1411241209050.6439@nanos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/11/24 20:13), Thomas Gleixner wrote:
> On Thu, 20 Nov 2014, Seth Jennings wrote:
>> This commit introduces code for the live patching core.  It implements
>> an ftrace-based mechanism and kernel interface for doing live patching
>> of kernel and kernel module functions.
>>
>> It represents the greatest common functionality set between kpatch and
>> kgraft and can accept patches built using either method.
>>
>> This first version does not implement any consistency mechanism that
>> ensures that old and new code do not run together.  In practice, ~90% of
>> CVEs are safe to apply in this way, since they simply add a conditional
>> check.  However, any function change that can not execute safely with
>> the old version of the function can _not_ be safely applied in this
>> version.
> 
> To be honest this sounds frightening.
> 

I see. This is just a minimal one. We'll add several consistency
mechanisms :).

> How is determined whether a change can be applied w/o a consistency
> mechanism or not?

I guess the following cases are possible to be applied.
- the code itself ensures consistency (e.g. in a critical section)
or,
- the patch just changes one place (e.g. add an if branch) and
  only depends on the local context (e.g. local variables), and
  doesn't called in a loop, so that old- and new-version of the
  function can co-exist.

Thank you,

> 
> Thanks,
> 
> 	tglx
> 
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


