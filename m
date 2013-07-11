Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756435Ab3GKXwX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 19:52:23 -0400
Received: from intranet.asianux.com ([58.214.24.6]:44486 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755994Ab3GKXwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 19:52:22 -0400
X-Spam-Score: -100.8
Message-ID: <51DF44FA.9060000@asianux.com>
Date: Fri, 12 Jul 2013 07:51:22 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel: trace: remove __init from race_selftest_startup_function()
 and trace_selftest_startup_function_graph()
References: <51DDFCF8.2090808@asianux.com> <1373561279.17876.45.camel@gandalf.local.home>
In-Reply-To: <1373561279.17876.45.camel@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2013 12:47 AM, Steven Rostedt wrote:
> On Thu, 2013-07-11 at 08:31 +0800, Chen Gang wrote:
>> Like other trace_selftest_startup_*, trace_selftest_startup_function()
>> and trace_selftest_startup_function_graph() need in normal section, or
>> may cause section mismatch.
>>
>> The related warnings:
>>
>>     LD      kernel/trace/built-in.o
>>   WARNING: kernel/trace/built-in.o(.data+0x154c): Section mismatch in reference from the variable function_trace to the function .init.text:trace_selftest_startup_function()
>>   The variable function_trace references
>>   the function __init trace_selftest_startup_function()
>>   If the reference is valid then annotate the
>>   variable with __init* or __refdata (see linux/init.h) or name the variable:
>>   *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console
>>
> 
> No the fix is to add ref_data to the user. The selftest are only called
> at boot up. No need to waste memory keeping them around.
> 

Ok, thanks.

Hmm, can all trace_selftest_startup_* (*selftest* in trace_selftest.c)
use '__init', so not waste memory keeping them around ?


Thanks.
-- 
Chen Gang
