Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323Ab3GKD3d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 23:29:33 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:52040 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574Ab3GKD3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 23:29:32 -0400
Message-ID: <51DE2698.3060307@hitachi.com>
Date: Thu, 11 Jul 2013 12:29:28 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Jason Baron <jbaron@redhat.com>, Borislav Petkov <bpetkov@suse.de>,
        linux-kernel@vger.kernel.org
Subject: Re: Re: [RFC] [PATCH 1/2 v2] x86: introduce int3-based instruction
 patching
References: <alpine.LNX.2.00.1307102213140.25858@pobox.suse.cz> <alpine.LNX.2.00.1307102218200.25858@pobox.suse.cz> <alpine.LNX.2.00.1307102328540.25858@pobox.suse.cz> <51DDD3E9.6090601@linux.intel.com>
In-Reply-To: <51DDD3E9.6090601@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/07/11 6:36), H. Peter Anvin wrote:
> On 07/10/2013 02:31 PM, Jiri Kosina wrote:
>>
>> If any CPU instruction execution would collide with the patching,
>> it'd be trapped by the int3 breakpoint and redirected to the provided
>> "handler" (which would typically mean just skipping over the patched
>> region, acting as "nop" has been there, in case we are doing nop -> jump
>> and jump -> nop transitions).
>>
> 
> I'm wondering if it would be easier/more general to just return to the
> instruction.  The "more general" bit would allow this to be used for
> other things, like alternatives, and perhaps eventually dynamic call
> patching.
>
> Returning to the instruction will, in effect, be a busy-wait for the
> faulted CPU until the patch is complete; more or less what stop_machine
> would do, but only for a CPU which actually strays into the affected region.

Sounds a good idea :)
It may minimize the interface and the implementation will be
self-contained.

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


