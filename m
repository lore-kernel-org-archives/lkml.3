Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248AbaLNWnw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 17:43:52 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:35894 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbaLNWnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 17:43:47 -0500
MIME-Version: 1.0
In-Reply-To: <20141214223953.GA4168@kroah.com>
References: <1418596582-24557-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <20141214223953.GA4168@kroah.com>
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date: Sun, 14 Dec 2014 23:43:25 +0100
Message-ID: <CAFo99gZicosRYW-8mAp2YHnM_R=UTbJ51ih1duRq+Cd9XB_p-A@mail.gmail.com>
Subject: Re: [PATCH] staging: lustre: lustre: obdclass: lprocfs_status.c: Fix
 for possible null pointer dereference
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>, Greg Donald <gdonald@gmail.com>,
        "John L. Hammond" <john.hammond@intel.com>,
        Andriy Skulysh <Andriy_Skulysh@xyratex.com>,
        Fabian Frederick <fabf@skynet.be>, James Simmons <uja.ornl@gmail.com>,
        HPDD-discuss@ml01.01.org, devel@driverdev.osuosl.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry! extremely stupid. Sending new patch immediately.

Kind regards
Rickard Strandqvist


2014-12-14 23:39 GMT+01:00 Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
> On Sun, Dec 14, 2014 at 11:36:22PM +0100, Rickard Strandqvist wrote:
>> There is otherwise a risk of a possible null pointer dereference.
>>
>> Was largely found by using a static code analysis program called cppcheck.
>>
>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>> ---
>>  .../lustre/lustre/obdclass/lprocfs_status.c        |   20 +++++++++-----------
>>  1 file changed, 9 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
>> index 61e04af..4a7891a 100644
>> --- a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
>> +++ b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
>> @@ -1897,17 +1897,15 @@ int lprocfs_write_frac_u64_helper(const char *buffer, unsigned long count,
>>       }
>>
>>       units = 1;
>> -     switch (*end) {
>> -     case 'p': case 'P':
>> -             units <<= 10;
>> -     case 't': case 'T':
>> -             units <<= 10;
>> -     case 'g': case 'G':
>> -             units <<= 10;
>> -     case 'm': case 'M':
>> -             units <<= 10;
>> -     case 'k': case 'K':
>> -             units <<= 10;
>> +     if (end) {
>> +             switch (*end) {
>> +             case 'p': case 'P':
>> +             case 't': case 'T':
>> +             case 'g': case 'G':
>> +             case 'm': case 'M':
>> +             case 'k': case 'K':
>> +                     units <<= 10;
>> +             }
>
> You know you just changed the logic in the code, right?
>
> Why?  Have you tested this?
>
> greg k-h
