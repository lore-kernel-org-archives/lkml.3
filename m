Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232Ab3GJVgo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 17:36:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:12743 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754574Ab3GJVgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 17:36:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1038,1363158000"; 
   d="scan'208";a="368056725"
Message-ID: <51DDD3E9.6090601@linux.intel.com>
Date: Wed, 10 Jul 2013 14:36:41 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@redhat.com>,
        Borislav Petkov <bpetkov@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH 1/2 v2] x86: introduce int3-based instruction patching
References: <alpine.LNX.2.00.1307102213140.25858@pobox.suse.cz> <alpine.LNX.2.00.1307102218200.25858@pobox.suse.cz> <alpine.LNX.2.00.1307102328540.25858@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1307102328540.25858@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2013 02:31 PM, Jiri Kosina wrote:
> 
> If any CPU instruction execution would collide with the patching,
> it'd be trapped by the int3 breakpoint and redirected to the provided
> "handler" (which would typically mean just skipping over the patched
> region, acting as "nop" has been there, in case we are doing nop -> jump
> and jump -> nop transitions).
> 

I'm wondering if it would be easier/more general to just return to the
instruction.  The "more general" bit would allow this to be used for
other things, like alternatives, and perhaps eventually dynamic call
patching.

Returning to the instruction will, in effect, be a busy-wait for the
faulted CPU until the patch is complete; more or less what stop_machine
would do, but only for a CPU which actually strays into the affected region.

	-hpa


