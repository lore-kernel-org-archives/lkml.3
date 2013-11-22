Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178Ab3KVCIQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 21:08:16 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:37896 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021Ab3KVCIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 21:08:14 -0500
Message-ID: <528EBC88.2030609@hitachi.com>
Date: Fri, 22 Nov 2013 11:08:08 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-arch@vger.kernel.org, Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Vineet Gupta <vgupta@synopsys.com>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        virtualization@lists.linux-foundation.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Jiri Slaby <jslaby@suse.cz>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH -tip v3 18/23] x86/dumpstack: Use NOKPROBE_SYMBOL macro
 in dumpstack.c
References: <20131120042148.15296.88360.stgit@kbuild-fedora.novalocal> <20131120042233.15296.31189.stgit@kbuild-fedora.novalocal> <20131121113006.GA27659@gmail.com>
In-Reply-To: <20131121113006.GA27659@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/11/21 20:30), Ingo Molnar wrote:
> 
> * Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
>> Use NOKPROBE_SYMBOL macro for protecting functions
>> from kprobes instead of __kprobes annotation in
>> dumpstack.c.
>>
>> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: "H. Peter Anvin" <hpa@zytor.com>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Jiri Slaby <jslaby@suse.cz>
>> Cc: Tejun Heo <tj@kernel.org>
>> Cc: Vineet Gupta <vgupta@synopsys.com>
>> ---
>>  arch/x86/kernel/dumpstack.c |    9 ++++++---
>>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> Btw., all these mechanic changes of the __kprobes annotation can be 
> merged into a single patch. That will cut down on the size of the 
> series substantially.

Right, I just thought it would be easy to review for each
subsystem maintainer, because some of them including
forcibly (or explicitly) inlined changes (__always_inline).

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


