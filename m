Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342AbaFDWWP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 18:22:15 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:62489 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbaFDWWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 18:22:13 -0400
MIME-Version: 1.0
In-Reply-To: <20140604215912.GA3702@osiris>
References: <1401917471-2869-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<20140604215912.GA3702@osiris>
Date: Thu, 5 Jun 2014 00:22:13 +0200
Message-ID: <CAFo99gagsUNqSoa5q8ANRV_ZagUGhS72s8fQdagZ4DzUaGkc3Q@mail.gmail.com>
Subject: Re: [PATCH] s390: scsi: zfcp_aux.c: Cleaning up missing
 null-terminate after strncpy call
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Steffen Maier <maier@linux.vnet.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-s390@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

A little embarrassing, but I actually did not know that there was a
better replacement for strncpy.

Sorry, but I will send a new platch based on strlcpy instead then.


Best regards
Rickard Strandqvist


2014-06-04 23:59 GMT+02:00 Heiko Carstens <heiko.carstens@de.ibm.com>:
> On Wed, Jun 04, 2014 at 11:31:11PM +0200, Rickard Strandqvist wrote:
>> Added a guaranteed null-terminate after call to strncpy.
>>
>> This was partly found using a static code analysis program called cppcheck.
>>
>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>> ---
>>  drivers/s390/scsi/zfcp_aux.c |    1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/s390/scsi/zfcp_aux.c b/drivers/s390/scsi/zfcp_aux.c
>> index 8004b07..138b84a 100644
>> --- a/drivers/s390/scsi/zfcp_aux.c
>> +++ b/drivers/s390/scsi/zfcp_aux.c
>> @@ -102,6 +102,7 @@ static void __init zfcp_init_device_setup(char *devstr)
>>       if (!token || strlen(token) >= ZFCP_BUS_ID_SIZE)
>>               goto err_out;
>>       strncpy(busid, token, ZFCP_BUS_ID_SIZE);
>> +     busid[sizeof(busid) - 1] = '\0';
>
> Erm.. with
>         char busid[ZFCP_BUS_ID_SIZE];
> just a couple of lines above this seems to be rather pointless.
> However _if_ we change the code then replacing strncpy() with strlcpy()
> would be the way to go.
>
