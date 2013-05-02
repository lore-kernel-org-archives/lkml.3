Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761654Ab3EBSpa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 14:45:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15446 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761358Ab3EBSp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 14:45:27 -0400
X-Authority-Analysis: v=2.0 cv=UY7TuduN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=qVwF2erAZtkA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=Zh7nNSpF_ucA:10 a=pGLkceISAAAA:8 a=pu8zJxrd4HHR-FtzszsA:9 a=QEXdDO2ut3YA:10 a=lme0yl12AcQA:10 a=jeBq3FmKZ4MA:10 a=MSl-tDqOz04A:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1367520325.7373.2.camel@gandalf.local.home>
Subject: Re: [PATCH v2] init: Do not warn on non-zero initcall return
From: Steven Rostedt <rostedt@goodmis.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Thu, 02 May 2013 14:45:25 -0400
In-Reply-To: <CAMuHMdWX0kvVP09Ttrb8Q+HTR3HDndEDVnS2aEHnRS4SHcc=Fw@mail.gmail.com>
References: <1367429751.30667.99.camel@gandalf.local.home>
	 <CAMuHMdXguZknoR=A6Cpqoz4VYX6wuPtUWfV4yGhkBiGMQOdaYg@mail.gmail.com>
	 <1367507873.30667.136.camel@gandalf.local.home>
	 <CAMuHMdWX0kvVP09Ttrb8Q+HTR3HDndEDVnS2aEHnRS4SHcc=Fw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-05-02 at 20:33 +0200, Geert Uytterhoeven wrote:
> On Thu, May 2, 2013 at 5:17 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > On Thu, 2013-05-02 at 09:43 +0200, Geert Uytterhoeven wrote:
> >> On Wed, May 1, 2013 at 7:35 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> >> > --- a/init/main.c
> >> > +++ b/init/main.c
> >> > @@ -686,11 +686,8 @@ int __init_or_module do_one_initcall(initcall_t fn)
> >> >
> >> >         msgbuf[0] = 0;
> >> >
> >> > -       if (ret && ret != -ENODEV && initcall_debug)
> >> > -               sprintf(msgbuf, "error code %d ", ret);
> >> > -
> >> >         if (preempt_count() != count) {
> >> > -               strlcat(msgbuf, "preemption imbalance ", sizeof(msgbuf));
> >> > +               sprintf(msgbuf, "preemption imbalance ");
> >>
> >> snprintf(), please?
> >
> > Why? The msgbuf is 64 bytes, this is the first occurrence and
> > "preemption imbalance " is much less than 64 bytes.
> 
> The day after tomorrow, someone will modify the code, and cause a buffer
> overflow.
> 
> I'm actually surprised (v)sprintf() is not tagged __deprecated.
> 

I actually did think for a second in adding that. Not sure why I didn't.
Probably just because the original code didn't do that.

But I'll let that clean up come another day by someone else.

-- Steve


