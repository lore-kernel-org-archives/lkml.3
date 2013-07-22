Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757377Ab3GVPGZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 11:06:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24611 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757084Ab3GVPGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 11:06:02 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=q-5KwEyaYmUA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=PzHPlaRu3OEA:10 a=Qbv1gVhtt8cmuTh9RPsA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1374505560.3356.94.camel@gandalf.local.home>
Subject: Re: [PATCH 1/7] tracing: Introduce trace_create_cpu_file() and
 tracing_get_cpu()
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Alexander Z Lam <azl@google.com>, David Sharp <dhsharp@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Date: Mon, 22 Jul 2013 11:06:00 -0400
In-Reply-To: <1374504957.3356.91.camel@gandalf.local.home>
References: <20130722134342.GA18355@redhat.com>
	 <1374504957.3356.91.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-22 at 10:55 -0400, Steven Rostedt wrote:

> The problem is that some files only references the tr for a certain CPU.
> Another data structure was created when the file was opened called
> trace_cpu (tc), which maps a CPU and a trace_array. As there is no

Correction, the trace_cpu is created when the file is created, not when
it was opened.

> global list of trace_cpus, this is susceptible to the above race
> condition. Accessing tc->tr can happen after tc has been freed.


