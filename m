Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586AbaK2J4a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 04:56:30 -0500
Received: from smtp2-out.insa-rennes.fr ([193.52.94.25]:24968 "EHLO
	smtp2-out.insa-rennes.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbaK2J42 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 04:56:28 -0500
X-Greylist: delayed 590 seconds by postgrey-1.27 at vger.kernel.org; Sat, 29 Nov 2014 04:56:27 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqUEAGqVeVQKBQEl/2dsb2JhbABb0hcCgR0BAQEBAX2EAwEBBHkQCyElDwIQNgYBDAEFAgEBiCcDzCINhgIBAQEBAQEBAQIBAQEBAQEBG45DgVcKJDMHhEgBBJpGgy+GJDeEJoJGikolSYEFgUIBAQE
Message-ID: <547995EF.10804@supelec.fr>
Date: Sat, 29 Nov 2014 10:46:23 +0100
From: Laurent Georget <laurent.georget@supelec.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.8.0
MIME-Version: 1.0
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
CC: linux-man@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch v2] adjtimex.2: add explanation about ADJ_TAI action
References: <54787B5C.1080802@supelec.fr> <20141128210043.GB14432@localhost.localdomain> <5478FF09.6090508@supelec.fr> <54799198.1070907@gmail.com>
In-Reply-To: <54799198.1070907@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Le 29/11/2014 10:27, Michael Kerrisk (man-pages) a écrit :
> Hello Laurent,
> 
> Thanks for working on this. I have one question; see below.
> 
>>
>> diff --git a/man2/adjtimex.2 b/man2/adjtimex.2
>> index 20a2f0b..871e607 100644
>> --- a/man2/adjtimex.2
>> +++ b/man2/adjtimex.2
>> @@ -26,9 +26,6 @@
>>  .\" Modified 2004-05-27 by Michael Kerrisk <mtk.manpages@gmail.com>
>>  .\" Modified 2014-11-28 by Laurent Georget <laurent.georget@supelec.fr>
>>  .\"
>> -.\" FIXME Document ADJ_TAI (added in Linux 2.6.26)
>> -.\"		commit 153b5d054ac2d98ea0d86504884326b6777f683d
>> -.\"
>>  .\" FIXME Document ADJ_MICRO and ADJ_NANO (added in Linux 2.6.26)
>>  .\"		commit eea83d896e318bda54be2d2770d2c5d6668d11db
>>  .\"		Author: Roman Zippel <zippel@linux-m68k.org>
>> @@ -74,6 +71,17 @@ struct timex {
>>                              (read-only) */
>>      struct timeval time; /* current time (read-only) */
>>      long tick;           /* usecs between clock ticks */
> 
> What is the following piece about? Did you mean to include it in this patch?

Those are new fields added in struct timex since the last edition of the
man page. Maybe I should split the commit in two subcommits: the first
one to add the new fields, and the second one to specifically add the
ADJ_TAI flag?

> 
>> +
>> +    long ppsfreq;        /* pps frequency (scaled ppm) (read-only) */
>> +    long jitter;         /* pps jitter (usec) (read-only) */
>> +    int shift;           /* interval duration (sec) (read-only) */
>> +    long stabil;         /* pps stability (scaled ppm) (read-only) */
>> +    long jitcnt;         /* jitter limit exceeded (read-only) */
>> +    long calcnt;         /* calibration intervals (read-only) */
>> +    long errcnt;         /* calibration errors (read-only) */
>> +    long stbcnt;         /* stability limit exceeded (read-only) */
>> +
>> +    int tai;             /* TAI offset (s) (read-only) */
>>  };
> 
> Thanks,
> 
> Michael
> 

Thanks,

Laurent

