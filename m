Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719Ab3CNXKm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 19:10:42 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:55623 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880Ab3CNXKl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 19:10:41 -0400
MIME-Version: 1.0
In-Reply-To: <51424000.1030309@gmx.de>
References: <51422008.3020208@gmx.de>
	<CAFLxGvyzkSsUJQMefeB2PcVBykZNqCQe5k19k0MqyVr111848w@mail.gmail.com>
	<514239F7.3050704@gmx.de>
	<20130314212107.GA23056@redhat.com>
	<51424000.1030309@gmx.de>
Date: Fri, 15 Mar 2013 00:10:40 +0100
Message-ID: <CAFLxGvzcy_+2exNbbCGZ460Y417MjoChY39FPXvqaEOZTq8ofQ@mail.gmail.com>
Subject: Re: SLUB + UML : WARNING: at mm/page_alloc.c:2386
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
Cc: Dave Jones <davej@redhat.com>, linux-mm@kvack.org,
        user-mode-linux-user@lists.sourceforge.net,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Davi Arnaut <davi.arnaut@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 10:24 PM, Toralf Förster <toralf.foerster@gmx.de> wrote:
> On 03/14/2013 10:21 PM, Dave Jones wrote:
>> hah, strndup_user taking a signed long instead of a size_t as it's length arg.
>>
>> either it needs to change, or it needs an explicit check for < 1
>>
>> I wonder how many other paths make it possible to pass negative numbers here.
>
> just for the statistics - currently -14 rules  :
>
> 2013-03-14T22:06:21.618+01:00 trinity kernel: memdup_user: -14
> 2013-03-14T22:06:25.664+01:00 trinity kernel: memdup_user: 28
> 2013-03-14T22:06:25.664+01:00 trinity kernel: memdup_user: -14
> 2013-03-14T22:06:37.533+01:00 trinity kernel: memdup_user: 3
> 2013-03-14T22:08:03.379+01:00 trinity kernel: memdup_user: -14
> 2013-03-14T22:09:34.668+01:00 trinity kernel: memdup_user: -14
> 2013-03-14T22:12:33.277+01:00 trinity kernel: memdup_user: -14
> 2013-03-14T22:13:15.214+01:00 trinity kernel: memdup_user: 2
> 2013-03-14T22:14:18.874+01:00 trinity kernel: trinity-watchdo[1169]: segfault at 244 ip 0804c956 sp bf836c9c error 4 in trinity[8048000+1d000]
> 2013-03-14T22:15:10.287+01:00 trinity kernel: memdup_user: 2
> 2013-03-14T22:15:10.287+01:00 trinity kernel: memdup_user: 2
> 2013-03-14T22:17:50.351+01:00 trinity kernel: memdup_user: 2
> 2013-03-14T22:17:59.411+01:00 trinity kernel: memdup_user: -14
>

-14 is -EFAULT.
Time to look at UML's __get_user().

-- 
Thanks,
//richard
