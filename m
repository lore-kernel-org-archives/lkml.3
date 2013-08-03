Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223Ab3HCBxp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 21:53:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9914 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab3HCBxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 21:53:44 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=a1XxTi1lYWkA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=QzE7ADRQHhwA:10 a=32-l6iTiDB2HSiWk1bwA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1375494823.22073.37.camel@gandalf.local.home>
Subject: Re: [PATCH 2/3] tracing: Fix reset of time stamps during
 trace_clock changes
From: Steven Rostedt <rostedt@goodmis.org>
To: Alexander Z Lam <azl@google.com>
Cc: linux-kernel@vger.kernel.org, David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Alexander Z Lam <lambchop468@gmail.com>
Date: Fri, 02 Aug 2013 21:53:43 -0400
In-Reply-To: <1375493777-17261-2-git-send-email-azl@google.com>
References: <1375493777-17261-1-git-send-email-azl@google.com>
	 <1375493777-17261-2-git-send-email-azl@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-08-02 at 18:36 -0700, Alexander Z Lam wrote:
> Fixed two issues with changing the timestamp clock with trace_clock:
> 
>  - The global buffer was reset on instance clock changes. Change this to pass
>    the correct per-instance buffer
>  - ftrace_now() is used to set buf->time_start in tracing_reset_online_cpus().
>    This was incorrect because ftrace_now() used the global buffer's clock to
>    return the current time. Change this to use buffer_ftrace_now() which
>    returns the current time for the correct per-instance buffer.

The first two patches look to go into 3.11 and 3.10 stable. The removal
below is not urgent, but I can keep it in this patch.

> 
> Also removed tracing_reset_current() because it is not used anywhere
> 

The third patch can wait to 3.12. I'll review it later.

Thanks,

-- Steve


