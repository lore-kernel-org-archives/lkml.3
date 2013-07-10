Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab3GJW1B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 18:27:01 -0400
Received: from prod-mail-xrelay07.akamai.com ([72.246.2.115]:40302 "EHLO
	prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754259Ab3GJW1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 18:27:00 -0400
Message-ID: <51DDDFB3.3020004@akamai.com>
Date: Wed, 10 Jul 2013 18:26:59 -0400
From: Jason Baron <jbaron@akamai.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        mathieu.desnoyers@efficios.com
Subject: Re: [RFC] [PATCH 0/2] x86: make jump labels use int3-based breakpoint
 instead of stop_machine()
References: <alpine.LNX.2.00.1307102213140.25858@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1307102213140.25858@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2013 04:25 PM, Jiri Kosina wrote:
> Hi,
>
> this is a resurrection of a few years old idea to have jump labels use 
> synchronization based on int3 breakpoint rather than relying on 
> stop_machine() with all the consequences.
>
> ftrace has been doing exactly this kind of patching for year since 
> 08d636b6 ("ftrace/x86: Have arch x86_64 use breakpoints instead of stop 
> machine").
>
> This patchset first introduces generic text_poke_bp() that provides means 
> to perform this method of patching in parallel to text_poke_smp(), and 
> then converts x86 jump label code to use it.
>
> If this is merged, I'll do a followup patch converting ftrace to use this 
> infrastructure as well, as it's doing the same thing in principle already.
>
> Comments welcome.
>

Cool. This definitely an area I've wanted to improve with jump labels.

Perhaps, ftrace should be considered at this point to make sure the
interface is suitable for both callers?

Also, I wonder if its worth batching up updates. For example, right now
we simply update each call-site
one at a time even if its associated with the same control variable.

Thanks,

-Jason
