Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505AbaFDSHM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 14:07:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24159 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822AbaFDSHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 14:07:10 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 2/2] block,scsi: convert and handle ERR_PTR from blk_get_request
References: <1401396529-17275-1-git-send-email-joe.lawrence@stratus.com>
	<1401396529-17275-3-git-send-email-joe.lawrence@stratus.com>
	<x49mwdtvjtm.fsf@segfault.boston.devel.redhat.com>
	<20140603172646.769e90d6@jlaw-desktop.mno.stratus.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 04 Jun 2014 14:07:02 -0400
In-Reply-To: <20140603172646.769e90d6@jlaw-desktop.mno.stratus.com> (Joe
	Lawrence's message of "Tue, 3 Jun 2014 17:26:46 -0400")
Message-ID: <x498upcpn09.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Lawrence <joe.lawrence@stratus.com> writes:

>> ITYM ret = PTR_ERR(next_rq), right?
>
> Oops, you are right of course.  I can include this change if there should be another version (Jens?)
>
>> > diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
>> > index 084062b..1cf4019 100644
>> > --- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
>> > +++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
>> > @@ -117,7 +117,7 @@ static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
>> >  
>> >  retry:
>> >  	req = blk_get_request(sdev->request_queue, WRITE, GFP_NOIO);
>> > -	if (!req)
>> > +	if (IS_ERR(req))
>> >  		return SCSI_DH_RES_TEMP_UNAVAIL;
>> >  
>> 
>> Don't we have an opportunity here to differentiate between enomem and
>> eio?  I have no idea what the right SCSI_DH error would be, I'm just
>> asking the question.

> This sounded familiar, so I dug through my mailbox and found the
> following patch.  When the blk_get_request patches stalled, I stopped
> working on the scsi_dh patch.  But I think you would be talking about
> the introduction of something like "errno_to_SCSI_DH" below...

Wow, that's a lot more churn than I expected.  ;-) I think you should go
ahead and repost this patch with the change mentioned above (you can add
my reviewed-by), and we can revisit this scsi one separately if people
are interested.

Thanks!
Jeff
