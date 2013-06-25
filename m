Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976Ab3FYWB6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 18:01:58 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:53240 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718Ab3FYWB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 18:01:56 -0400
MIME-Version: 1.0
In-Reply-To: <20130625215247.GC1726@moon>
References: <0e00e9073855c02a382d49ba1ede9c4fda3451b7.1372189875.git.luto@amacapital.net>
 <20130625201602.GB1726@moon> <20130625201705.GA15966@redhat.com>
 <CALCETrVxm2wHvLgexG6fZO+h1rNHC_qDCv6B+4XuANHgSQU4iw@mail.gmail.com> <20130625215247.GC1726@moon>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 25 Jun 2013 15:01:35 -0700
Message-ID: <CALCETrV2WZ3m82D4THfxvmASW8AOf1SN7Pu14vE0jMORupO5xw@mail.gmail.com>
Subject: Re: [PATCH] proc: Expose /proc/<pid>/task/<tid>/children unconditionally
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 2:52 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> On Tue, Jun 25, 2013 at 02:36:31PM -0700, Andy Lutomirski wrote:
>> On Tue, Jun 25, 2013 at 1:17 PM, Oleg Nesterov <oleg@redhat.com> wrote:
>> > On 06/26, Cyrill Gorcunov wrote:
>> >>
>> >> On Tue, Jun 25, 2013 at 12:51:45PM -0700, Andy Lutomirski wrote:
>> >> > This is currently only available if CONFIG_CHECKPOINT_RESTORE, which
>> >> > is hidden under CONFIG_EXPERT.  It's generally useful functionality,
>> >> > though, so expose it unconditionally.
>> >> >
>> >> > Cc: Cyrill Gorcunov <gorcunov@openvz.org>
>> >> > Signed-off-by: Andy Lutomirski <luto@amacapital.net>
>> >> Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
>> >
>> > I didn't see the patch but I guess it is trivial and I agree with intent ;)
>>
>> The patch works, but "children" is only listed under task/<tid>, not
>> under /proc/<pid>.  Is that intentional?  Fixing it would be a
>> one-liner.
>
> Yeah, it's intentional. Here some explanations from Oleg (check out
> the whole thread, it's not that big https://lkml.org/lkml/2011/12/9/220)
> in short this might require some more code, but i'll re-check tomorrow.

This is a little strange.  It looks like ppid (in status) shows the
tgid, but the actual real_parent can refer to a thread (as opposed to
a thread group leader), and task/tid/children respects that.  So the
tree that you get by following task/tid/ children won't be quite the
same as the tree you get by following ppid.

I wonder if the ptid should be added to status.  Is there anything
(other than task/tid/children) that cased which thread is the parent
of a given task?

--Andy
