Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932730Ab3GVRez (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 13:34:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14845 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932629Ab3GVRer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 13:34:47 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=q-5KwEyaYmUA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=PzHPlaRu3OEA:10 a=KXFy6s09a3G8RWJ-NaYA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1374514484.3356.106.camel@gandalf.local.home>
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
Date: Mon, 22 Jul 2013 13:34:44 -0400
In-Reply-To: <20130722171435.GA27080@redhat.com>
References: <20130722134342.GA18355@redhat.com>
	 <1374504957.3356.91.camel@gandalf.local.home>
	 <20130722171435.GA27080@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-22 at 19:14 +0200, Oleg Nesterov wrote:
> On 07/22, Steven Rostedt wrote:
> >
> > Now here's why I'm emailing you.  What Oleg is doing here is instead of
> > creating this extra trace_cpu structure, he's using the inode->i_cdev to
> > store the CPU information (he's wrapped this with helper functions so we
> > can use any inode structure). He sets inode->i_cdev to CPU+1 or to
> > RING_BUFFER_ALL_CPUS (when all CPU info is needed).
> 
> This doesn't really matter, but RING_BUFFER_ALL_CPUS is encoded as NULL
> so we do not need to change init_tracer_debugfs(). inode_init_always()
> clears ->i_cdev.

Yeah, I noticed that after sending the email. We could just set
i_private to NULL and get the same effect.

-- Steve


