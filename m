Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933044Ab3GKOfv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:35:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20072 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932994Ab3GKOfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:35:47 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=nbHVgzOhg_YA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=QEdfzldPcAgA:10 a=Y5SxjdjpbEwpVba7u9UA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1373553344.17876.13.camel@gandalf.local.home>
Subject: Re: [RFC] [PATCH 1/2 v2] x86: introduce int3-based instruction
 patching
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Jiri Kosina <jkosina@suse.cz>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jason Baron <jbaron@redhat.com>, Borislav Petkov <bpetkov@suse.de>,
        linux-kernel@vger.kernel.org
Date: Thu, 11 Jul 2013 10:35:44 -0400
In-Reply-To: <51DDD3E9.6090601@linux.intel.com>
References: <alpine.LNX.2.00.1307102213140.25858@pobox.suse.cz>
	 <alpine.LNX.2.00.1307102218200.25858@pobox.suse.cz>
	 <alpine.LNX.2.00.1307102328540.25858@pobox.suse.cz>
	 <51DDD3E9.6090601@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-10 at 14:36 -0700, H. Peter Anvin wrote:
> On 07/10/2013 02:31 PM, Jiri Kosina wrote:
> > 
> > If any CPU instruction execution would collide with the patching,
> > it'd be trapped by the int3 breakpoint and redirected to the provided
> > "handler" (which would typically mean just skipping over the patched
> > region, acting as "nop" has been there, in case we are doing nop -> jump
> > and jump -> nop transitions).
> > 
> 
> I'm wondering if it would be easier/more general to just return to the
> instruction.  The "more general" bit would allow this to be used for
> other things, like alternatives, and perhaps eventually dynamic call
> patching.
> 
> Returning to the instruction will, in effect, be a busy-wait for the
> faulted CPU until the patch is complete; more or less what stop_machine
> would do, but only for a CPU which actually strays into the affected region.
> 

Wont work for ftrace, as it patches all functions, it even patches
functions used to do the changes. Thus, it would cause a deadlock if a
breakpoint were to spin till the changes were finished.

-- Steve


