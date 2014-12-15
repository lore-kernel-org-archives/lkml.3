Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751165AbaLOXHm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 18:07:42 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:52511 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbaLOXHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 18:07:41 -0500
MIME-Version: 1.0
In-Reply-To: <20141215102502.GB4856@mwanda>
References: <1418596638-24646-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <20141215102502.GB4856@mwanda>
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date: Tue, 16 Dec 2014 00:07:19 +0100
Message-ID: <CAFo99gZXxEgZMgZ4Vc0yKjm8AYdrGTkZZ3Yr4j_HNuPEPUUFbw@mail.gmail.com>
Subject: Re: [PATCH] staging: lustre: lustre: osc: lproc_osc.c: Fix for
 possible null pointer dereference
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Brilliantov Kirill Vladimirovich <brilliantov@inbox.ru>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        HPDD-discuss@ml01.01.org, Greg Donald <gdonald@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan

Quite right! Had to try it.

Do nothing then?
But you must agree that it is still ugly and confusing code.

Kind regards
Rickard Strandqvist


2014-12-15 11:25 GMT+01:00 Dan Carpenter <dan.carpenter@oracle.com>:
> On Sun, Dec 14, 2014 at 11:37:18PM +0100, Rickard Strandqvist wrote:
>> There is otherwise a risk of a possible null pointer dereference.
>>
>> Was largely found by using a static code analysis program called cppcheck.
>>
>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>> ---
>>  drivers/staging/lustre/lustre/osc/lproc_osc.c |    4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/staging/lustre/lustre/osc/lproc_osc.c b/drivers/staging/lustre/lustre/osc/lproc_osc.c
>> index 9f719bc..9ba6293 100644
>> --- a/drivers/staging/lustre/lustre/osc/lproc_osc.c
>> +++ b/drivers/staging/lustre/lustre/osc/lproc_osc.c
>> @@ -237,13 +237,15 @@ static ssize_t osc_cur_grant_bytes_seq_write(struct file *file, const char *buff
>>                                 size_t count, loff_t *off)
>>  {
>>       struct obd_device *obd = ((struct seq_file *)file->private_data)->private;
>> -     struct client_obd *cli = &obd->u.cli;
>> +     struct client_obd *cli;
>
> This isn't really a dereference.  You're just getting the address of
> obd->u.cli.  So if obd is NULL then it won't crash.
>
> regards,
> dan carpenter
>
