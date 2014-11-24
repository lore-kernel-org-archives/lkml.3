Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067AbaKXO0K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 09:26:10 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:34326 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319AbaKXO0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 09:26:06 -0500
Message-ID: <54733FF6.7080301@hitachi.com>
Date: Mon, 24 Nov 2014 23:25:58 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Vojtech Pavlik <vojtech@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jiri Kosina <jkosina@suse.cz>,
        Seth Jennings <sjenning@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, Petr Mladek <pmladek@suse.cz>,
        Miroslav Benes <mbenes@suse.cz>, Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>, live-patching@vger.kernel.org,
        x86@kernel.org, kpatch@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 2/3] kernel: add support for live patching
References: <1416522580-5593-1-git-send-email-sjenning@redhat.com> <1416522580-5593-3-git-send-email-sjenning@redhat.com> <alpine.DEB.2.11.1411241209050.6439@nanos> <alpine.LNX.2.00.1411241414280.23174@pobox.suse.cz> <alpine.DEB.2.11.1411241423270.6439@nanos> <20141124133139.GD2054@suse.cz>
In-Reply-To: <20141124133139.GD2054@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/11/24 22:31), Vojtech Pavlik wrote:
> On Mon, Nov 24, 2014 at 02:26:08PM +0100, Thomas Gleixner wrote:
>> On Mon, 24 Nov 2014, Jiri Kosina wrote:
>>> On Mon, 24 Nov 2014, Thomas Gleixner wrote:
>>>> How is determined whether a change can be applied w/o a consistency
>>>> mechanism or not?
>>>
>>> By a human being producing the "live patch" code.
>>>
>>> If the semantics of the patch requires consistency mechanism to be applied 
>>> (such as "old and new function must not run in parallel, because locking 
>>> rules would be violated", or "return value from a function that is being 
>>> called in a loop is changing its meaning", etc.), then this first naive 
>>> implementation simply can't be used.
>>>
>>> For simple things though, such as "add a missing bounds check to sys_foo() 
>>> prologue and return -EINVAL if out-of-bounds", this is sufficient.
>>>
>>> It's being designed in a way that more advanced consistency models (such 
>>> as the ones kgraft and kpatch are currently implementing) can be built on 
>>> top of it.
>>>
>>> The person writing the patch would always need to understand what he is 
>>> doing to be able to pick correct consistency model to be used. I 
>>> personally think this is a good thing -- this is nothing where we should 
>>> be relying on any kinds of tools.
>>
>> But why want we to provide a mechanism which has no consistency
>> enforcement at all?
>>
>> Surely you can argue that the person who is doing that is supposed to
>> know what he's doing, but what's the downside of enforcing consistency
>> mechanisms on all live code changes?
> 
> The consistency engine implementing the consistency model is the most
> complex part of the live patching technology. We want to have something
> small, easy to understand pushed out first, to build on top of that.

I think we'd better incubate this live patching in another tree
until those consistency engines/models are enough prepared.

> 
> Plus we're still discussing which exact consistency model to use for
> upstream live patching (there are many considerations) and whether one
> is enough, or whether an engine that can do more than one is required.
> 
> The consistency models of kpatch and kGraft aren't directly compatible.

It maybe not compatible, but complementary. This patch series clarifies
the common patch module format, I think we just need consistency engines
and selector flag for each patch module.

Thank you,

> 
> I think we're on a good way towards a single model, but we'll see when
> it's implemented within the live patching framework just posted.
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


