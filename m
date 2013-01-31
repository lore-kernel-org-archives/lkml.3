Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757047Ab3AaWcN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 17:32:13 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:48329 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755044Ab3AaWcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 17:32:11 -0500
MIME-Version: 1.0
In-Reply-To: <1359671257.7527.4.camel@dabdike>
References: <1356064540-17414-1-git-send-email-dbasehore@chromium.org>
	<50D5C473.2030902@mvista.com>
	<CAGAzgso4cJHM+CNV0nCu6zUmq=xUstbsguynUp+hyx581LcHJg@mail.gmail.com>
	<1359671257.7527.4.camel@dabdike>
Date: Thu, 31 Jan 2013 14:32:10 -0800
X-Google-Sender-Auth: doXEtTmbzRT3vLTHrRVxDPtBgoc
Message-ID: <CAGAzgspDkPUAHHES434t-nVnd_2WC5udV8=J=T4wbU3cwH-Gow@mail.gmail.com>
Subject: Re: [PATCH 1/2] don't wait on disk to start on resume
From: "dbasehore ." <dbasehore@chromium.org>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>, jgarzik@pobox.com,
        linux-ide@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That was a response to Sergei's message (which is properly tracked on
the lists).

On Thu, Jan 31, 2013 at 2:27 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Thu, 2013-01-31 at 14:00 -0800, dbasehore . wrote:
>> (Resending as plain text so the message is tracked on vger)
>>
>> Hi, thanks for reading through my patch.
>>
>> With regards to SCSI_SENSE_BUFFERSIZE, I'm following the precedent of
>> scsi_execute_req found in drivers/scsi/scsi_lib.c
>
> I have no context for this: I don't recall making any comment on sense
> buffers; what are you replying to?
>
> James
>
>> It seems that it is used by the scsi_normalize_sense function which I
>> call in sd_resume_async. I just input SCSI_SENSE_BUFFERSIZE directly
>> there though. I didn't know if anything would change its behavior on a
>> lower level if I made sense_len = SCSI_SENSE_BUFFERSIZE, so I just
>> went with what was already done.
>>
>> I'll make sure the semantic fixes go into the final patch.
>>
>> Also, I forgot to mention one possible problem earlier. I understand
>> that some hard drives have a command buffer that can be executed by
>> the hard drive in an order it determines. Does anyone know of a
>> potential problem if the following happens?
>>
>> -resume finishes (hard drive not started yet)
>> -read/write sent to disk, inserted before start command
>>
>> Could this happen? If so, could it cause any problems?
>>
>> I've tested the possibility of a program trying to read/write from the
>> disk before it has started, and the read/write blocks until the disk
>> has actually been spun up. I don't know if there are specific hard
>> drives where this could be a problem though.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
