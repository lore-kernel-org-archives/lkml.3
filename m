Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045AbaKDRz7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 12:55:59 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:60541 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936AbaKDRzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 12:55:55 -0500
MIME-Version: 1.0
In-Reply-To: <54579C25.5060705@xs4all.nl>
References: <1414598634-13446-1-git-send-email-andrey.krieger.utkin@gmail.com>
	<1414598634-13446-4-git-send-email-andrey.krieger.utkin@gmail.com>
	<54579C25.5060705@xs4all.nl>
Date: Tue, 4 Nov 2014 21:55:55 +0400
Message-ID: <CANZNk82rKAqTuy5hKSOT8UocS_=vbGD47_z5qKfVQkCZrPCNYA@mail.gmail.com>
Subject: Re: [PATCH 4/4] [media] solo6x10: don't turn off/on encoder interrupt
 in processing loop
From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux Media <linux-media@vger.kernel.org>,
        OSUOSL Drivers <devel@driverdev.osuosl.org>,
        ismael.luceno@corp.bluecherry.net,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-11-03 19:15 GMT+04:00 Hans Verkuil <hverkuil@xs4all.nl>:
> Hi Andrey,
>
> On 10/29/2014 05:03 PM, Andrey Utkin wrote:
>> The used approach actually cannot prevent new encoder interrupt to
>> appear, because interrupt handler can execute in different thread, and
>> in current implementation there is still race condition regarding this.
>
> I don't understand what you mean with 'interrupt handler can execute in
> different thread'. Can you elaborate?
>
> Note that I do think that this change makes sense, but I do like to have a
> better explanation.
>

Hi Hans, thanks for response.

I'm not proficient in linux kernel, so it's hard to make sure and
strict statements regarding this.

In the commit justification I mean that solo_ring_thread(), which is
edited, runs in a thread started with kthread_run().
Interrupt hander is executed on random kernel thread (whichever is
currently running, is it correct?). So temporarily disabling
interrupts from video encoders by writing to special register cannot
be used for "processing serialization", for "fixation of state" or
anything useful at all, thus it should be removed from code.

Is it clear now?

Please feel free to push the patch with edited description, even
without resubmission from me.

-- 
Andrey Utkin
