Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009Ab3GKQqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 12:46:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21900 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076Ab3GKQqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 12:46:18 -0400
X-Authority-Analysis: v=2.0 cv=Tr1kdUrh c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=nbHVgzOhg_YA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=QEdfzldPcAgA:10 a=wL381XPGSTaCNMBmk4cA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1373561176.17876.44.camel@gandalf.local.home>
Subject: Re: [RFC] [PATCH 1/2 v2] x86: introduce int3-based instruction
 patching
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Jiri Kosina <jkosina@suse.cz>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jason Baron <jbaron@redhat.com>, Borislav Petkov <bpetkov@suse.de>,
        linux-kernel@vger.kernel.org
Date: Thu, 11 Jul 2013 12:46:16 -0400
In-Reply-To: <51DEDDEF.4060502@linux.intel.com>
References: <alpine.LNX.2.00.1307102213140.25858@pobox.suse.cz>
	 <alpine.LNX.2.00.1307102218200.25858@pobox.suse.cz>
	 <alpine.LNX.2.00.1307102328540.25858@pobox.suse.cz>
	 <51DDD3E9.6090601@linux.intel.com>
	 <alpine.LNX.2.00.1307111204000.29788@pobox.suse.cz>
	 <51DEDDEF.4060502@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-11 at 09:31 -0700, H. Peter Anvin wrote:

> The current code assumes that one of the two code sequences is a NOP,
> and therefore that jumping over the region is legal.  This does not
> allow for transitioning one active code sequence to another.

Correct, and I think we should keep the two changes separate, as the NOP
case is trivial. No need to complicate the trivial and common updates
(jump_labels and ftrace). But for things like kprobes, we could do a bit
more complex code, but it should probably be separate.

Perhaps call this text_poke_nop_bp()?

-- Steve


