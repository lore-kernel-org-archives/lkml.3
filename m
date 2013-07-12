Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932413Ab3GLBAq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 21:00:46 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:41613 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932209Ab3GLBAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 21:00:45 -0400
Message-ID: <51DF553A.6010108@hitachi.com>
Date: Fri, 12 Jul 2013 10:00:42 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Jiri Kosina <jkosina@suse.cz>,
        Jason Baron <jbaron@redhat.com>, Borislav Petkov <bpetkov@suse.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH 1/2 v2] x86: introduce int3-based instruction patching
References: <alpine.LNX.2.00.1307102213140.25858@pobox.suse.cz>  <alpine.LNX.2.00.1307102218200.25858@pobox.suse.cz>  <alpine.LNX.2.00.1307102328540.25858@pobox.suse.cz>  <51DDD3E9.6090601@linux.intel.com>  <alpine.LNX.2.00.1307111204000.29788@pobox.suse.cz>  <51DEDDEF.4060502@linux.intel.com> <1373561176.17876.44.camel@gandalf.local.home>
In-Reply-To: <1373561176.17876.44.camel@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/07/12 1:46), Steven Rostedt wrote:
> On Thu, 2013-07-11 at 09:31 -0700, H. Peter Anvin wrote:
> 
>> The current code assumes that one of the two code sequences is a NOP,
>> and therefore that jumping over the region is legal.  This does not
>> allow for transitioning one active code sequence to another.
> 
> Correct, and I think we should keep the two changes separate, as the NOP
> case is trivial. No need to complicate the trivial and common updates
> (jump_labels and ftrace). But for things like kprobes, we could do a bit
> more complex code, but it should probably be separate.

Don't mind, kprobes optimization code prepares the destination code
buffer to jump in before code patching. Thus, we just need to give the
buffer address to text_poke_bp().

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


