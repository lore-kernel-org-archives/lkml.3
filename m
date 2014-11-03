Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751121AbaKCHu3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 02:50:29 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:57751 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbaKCHu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 02:50:28 -0500
Message-ID: <545733BD.1050708@hitachi.com>
Date: Mon, 03 Nov 2014 16:50:21 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Vojtech Pavlik <vojtech@suse.cz>, Seth Jennings <sjenning@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: Re: [for-next][PATCH 1/4] ftrace/x86: Add dynamic allocated
 trampoline for ftrace_ops
References: <20141027182702.778680710@goodmis.org> <20141027182948.284867581@goodmis.org> <54531BC7.4030307@hitachi.com> <20141031120158.1f648f7a@gandalf.local.home>
In-Reply-To: <20141031120158.1f648f7a@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/11/01 1:01), Steven Rostedt wrote:
> On Fri, 31 Oct 2014 14:19:03 +0900
> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
> 
>>> +	/* Load the contents of ptr into the callback parameter */
>>> +	offset = (unsigned long)ptr;
>>> +	offset -= (unsigned long)trampoline + op_offset + OP_REF_SIZE;
>>> +
>>> +	op_ptr.offset = offset;
>>> +
>>> +	/* put in the new offset to the ftrace_ops */
>>> +	memcpy(trampoline + op_offset, &op_ptr, OP_REF_SIZE);
>>
>> Would we better call flush_icache_range here?
> 
> Do we need to? We just allocated memory to execute. It shouldn't be in
> any CPU cache on the machine.

Indeed, if the trampoline buffer is not re-used (and it seems so),
we don't need to care about it.

OK, I've reviewed that :).

Thank you,

> 
> -- Steve
> 
> 
>>
>> Thank you,
>>
>>> +
>>> +	/* ALLOC_TRAMP flags lets us know we created it */
>>> +	ops->flags |= FTRACE_OPS_FL_ALLOC_TRAMP;
>>> +
>>> +	return (unsigned long)trampoline;
>>> +}
>>
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


