Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976AbaLCIJ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 03:09:58 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:32827 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbaLCIJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 03:09:55 -0500
Message-ID: <547EC54B.7040607@hitachi.com>
Date: Wed, 03 Dec 2014 17:09:47 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>, Petr Mladek <pmladek@suse.cz>,
        Seth Jennings <sjenning@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>,
        Miroslav Benes <mbenes@suse.cz>, Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>, live-patching@vger.kernel.org,
        x86@kernel.org, kpatch@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCHv3 2/3] kernel: add support for live patching
References: <1416522580-5593-1-git-send-email-sjenning@redhat.com> <1416522580-5593-3-git-send-email-sjenning@redhat.com> <546EA5DC.6000207@hitachi.com> <20141125163942.GD22487@pathway.suse.cz> <20141125115210.4d7cfca3@gandalf.local.home> <20141125170431.GE22487@pathway.suse.cz> <20141125121606.547031b4@gandalf.local.home> <alpine.LNX.2.00.1411252027040.23174@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1411252027040.23174@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/11/26 4:29), Jiri Kosina wrote:
> On Tue, 25 Nov 2014, Steven Rostedt wrote:
> 
>> It is not guaranteed from ftrace's stand point. What happens if we have
>> a kprobe handler that modifies it for someplace else? Changing the ip
>> address may not be a kpatch/kGraft privilege only.
> 
> This brings me back to the RFC patch I sent back then in october ... what 
> we really want to do is to at least warn about situations when we are 
> going to redirect code flow (through IPMODIFY) for function that has a 
> kprobe installed anywhere inside it.

Actually in my plan, normal kprobes/kretprobes don't set IPMODIFY
flag because it don't change the IP. Instead, you can even use
debugfs/kprobes/list to check whether the function is probed or not.
Or, I think we can provide atomic-conflict checking interface which
will iterate probes under locking kprobe list.

> Otherwise the probe will silently 
> vanish (there is no way how to migrate it to the new function 
> automatically), which might be very confusing for uses (cosider systemtap, 
> for example).

Yeah, I think we can add --force option(or sysctl) to patch functions
just ignoring probed or not. (for emergency vulnerability fixes)

Thank you,

> 
> I'll resurect my patch if noone beats me doing it. It should go in 
> together with the live patching framework I believe.
> 
> Thanks,
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


