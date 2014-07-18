Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbaGRHKh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 03:10:37 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:41271 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754561AbaGRHKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 03:10:36 -0400
Message-ID: <53C8C865.6020001@hitachi.com>
Date: Fri, 18 Jul 2014 16:10:29 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Re: [PATCH ftrace/core v3 3/3] kprobes: Set IPMODIFY flag
 only if the probe can change regs->ip
References: <20140715060015.12195.74457.stgit@kbuild-fedora.novalocal> <20140715060035.12195.47782.stgit@kbuild-fedora.novalocal> <878unrkzag.fsf@sejong.aot.lge.com>
In-Reply-To: <878unrkzag.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/07/18 14:32), Namhyung Kim wrote:
> Hi Masami,
> 
> On Tue, 15 Jul 2014 06:00:35 +0000, Masami Hiramatsu wrote:
>> +static int __ftrace_add_filter_ip(struct ftrace_ops *ops, unsigned long ip,
>> +				  int *ref)
>> +{
>> +	int ret;
>> +
>> +	/* Try to set given ip to filter */
>> +	ret = ftrace_set_filter_ip(ops, ip, 0, 0);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	(*ref)++;
>> +	if (*ref == 1) {
>> +		ret = register_ftrace_function(ops);
>> +		if (ret < 0) {
>> +			/* Rollback refcounter and filter */
>> +			(*ref)--;
>> +			ftrace_set_filter_ip(ops, ip, 1, 0);
>> +		}
>> +	}
>> +
>> +	return ret;
>> +}
> 
> This function also can be changed in a similar way:
> 
> 	if (*ref == 0) {
> 		ret = register_ftrace_function(ops);
> 		if (ret < 0) {
> 			/* Rollback filter if failed */
> 			ftrace_set_filter_ip(ops, ip, 1, 0);
> 			return ret;
> 		}
> 	}
> 
> 	(*ref)++;
> 
> 	return 0;

Indeed :)

Thanks!


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


