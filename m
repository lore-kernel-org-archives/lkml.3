Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790Ab3HDRNH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 13:13:07 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:44712 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649Ab3HDRNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 13:13:05 -0400
MIME-Version: 1.0
In-Reply-To: <20130804143527.GA18906@redhat.com>
References: <20130801190455.GA3194@redhat.com>
	<20130801190511.GA3213@redhat.com>
	<CAGXu5jK+8xKW3Hbzg7g7o2c3G4aWrT4Y4UBCBmaM74cUPMYnQA@mail.gmail.com>
	<20130804143527.GA18906@redhat.com>
Date: Sun, 4 Aug 2013 10:13:03 -0700
X-Google-Sender-Auth: Cq-Ya7b7llcuAq51ZKfWzqa9IBk
Message-ID: <CAGXu5jKRgbZ7safrJjmSQc3dHsMEqnE7KGptQ0kPtesbV2kz3g@mail.gmail.com>
Subject: Re: [PATCH 1/3] exec: introduce exec_binprm() for "depth == 0" code
From: Kees Cook <keescook@chromium.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Zach Levis <zml@linux.vnet.ibm.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Evgeniy Polyakov <zbr@ioremap.net>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 4, 2013 at 7:35 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 08/03, Kees Cook wrote:
>>
>> On Thu, Aug 1, 2013 at 12:05 PM, Oleg Nesterov <oleg@redhat.com> wrote:
>> > +static int exec_binprm(struct linux_binprm *bprm)
>> > +{
>> > +       pid_t old_pid, old_vpid;
>> > +       int ret;
>> > +
>> > +       /* Need to fetch pid before load_binary changes it */
>> > +       old_pid = current->pid;
>> > +       rcu_read_lock();
>> > +       old_vpid = task_pid_nr_ns(current, task_active_pid_ns(current->parent));
>> > +       rcu_read_unlock();
>> > +
>> > +       ret = search_binary_handler(bprm);
>> > +       if (ret >= 0) {
>> > +               trace_sched_process_exec(current, old_pid, bprm);
>> > +               ptrace_event(PTRACE_EVENT_EXEC, old_vpid);
>> > +               current->did_exec = 1;
>> > +       }
>>
>> Cleanup looks good. One idea here, though: this could be made more
>> pretty by doing:
>>
>> if (ret < 0)
>>     return ret;
>>
>> to avoid the indentation for the "expected" code path.
>
> Well, I do not reallt mind. But this "if" block is simple and small,
> we do we need another "return" ?
>
> To me the code looks more readable this way, but I can redo/resend.

Cool, that's fine how it is. It was just a style suggestion. :)

Acked-by: Kees Cook <keescook@chromium.org>

Thanks!

-Kees

-- 
Kees Cook
Chrome OS Security
