Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751401AbaK0GM7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 01:12:59 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:52541 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbaK0GM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 01:12:58 -0500
Message-ID: <5476C0E2.5050602@hitachi.com>
Date: Thu, 27 Nov 2014 15:12:50 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
Cc: Seth Jennings <sjenning@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Petr Mladek <pmladek@suse.cz>, Miroslav Benes <mbenes@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>, live-patching@vger.kernel.org,
        x86@kernel.org, kpatch@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 0/3] Kernel Live Patching
References: <1416935709-404-1-git-send-email-sjenning@redhat.com> <547596C6.2050303@hitachi.com> <alpine.LNX.2.00.1411261014510.23174@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1411261014510.23174@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/11/26 18:18), Jiri Kosina wrote:
> On Wed, 26 Nov 2014, Masami Hiramatsu wrote:
> 
>>> Note to Steve:
>>> Masami's IPMODIFY patch is heading for -next via your tree.  Once it arrives,
>>> I'll rebase and make the change to set IPMODIFY.  Do not pull this for -next
>>> yet.  This version (v4) is for review and gathering acks.
>>
>> BTW, as we discussed IPMODIFY is an exclusive flag. So if we allocate 
>> ftrace_ops for each function in each patch, it could be conflict each 
>> other.
> 
> Yup, this corresponds to what Petr brought up yesterday. There are cases 
> where all solutions (kpatch, kgraft, klp) would allocate multiple 
> ftrace_ops for a single function entry (think of patching one function 
> multiple times in a row).
> 
> So it's not as easy as just setting the flag.
> 
>> Maybe we need to have another ops hashtable to find such conflict and 
>> new handler to handle it.
> 
> If I understand your proposal correctly, that would sound like a hackish 
> workaround, trying to basically trick the IPMODIFY flag semantics you just 
> implemented :)
> 
> What I'd propose instead is to make sure that we always have 
> just a ftrace_ops per function entry, and only update the pointers there 
> as necessary. Fortunately we can do the switch atomically, by making use 
> of ->private.

Would you mean per existing function entry, not per klp-func entry?
If so, it sounds good to me too :)

Thank you,


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


