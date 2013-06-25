Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952Ab3FYNe7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 09:34:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5529 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177Ab3FYNe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 09:34:58 -0400
X-Authority-Analysis: v=2.0 cv=Du3UCRD+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=DEy4BJnMZIkA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=o9MrT1-Ngs4A:10 a=lBzkXKANcu0tYIn0ZgkA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1372167296.18733.195.camel@gandalf.local.home>
Subject: Re: [PATCH 1/2] tracing/kprobes: move free_trace_probe into
 unregister_trace_probe
From: Steven Rostedt <rostedt@goodmis.org>
To: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Date: Tue, 25 Jun 2013 09:34:56 -0400
In-Reply-To: <51C97305.3090406@huawei.com>
References: <51C951BF.1090509@huawei.com> <51C96C89.6080207@hitachi.com>
	 <51C97305.3090406@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-25 at 18:37 +0800, zhangwei(Jovi) wrote:
> On 2013/6/25 18:10, Masami Hiramatsu wrote:
> > (2013/06/25 17:15), zhangwei(Jovi) wrote:
> >> There have no good reason to call free_trace_probe
> >> every time when unregister_trace_probe return 0.
> >>
> >> Move free_trace_probe into unregister_trace_probe,
> >> make code simpler.
> > 
> > Sorry, nack. For the symmetrical coding reason, I don't like
> > involving "free" and "alloc" into "unregister"/"register"
> > functions. I think those should be just another actions.
> > 
> > Thank you,
> 
> That's fine, I just saw there have a little inconsistent between
> trace_kprobe.c and trace_uprobe.c.
> 

Is there a place that trace_kprobe.c frees the tp structure in
unregister?

-- Steve


