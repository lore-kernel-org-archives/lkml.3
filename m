Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880AbaKCISm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 03:18:42 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:59905 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbaKCISl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 03:18:41 -0500
Message-ID: <54573A5A.30409@hitachi.com>
Date: Mon, 03 Nov 2014 17:18:34 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ftracetest: Take the first debugfs mount found
References: <20141031180655.1deff238@gandalf.local.home>
In-Reply-To: <20141031180655.1deff238@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/11/01 7:06), Steven Rostedt wrote:
> 
> Running ftracetests on a box that mounted debugfs in two locations
> made the ftracetests fail. This is because the tests uses a grep
> of debugfs from the /proc/mounts file to find the debugfs mount
> point, and then appends "/tracing" to that string to get the tracing
> directory.
> 
> If the debugfs directory is mounted twice, then that grep will return
> two answers and appending "/tracing" to a string with two lines will
> not work.
> 
> Use "head -1" to only take the first mount point found.

Indeed :)

> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thank you!


> ---
>  tools/testing/selftests/ftrace/ftracetest | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/ftrace/ftracetest b/tools/testing/selftests/ftrace/ftracetest
> index a8f81c782856..515247601df4 100755
> --- a/tools/testing/selftests/ftrace/ftracetest
> +++ b/tools/testing/selftests/ftrace/ftracetest
> @@ -82,7 +82,7 @@ parse_opts() { # opts
>  }
>  
>  # Parameters
> -DEBUGFS_DIR=`grep debugfs /proc/mounts | cut -f2 -d' '`
> +DEBUGFS_DIR=`grep debugfs /proc/mounts | cut -f2 -d' ' | head -1`
>  TRACING_DIR=$DEBUGFS_DIR/tracing
>  TOP_DIR=`absdir $0`
>  TEST_DIR=$TOP_DIR/test.d
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


