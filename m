Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799Ab3CHLiz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 06:38:55 -0500
Received: from mail-vb0-f42.google.com ([209.85.212.42]:56569 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522Ab3CHLix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 06:38:53 -0500
MIME-Version: 1.0
In-Reply-To: <87sj47t97s.fsf@xmission.com>
References: <20130307132819.GA31162@localhost>
	<87sj47t97s.fsf@xmission.com>
Date: Fri, 8 Mar 2013 17:38:52 +0600
Message-ID: <CADZ9YHhbvu8WYUMdDtpvkrZmLCD87fQ0Y0AcXdBaQB53=uPYYw@mail.gmail.com>
Subject: Re: [nsproxy] BUG: unable to handle kernel NULL pointer dereference
 at 0000000000000024
From: Rakib Mullick <rakib.mullick@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/7/13, Eric W. Biederman <ebiederm@xmission.com> wrote:
> Fengguang Wu <fengguang.wu@intel.com> writes:
>
>> Greetings,
>>
>> I got the below oops and the first bad commit is
>
> Doh!  On a second look that change is totally wrong.  Of course we need
> to up the ref-count every time we create a new process.  Especially if
> we don't do anything with namespaces.
>
> I was looking at it from the wrong angle last night.  I should have
> known better.
>
> Patch dropped.
>

Sad to know :( . From the debug messages, it's kmemcheck report. I
can't related the problem specified with the patch I've proposed.

It seems at task exit path, at switch_task_namespaces() - after my
patch atomic_dec_and_test(&ns->count) becomes true (-1), thus
free_nsproxy() gets called. But, free_nsproxy() shouldn't get called
here.

Am I right? Or there's something else?

Thanks,
Rakib
