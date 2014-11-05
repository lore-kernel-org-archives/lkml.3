Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbaKEIlW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 03:41:22 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:58558 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbaKEIlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 03:41:21 -0500
Message-ID: <5459E2AB.8020009@hitachi.com>
Date: Wed, 05 Nov 2014 17:41:15 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2 v3] ftracetest: Add a couple of ftrace test cases
References: <20141104152845.521858531@goodmis.org> <20141104153028.602754370@goodmis.org> <87zjc6ulry.fsf@sejong.aot.lge.com>
In-Reply-To: <87zjc6ulry.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/11/05 16:52), Namhyung Kim wrote:
> Hi Steve,
> 
> On Tue, 04 Nov 2014 10:28:47 -0500, Steven Rostedt wrote:
>> +count=`cat trace | grep '()' | grep -v schedule | wc -l`
>> +
>> +if [ $count -ne 0 ]; then
>> +    echo "Graph filtering not working after stack tracer disabled?"
>> +    exit -1
>> +fi
>> +
>> +count=`cat trace | grep 'schedule()' | wc -l` 
>> +if [ $count -eq 0 ]; then
>> +    echo "No schedule traces found?"
>> +    exit -1
> 
> Hmm.. in this case don't we need to call do_reset especially for the
> last testcase?  Maybe we could define a simple function like:
> 
> fail() { # msg
> 	do_reset
> 	echo $1
> 	exit -1
> }

If you want to call do_reset always on exit, you can also use "trap do_reset 0" too.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


