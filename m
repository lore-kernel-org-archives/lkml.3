Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711Ab3G3B76 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 21:59:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14942 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062Ab3G3B74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 21:59:56 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=yamZY-bhXjEA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=6PEQZdHCN9wA:10 a=KfFBZPgXhdaFFKRaZrEA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1375149595.6580.59.camel@gandalf.local.home>
Subject: Re: [PATCH v2 6/6] tracing: Change remove_event_file_dir() to clear
 "d_subdirs"->i_private
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Alexander Z Lam <azl@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Sharp <dhsharp@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Date: Mon, 29 Jul 2013 21:59:55 -0400
In-Reply-To: <51F716AF.1040206@hitachi.com>
References: <20130726172551.GA3632@redhat.com>
	 <51F6392C.8000806@hitachi.com> <20130729142158.GA9338@redhat.com>
	 <51F716AF.1040206@hitachi.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-30 at 10:28 +0900, Masami Hiramatsu wrote:
> (2013/07/29 23:21), Oleg Nesterov wrote:
> > On 07/29, Masami Hiramatsu wrote:
> >>
> >> (2013/07/27 2:25), Oleg Nesterov wrote:
> >>> Change remove_event_file_dir() to clear ->i_private for every
> >>> file we are going to remove.
> >>
> >> Oleg, I think this should be done first.
> >>
> >> AFAICS, your former patches depend strongly on this change.
> >> Without this, they don't work as you expected, and it may
> >> prevent git-bisect.
> > 
> > Why?
> > 
> > v2 specially does this in the last change for bisecting/etc.
> > 
> > 1-4 change f_op->read/write to check i_private != NULL but until
> > this final patch i_private == NULL is not possible.
> 
> Ah, OK. So 1-4 changes still remain refcount code, then
> it is safe, just i_private != NULL are added. I misread.

I just ran them all individually applied through my ftrace stress tests.
All passed, thus they are as bisectible as I would like them to be.

-- Steve


