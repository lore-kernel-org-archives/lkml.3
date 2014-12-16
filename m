Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486AbaLPDIj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 22:08:39 -0500
Received: from exprod6og107.obsmtp.com ([64.18.1.208]:50972 "EHLO
	exprod6og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbaLPDIi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 22:08:38 -0500
From: Patrick Farrell <paf@cray.com>
To: Joe Perches <joe@perches.com>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "Fabian Frederick" <fabf@skynet.be>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        "James Simmons" <uja.ornl@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Donald <gdonald@gmail.com>,
        "HPDD-discuss@lists.01.org" <HPDD-discuss@ml01.01.org>,
        Andriy Skulysh <Andriy_Skulysh@xyratex.com>
Subject: RE: [HPDD-discuss] [PATCH] staging: lustre: lustre: obdclass:
 lprocfs_status.c: Fix for possible null pointer dereference
Thread-Topic: [HPDD-discuss] [PATCH] staging: lustre: lustre: obdclass:
 lprocfs_status.c: Fix for possible null pointer dereference
Thread-Index: AQHQGGuxhDultA0Mv0+StzfzdrS3mpyRnzmAgAAZGwD//9BJRw==
Date: Tue, 16 Dec 2014 03:08:23 +0000
Message-ID: <DB0C8A206669AC40B1C4E52A8584A6F61499F749@CFWEX01.americas.cray.com>
References: <1418597547-25086-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <1418608297.2674.4.camel@perches.com>
 <CAFo99gaVUbsvwY7RKZ9D=c0jnVeFiBLAeNVb53UX=Ba4XytoKg@mail.gmail.com>,<1418687596.2674.25.camel@perches.com>
In-Reply-To: <1418687596.2674.25.camel@perches.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.234.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Strongly agreed that execution speed is not critical here.  It's the update of a proc variable, not a tight loop or critical section.

Normally I'd leave it alone, but since you're writing a patch anyway, I'd do 'tolower' myself.  I dislike the stacked case statements on a single line like that.  (It's the only time I've seen them written that way.  Perhaps it's common and I've just missed it.)

Regards,
- Patrick
________________________________________
From: HPDD-discuss [hpdd-discuss-bounces@lists.01.org] on behalf of Joe Perches [joe@perches.com]
Sent: Monday, December 15, 2014 5:53 PM
To: Rickard Strandqvist
Cc: devel@driverdev.osuosl.org; Fabian Frederick; Julia Lawall; James Simmons; Greg Kroah-Hartman; linux-kernel@vger.kernel.org; Greg Donald; HPDD-discuss@lists.01.org; Andriy Skulysh
Subject: Re: [HPDD-discuss] [PATCH] staging: lustre: lustre: obdclass: lprocfs_status.c: Fix for possible null pointer dereference

On Mon, 2014-12-15 at 23:23 +0100, Rickard Strandqvist wrote:
> Hi Joe

Hello Rickard

> No, it does not look like end can be NULL then.
> Then remove the end != NULL instead?
> ...
>     if (end != NULL && *end == '.') {

Up to you.

> However, I am hesitant to the tolower()  I think double case is faster...?

I doubt code execution speed is paramount here.
Maybe see if the object code size is smaller one
way or the other.


_______________________________________________
HPDD-discuss mailing list
HPDD-discuss@lists.01.org
https://lists.01.org/mailman/listinfo/hpdd-discuss
