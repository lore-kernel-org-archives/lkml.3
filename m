Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946045Ab3FUUjd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 16:39:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16208 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945951Ab3FUUjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 16:39:32 -0400
X-Authority-Analysis: v=2.0 cv=Du3UCRD+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=5wS_mGLe7pQA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=UM8sEat5ZzYA:10 a=WyBO8MM3-ynC3k5w-WwA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1371847171.18733.128.camel@gandalf.local.home>
Subject: Re: [PATCH 04/11] tracing: fix disabling of soft disable
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Tom Zanussi <tom.zanussi@linux.intel.com>, linux-kernel@vger.kernel.org
Date: Fri, 21 Jun 2013 16:39:31 -0400
In-Reply-To: <51C43537.8070300@hitachi.com>
References: <cover.1371751701.git.tom.zanussi@linux.intel.com>
	 <f369f565dc440f40f027de0387c99dda4d36154e.1371751701.git.tom.zanussi@linux.intel.com>
	 <51C43537.8070300@hitachi.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-21 at 20:12 +0900, Masami Hiramatsu wrote:
> (2013/06/21 3:31), Tom Zanussi wrote:
> > The comment on the soft disable 'disable' case of
> > __ftrace_event_enable_disable() states that the soft disable bit
> > should be cleared in that case, but currently only the soft mode bit
> > is actually cleared.
> > 
> > This essentially leaves the standard non-soft-enable enable/disable
> > paths as the only way to clear the soft disable flag, but the soft
> > disable bit should also be cleared when removing a trigger with '!'.
> 
> Indeed, the soft-disabled flag may remain after the event itself
> disabled. However that soft-disabled flag will be cleared when
> the event is re-enabled. it seems no bad side-effect.
> 
> Thus I doubt this patch is separately required. I guess this is
> required for adding new trigger flag, isn't it? :)

Tom, I'm guessing Masami is correct here. It's needed for the trigger
work to work, correct?

Either way, I probably could add it as a clean up patch regardless. I'll
just have to test the hell out of it some more, as the accounting for
soft-disable vs real disable was a PITA.

-- Steve

