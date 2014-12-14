Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898AbaLNW4N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 17:56:13 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:47423 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828AbaLNW4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 17:56:05 -0500
MIME-Version: 1.0
In-Reply-To: <1418597564.2674.1.camel@perches.com>
References: <1418596940-24915-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <1418597564.2674.1.camel@perches.com>
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date: Sun, 14 Dec 2014 23:55:43 +0100
Message-ID: <CAFo99gaZ52cbLGPT6=fPYydZjm5Jx3KNbwKWoKsgep2DTR8b5Q@mail.gmail.com>
Subject: Re: [PATCH] staging: vt6655: wmgr.c: Fix for possible null pointer dereference
To: Joe Perches <joe@perches.com>
Cc: Forest Bond <forest@alittletooquiet.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Malcolm Priestley <tvboxspy@gmail.com>,
        Guillaume Clement <gclement@baobob.org>,
        =?UTF-8?Q?Guido_Mart=C3=ADnez?= <guido@vanguardiasur.com.ar>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Himangi Saraogi <himangi774@gmail.com>, devel@driverdev.osuosl.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Ok, if you want, otherwise we can put it after the NULL check?

Kind regards
Rickard Strandqvist


2014-12-14 23:52 GMT+01:00 Joe Perches <joe@perches.com>:
> On Sun, 2014-12-14 at 23:42 +0100, Rickard Strandqvist wrote:
>> There is otherwise a risk of a possible null pointer dereference.
>> Was largely found by using a static code analysis program called cppcheck.
> []
>> diff --git a/drivers/staging/vt6655/wmgr.c b/drivers/staging/vt6655/wmgr.c
> []
>> @@ -4391,7 +4391,7 @@ bAdd_PMKID_Candidate(
>>       unsigned int ii = 0;
>>
>>       pr_debug("bAdd_PMKID_Candidate START: (%d)\n",
>> -              (int)pDevice->gsPMKIDCandidate.NumCandidates);
>> +             (int)(pDevice ? pDevice->gsPMKIDCandidate.NumCandidates : 0));
>
> This is a function tracing printk.
> I think it's better to just remove it.
>
>
>
