Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422AbaETVUF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 17:20:05 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:44799 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbaETVUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 17:20:03 -0400
MIME-Version: 1.0
In-Reply-To: <1400499593.31716.16.camel@linux-fkkt.site>
References: <1400429349-11040-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<Pine.LNX.4.64.1405182147500.23804@axis700.grange>
	<1400499593.31716.16.camel@linux-fkkt.site>
Date: Tue, 20 May 2014 23:20:01 +0200
Message-ID: <CAFo99gaP-BiDi7A+O7a2rQqEpO0XMMO+Wgm7hdV=dMAy-QTzbw@mail.gmail.com>
Subject: Re: [PATCH] scsi: dc395x.c: Fix for possible null pointer dereference
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Oliver Neukum <oneukum@suse.de>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Ali Akcaagac <aliakc@web.de>, Jamie Lenehan <lenehan@twibble.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>, dc395x@twibble.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Okay, good!
Or, do I need to do anything else :-)

Best regards
Rickard Strandqvist


2014-05-19 13:39 GMT+02:00 Oliver Neukum <oneukum@suse.de>:
> On Sun, 2014-05-18 at 21:50 +0200, Guennadi Liakhovetski wrote:
>> On Sun, 18 May 2014, Rickard Strandqvist wrote:
>>
>> > There is otherwise a risk of a possible null pointer dereference.
>> >
>> > Was largely found by using a static code analysis program called cppcheck.
>> >
>> > Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>> > ---
>> >  drivers/scsi/dc395x.c |    2 +-
>> >  1 file changed, 1 insertion(+), 1 deletion(-)
>> >
>> > diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
>> > index 83d9bf6..0d86bc7 100644
>> > --- a/drivers/scsi/dc395x.c
>> > +++ b/drivers/scsi/dc395x.c
>> > @@ -2637,7 +2637,7 @@ static struct ScsiReqBlk *msgin_qtag(struct AdapterCtlBlk *acb,
>> >     struct ScsiReqBlk *srb = NULL;
>> >     struct ScsiReqBlk *i;
>> >     dprintkdbg(DBG_0, "msgin_qtag: (0x%p) tag=%i srb=%p\n",
>> > -              srb->cmd, tag, srb);
>> > +              srb ? srb->cmd : 0, tag, srb);
>>
>> There's not just a risk, it is a NULL-pointer dereference, so, just remove
>> it, e.g. like
>
> Indeed. Thank you both for catching this.
>
>         Regards
>                 Oliver
>
>
>
