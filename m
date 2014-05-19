Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751244AbaESV4G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 17:56:06 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:59915 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbaESV4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 17:56:05 -0400
MIME-Version: 1.0
In-Reply-To: <537A771C.2050808@cogentembedded.com>
References: <1400534662-5729-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<537A771C.2050808@cogentembedded.com>
Date: Mon, 19 May 2014 23:56:03 +0200
Message-ID: <CAFo99gb3fOq=kXwiG=LsvRXHdgazQWv3t6XZqDOtRHc+FLxCbw@mail.gmail.com>
Subject: Re: [PATCH] isdn: hisax: l3dss1.c: Fix for possible null pointer dereference
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Karsten Keil <isdn@linux-pingi.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi  Sergei

I did not put the assignment in the if statement. Is it meant for me
to change all the code around the parts I fix?
There are many assignments in if in the l3dss1_cmd_global() funktion.


It's late and I'm tired, but I still can not see which of these pairs
of features that I can remove ...?

            if (ic->parm.dss1_io.timeout > 0) {
                if (!(pc = dss1_new_l3_process(st, -1))) {
                    free_invoke_id(st, id);
                    return (-2);
                }
                pc->prot.dss1.ll_id = ic->parm.dss1_io.ll_id; /* remember id */
                pc->prot.dss1.proc = ic->parm.dss1_io.proc; /* and procedure */
            }


Best regards
Rickard Strandqvist


2014-05-19 23:26 GMT+02:00 Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>:
> On 05/20/2014 01:24 AM, Rickard Strandqvist wrote:
>
>> There is otherwise a risk of a possible null pointer dereference.
>
>
>> Was largely found by using a static code analysis program called cppcheck.
>
>
>> Signed-off-by: Rickard Strandqvist
>> <rickard_strandqvist@spectrumdigital.se>
>> ---
>>   drivers/isdn/hisax/l3dss1.c |   11 ++++++-----
>>   1 file changed, 6 insertions(+), 5 deletions(-)
>
>
>> diff --git a/drivers/isdn/hisax/l3dss1.c b/drivers/isdn/hisax/l3dss1.c
>> index cda7006..9ea7377 100644
>> --- a/drivers/isdn/hisax/l3dss1.c
>> +++ b/drivers/isdn/hisax/l3dss1.c
>> @@ -2203,13 +2203,14 @@ static int l3dss1_cmd_global(struct PStack *st,
>> isdn_ctrl *ic)
>>                         memcpy(p, ic->parm.dss1_io.data,
>> ic->parm.dss1_io.datalen); /* copy data */
>>                         l = (p - temp) + ic->parm.dss1_io.datalen; /*
>> total length */
>>
>> -                       if (ic->parm.dss1_io.timeout > 0)
>> -                               if (!(pc = dss1_new_l3_process(st, -1)))
>> -                               { free_invoke_id(st, id);
>> +                       if (ic->parm.dss1_io.timeout > 0) {
>> +                               if (!(pc = dss1_new_l3_process(st, -1))) {
>
>
>    Assignments shouldn't be put into *if* statement. If you did run the
> patch thru scripts/checkpatch.pl, it would have told you.
>
>
>> +                                       free_invoke_id(st, id);
>>                                         return (-2);
>
>
>    Parens not needed. Could as well fix it here...
>
>
>>                                 }
>> -                       pc->prot.dss1.ll_id = ic->parm.dss1_io.ll_id; /*
>> remember id */
>> -                       pc->prot.dss1.proc = ic->parm.dss1_io.proc; /* and
>> procedure */
>> +                               pc->prot.dss1.ll_id =
>> ic->parm.dss1_io.ll_id; /* remember id */
>> +                               pc->prot.dss1.proc =
>> ic->parm.dss1_io.proc; /* and procedure */
>> +                       }
>
>
> WBR, Sergei
>
>
