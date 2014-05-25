Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751461AbaEYXqx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 19:46:53 -0400
Received: from mail.siteground.com ([67.19.240.234]:48162 "EHLO
	mail.siteground.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbaEYXqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 19:46:52 -0400
Message-ID: <538280EC.1010202@1h.com>
Date: Mon, 26 May 2014 02:46:52 +0300
From: Marian Marinov <mm@1h.com>
Organization: 1H Ltd.
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
CC: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
        Jos Huisken <jos.huisken@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: inotify, new idea?
References: <CAOiKX_m8buaq=4_hVQjyfv36ZtFVFieZ-CU8JeDpcdbeiX5mug@mail.gmail.com> <20140417212834.GC17769@csclub.uwaterloo.ca> <CAHO5Pa1Rb5YkXF_0iE_KUhOOGeNo+zV+OWQW6L8_ix=iFvkTyg@mail.gmail.com> <CAFLxGvxx8_gJ+NAGVn_vZmkVfey45_1qTqAQnxKDCZD0gQsr5w@mail.gmail.com> <CAHO5Pa1hfp+uLiQ78-pn2RJ6SytSYqXTniyx3UvaTwU_=ECWjA@mail.gmail.com> <5354DA0B.2060204@nod.at> <53804FC0.1010207@gmail.com> <538091C2.6040802@nod.at>
In-Reply-To: <538091C2.6040802@nod.at>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - mail.siteground.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - 1h.com
X-Get-Message-Sender-Via: mail.siteground.com: none
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 05/24/2014 03:34 PM, Richard Weinberger wrote:
> Am 24.05.2014 09:52, schrieb Michael Kerrisk (man-pages):
>> On 04/21/2014 10:42 AM, Richard Weinberger wrote:
>>> Am 21.04.2014 09:24, schrieb Michael Kerrisk:
>>>>> Does recursive monitoring even work with inotify? Last time I've tried it did failed as soon I did a mkdir
>>>>> -p a/b/c/d because mkdir() raced against the thread which installes the new watches.
>>>> 
>>>> As I understand it, you have to program to deal with the races (rescan directories after adding watches). I
>>>> recently did a lot of work updating the inotify(7) man page to discuss all the issues that I know of, and
>>>> their remedies. If I missed anything, I'd appreciate a note on it, so that it can be added. See 
>>>> http://man7.org/linux/man-pages/man7/inotify.7.html#NOTES
>>> 
>>> I'm aware of the rescan hack, but in my case it does not help because my program must not miss any event. 
>>> Currently I'm using a fuse overlay filesystem to log everything. Not perfect but works... :-)
>> 
>> Richard,
>> 
>> A late follow up question. How does your application deal with the event overflow problem (i.e., when you get a
>> large number of events much faster than your application can deal with them?
> 
> The downside of the FUSE approach is that you have to intercept every filesystem function. This can be a
> performance issue. But due to this design the overflow problem cannot happen as the FUSE filesystem blocks until
> the event has been proceed.
> 

Have anyone of you looked at this: https://github.com/1and1/linux-filemon/

I haven't stress tested it, but in the past I ported it to more recent kernels:
  https://github.com/hackman/filemon-patches

It is not polished, but it works.

I'm considering fixing some of the issues at has for use in my home setup.

Marian

> Thanks, //richard -- To unsubscribe from this list: send the line "unsubscribe linux-kernel" in the body of a
> message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html Please read
> the FAQ at  http://www.tux.org/lkml/
> 


- -- 
Marian Marinov
Founder & CEO of 1H Ltd.
Jabber/GTalk: hackman@jabber.org
ICQ: 7556201
Mobile: +359 886 660 270
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAlOCgOwACgkQ4mt9JeIbjJSXrgCdHCFADxvKN3Hxb4qinc/5Fj6V
WYMAnArk3Zb8YqTUNoyNCh1zYplUUx9B
=y/Sm
-----END PGP SIGNATURE-----
