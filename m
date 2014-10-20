Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123AbaJTBbw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 21:31:52 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:39899 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbaJTBbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 21:31:51 -0400
Message-ID: <544465FF.1040904@hitachi.com>
Date: Mon, 20 Oct 2014 10:31:43 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ingo Molnar <mingo@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>,
        Jiri Kosina <jkosina@suse.cz>, Jiri Slaby <jslaby@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] s390 vs. kprobes on ftrace
References: <1413387978-984-1-git-send-email-heiko.carstens@de.ibm.com> <543F5C84.7090005@hitachi.com> <20141017082112.GB18203@osiris>
In-Reply-To: <20141017082112.GB18203@osiris>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/10/17 17:21), Heiko Carstens wrote:
> On Thu, Oct 16, 2014 at 02:49:56PM +0900, Masami Hiramatsu wrote:
>> I'm not sure about s390 nor have the machine, so it is very helpful if you
>> give us a command line level test and show us the result with this patch :)
>> Fortunately, we already have ftracetest under tools/tesitng/selftest/ftrace/.
>> You can add the testcase for checking co-existence of kprobes and ftrace on
>> an entry of a function.
> 
> FWIW, I was also surprised to see that the order of the ftrace testcases is
> not sorted. Maybe you might consider the patch below as well:

Ah, right. I've misunderstood that was already sorted.

Could you resend it as a separated patch, with my ack?

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thank you,
> 
>>From a659098f63f188e603316e4c4ccb435bf360987a Mon Sep 17 00:00:00 2001
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> Date: Fri, 17 Oct 2014 10:08:35 +0200
> Subject: [PATCH] ftracetest: sort testcases
> 
> Make sure the order of the executed testcases is always the same.
> 
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> ---
>  tools/testing/selftests/ftrace/ftracetest | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/ftrace/ftracetest b/tools/testing/selftests/ftrace/ftracetest
> index a8f81c782856..2007a2cde56f 100755
> --- a/tools/testing/selftests/ftrace/ftracetest
> +++ b/tools/testing/selftests/ftrace/ftracetest
> @@ -37,7 +37,7 @@ abspath() {
>  }
>  
>  find_testcases() { #directory
> -  echo `find $1 -name \*.tc`
> +  echo `find $1 -name \*.tc | sort`
>  }
>  
>  parse_opts() { # opts
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


