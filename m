Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641AbaKEHwg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 02:52:36 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:42877 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210AbaKEHwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 02:52:35 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2 v3] ftracetest: Add a couple of ftrace test cases
References: <20141104152845.521858531@goodmis.org>
	<20141104153028.602754370@goodmis.org>
Date: Wed, 05 Nov 2014 16:52:33 +0900
In-Reply-To: <20141104153028.602754370@goodmis.org> (Steven Rostedt's message
	of "Tue, 04 Nov 2014 10:28:47 -0500")
Message-ID: <87zjc6ulry.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

On Tue, 04 Nov 2014 10:28:47 -0500, Steven Rostedt wrote:
> +count=`cat trace | grep '()' | grep -v schedule | wc -l`
> +
> +if [ $count -ne 0 ]; then
> +    echo "Graph filtering not working after stack tracer disabled?"
> +    exit -1
> +fi
> +
> +count=`cat trace | grep 'schedule()' | wc -l` 
> +if [ $count -eq 0 ]; then
> +    echo "No schedule traces found?"
> +    exit -1

Hmm.. in this case don't we need to call do_reset especially for the
last testcase?  Maybe we could define a simple function like:

fail() { # msg
	do_reset
	echo $1
	exit -1
}

Thanks,
Namhyung


> +fi
> +
> +do_reset
> +
> +exit 0
