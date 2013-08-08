Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933718Ab3HHCPF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 22:15:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13908 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932506Ab3HHCPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 22:15:03 -0400
X-Authority-Analysis: v=2.0 cv=e9yEuNV/ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=NBs83Pxiv7wA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=iqRnftYWOgEA:10 a=kmG1LWDwp8PEcbahm5QA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1375928102.6848.35.camel@gandalf.local.home>
Subject: Re: [PATCH v4 00/11] tracing: trace event triggers
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Tom Zanussi <tom.zanussi@linux.intel.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>
Date: Wed, 07 Aug 2013 22:15:02 -0400
In-Reply-To: <5202FC4B.7040106@hitachi.com>
References: <cover.1375111640.git.tom.zanussi@linux.intel.com>
	 <5202FC4B.7040106@hitachi.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-08 at 11:02 +0900, Masami Hiramatsu wrote:

> # mkdir instances/hoge
> # echo 'enable_event:mce:mce_record' > instances/hoge/events/syscalls/sys_enter_symlink/trigger
> # cat instances/hoge/events/syscalls/sys_enter_symlink/enable
> 0*
> # cat instances/hoge/events/mce/mce_record/enable
> 0
> # cat events/mce/mce_record/enable
> 0*
> # ln -sf /dev/null /tmp
> # cat instances/hoge/events/mce/mce_record/enable
> 0
> # cat events/mce/mce_record/enable
> 1*
> 
> This looks odd, I expected enabling mce/mce_record under instances/hoge.
> 
> And, there is a bug of ftrace itself (not introduced by this series) I've found.
> After the above operation, we can delete the instance "hoge", but the soft-mode
> flag of mce_record is not cleared, even though there is no trigger referring
> the event.
> 
> # rmdir instances/hoge
> # cat events/mce/mce_record/enable
> 1*

Ouch. I'll have to look into this. Thanks!


> And also, could you rebase your patches on trace/for-next branch?
> Since that branch includes most of the latest fixes, it is better to
> review with it.

Yeah, it would be good to rebase against that. I may finally have time
to look into these patches.

-- Steve



