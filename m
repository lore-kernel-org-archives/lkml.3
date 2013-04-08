Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935663Ab3DHSdH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 14:33:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6674 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935092Ab3DHSdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 14:33:05 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=bsufmlqqvloA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=8E9qDjP7rE0A:10 a=6xGJIMmgAAAA:8 a=ByhZ0NhaMbrXU4YMd0kA:9 a=QEXdDO2ut3YA:10 a=OBIYwmO2e3MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1365445982.25498.26.camel@gandalf.local.home>
Subject: Re: New Defect(s) reported by Coverity Scan
From: Steven Rostedt <rostedt@goodmis.org>
To: Scan Subscription <scan-subscription@coverity.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 08 Apr 2013 14:33:02 -0400
In-Reply-To: <C0A4ACBB26D853488EA0C68388B702682073D328@BLUPRD0512MB628.namprd05.prod.outlook.com>
References: <C0A4ACBB26D853488EA0C68388B702682073D328@BLUPRD0512MB628.namprd05.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed other's Cc'd.


On Mon, 2013-04-01 at 22:34 +0000, Scan Subscription wrote:

> http://scan5.coverity.com:8080/sourcebrowser.htm?projectId=10063#mergedDefectId=102438
> 
> /kernel/trace/trace.c: 2431 ( var_compare_op)
>    2428    	int ret;
>    2429    
>    2430    	if (iter->ent == NULL) {
> >>> Comparing "iter->tr" to null implies that "iter->tr" might be null.
>    2431    		if (iter->tr) {

The only bug here is the unnecessary check of iter->tr. It will never be
NULL here. I'll fix this when I get around to it, but it is really low
on the priority list.

-- Steve

>    2432    			seq_printf(m, "# tracer: %s\n", iter->trace->name);
>    2433    			seq_puts(m, "#\n");
>    2434    			test_ftrace_alive(m);
>    2435    		}
> >>> CID 102438: Dereference after null check (FORWARD_NULL) Passing 
> >>> "iter" to function "trace_empty(struct trace_iterator *)", which dereferences null "iter->tr".
>    2436    		if (iter->snapshot && trace_empty(iter))
>    2437    			print_snapshot_help(m, iter);
>    2438    		else if (iter->trace && iter->trace->print_header)
>    2439    			iter->trace->print_header(m);
>    2440    		else
>   


