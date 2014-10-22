Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164AbaJVGzC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 02:55:02 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:51385 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754098AbaJVGzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 02:55:00 -0400
Message-ID: <544754BD.3010309@hitachi.com>
Date: Wed, 22 Oct 2014 15:54:53 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        linux-kernel@vger.kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
        Seth Jennings <sjenning@redhat.com>
Subject: Re: [PATCH] kprobes: add kprobe_is_function_probed()
References: <alpine.LNX.2.00.1410211744550.24255@pobox.suse.cz> <544716CA.2020605@hitachi.com> <alpine.LNX.2.00.1410220800040.22681@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1410220800040.22681@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/10/22 15:02), Jiri Kosina wrote:
> On Wed, 22 Oct 2014, Masami Hiramatsu wrote:
> 
>>> Add a function that allows external users (such as live patching 
>>> mechanisms) to check whether a given function (identified by symbol name) 
>>> has a kprobe installed in it.
>>
>> Actually, we've already exported the list of kprobes with probe points
>> (symbols) via debugfs. Please check /sys/kernel/debug/kprobes/list :)
> 
> Yes, I know, and kprobe_is_function_probed() is performing very similar 
> thing that show_kprobe_addr() is doing.
> But we'd like to be able to check this from within a kernel module (the 
> patch module) and issue WARN().
> 
> Otherwise we'll need to have a machinery in userspace before insmod which 
> will look up the functions in the module and compare them to the 
> debufs-provided interface.
> 
> Also, I don't think we want to be dependent on debugfs being mounted and 
> discoverable, etc ...

OK, and even if so, since there is no user of this function, at this point
we can not merge this. I'd like to wait until live patching.

BTW, if your tool is in kernel, you can use get_kprobe(addr) to check
there is kprobes on a given address. And of course you can use kallsyms
to get the address range of given function. Moreover, as Josh pointed,
there are several same name functions in kernel. I think this kind of
function should better provide address-base interface.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


