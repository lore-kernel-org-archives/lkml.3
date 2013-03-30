Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756926Ab3C3QRx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 12:17:53 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:63899 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756779Ab3C3QRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 12:17:51 -0400
MIME-Version: 1.0
In-Reply-To: <20130330143600.GA8650@redhat.com>
References: <1364612447-6810-1-git-send-email-tj@kernel.org>
	<1364612447-6810-2-git-send-email-tj@kernel.org>
	<20130330143600.GA8650@redhat.com>
Date: Sat, 30 Mar 2013 09:17:51 -0700
X-Google-Sender-Auth: ZQ7dryjzAxSK-pLRMKcIHhWECCc
Message-ID: <CAOS58YNOGggVmTazN86HHO7p7uNn78O19AOp0_9NmhjaZheXCg@mail.gmail.com>
Subject: Re: [PATCH 1/3] kthread: implement probe_kthread_data()
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, david@fromorbit.com,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.

On Sat, Mar 30, 2013 at 7:36 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> > +void *probe_kthread_data(struct task_struct *task)
> > +{
> > +     struct kthread *kthread = to_kthread(task);
> > +     void *data = NULL;
> > +
> > +     probe_kernel_read(&data, &kthread->data, sizeof(data));
> > +     return data;
> > +}
>
> OK, but we can simply check ->vfork_done != NULL ?

Hmm... what if ->vfork_done is pointing to some weird place?

Thanks.

--
tejun
