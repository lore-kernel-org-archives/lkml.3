Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646AbaFZA2Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 20:28:16 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:40153 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356AbaFZA2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 20:28:15 -0400
MIME-Version: 1.0
In-Reply-To: <1403716401.10214.2.camel@lbirv-waie-lx2.broadcom.com>
References: <1403705059-25834-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<53AADC16.9080301@redhat.com>
	<1403716401.10214.2.camel@lbirv-waie-lx2.broadcom.com>
Date: Thu, 26 Jun 2014 02:28:14 +0200
Message-ID: <CAFo99gbp-CeoT-3rNkNJX1m79G+5zi7pJLjX9kYq=FEf1isn=g@mail.gmail.com>
Subject: Re: [PATCH] scsi: bnx2i: bnx2i_iscsi.c: Cleaning up variable is set
 more than once
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Eddie Wai <eddie.wai@broadcom.com>
Cc: Maurizio Lombardi <mlombard@redhat.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-06-25 19:13 GMT+02:00 Eddie Wai <eddie.wai@broadcom.com>:
> On Wed, 2014-06-25 at 16:26 +0200, Maurizio Lombardi wrote:
>> Hi,
>>
>> On 06/25/2014 04:04 PM, Rickard Strandqvist wrote:
>> > A struct member variable is set to different values without having used in between.
>> >
>> > This was found using a static code analysis program called cppcheck
>> >
>> > Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>> > ---
>> >  drivers/scsi/bnx2i/bnx2i_iscsi.c |    1 -
>> >  1 file changed, 1 deletion(-)
>> >
>> > diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
>> > index 166543f..fdf7bc3 100644
>> > --- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
>> > +++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
>> > @@ -1643,7 +1643,6 @@ static void bnx2i_conn_get_stats(struct iscsi_cls_conn *cls_conn,
>> >     stats->r2t_pdus = conn->r2t_pdus_cnt;
>> >     stats->tmfcmd_pdus = conn->tmfcmd_pdus_cnt;
>> >     stats->tmfrsp_pdus = conn->tmfrsp_pdus_cnt;
>> > -   stats->custom_length = 3;
>> >     strcpy(stats->custom[2].desc, "eh_abort_cnt");
>> >     stats->custom[2].value = conn->eh_abort_cnt;
>> >     stats->digest_err = 0;
>> >
>>
>> Eddie,
>>
>> The code modifies the content of stats->custom[2], so shouldn't custom_length be set to 3?
>> Why is it set to zero at the end of this function?
> Nice find.  This is literally a day1 bug.  Yes, I agree that the
> custom_length should be left at 3.  Otherwise, the nlmsg replied back to
> the application would not have the custom message.  Thanks.
>>
>> Regards,
>> Maurizio Lombardi
>
>


Hi, and thank you!

If it's not obvious, I do all my fixes without changing the previous
intent. But obviously it is not always right, rather it is one of main
reasons to fix this type of error :)

But I'll make a new patch then, with = 3 ?


Kind regards
Rickard Strandqvist
