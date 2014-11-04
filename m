Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540AbaKDCaf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 21:30:35 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:36084 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751322AbaKDCaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 21:30:30 -0500
Message-ID: <54583A43.2000303@hurleysoftware.com>
Date: Mon, 03 Nov 2014 21:30:27 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ftrace: Document ftrace command line limitations
References: <1415065525-8267-1-git-send-email-peter@hurleysoftware.com> <20141103211431.0d8a80b8@gandalf.local.home>
In-Reply-To: <20141103211431.0d8a80b8@gandalf.local.home>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2014 09:14 PM, Steven Rostedt wrote:
> On Mon,  3 Nov 2014 20:45:25 -0500
> Peter Hurley <peter@hurleysoftware.com> wrote:
> 
>> When using the function or function_graph tracers from the command
>> line, certain command line options have limitations.
>>
>> Document that only kernel built-in functions can be filtered via
>> ftrace_filter= or ftrace_graph_filter=. Also document that tracer-
>> specific options cannot be set on the command line via trace_options.
> 
> It's not just a command line limitation. The command line behaves
> exactly like set_ftrace_filter does. That is, it only affects the
> functions that are loaded when the filter is modified. It never updates
> functions that will be loaded when modules are.
> 
> Adding this documentation makes it seem that set_ftrace_filter has the
> ability to update functions that were not loaded yet. This is not true.
> The command line filtering behaves exactly like set_ftrace_filter does.
> It only enables the functions that are loaded at the time the function
> is set. Which was at boot up, and it just happens to be only built in
> functions at that time.

Ah, ok. I'll clarify those two lines and add to the documentation in
Documentation/trace/ftrace.txt

