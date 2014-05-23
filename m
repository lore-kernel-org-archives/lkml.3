Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468AbaEWQkU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 12:40:20 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:48732 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598AbaEWQkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 12:40:18 -0400
MIME-Version: 1.0
In-Reply-To: <20140523070016.GG9198@axis.com>
References: <1400796009-12716-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<20140523070016.GG9198@axis.com>
Date: Fri, 23 May 2014 18:40:17 +0200
Message-ID: <CAFo99ga_G=Bsvagi5PFCiq++6CaAqtWUo5PS6VxLUEsTvEMqdA@mail.gmail.com>
Subject: Re: [PATCH] arch: cris: arch-v32: drivers: axisflashmap.c: Cleaning
 up inconsistent NULL checks
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Mikael Starvik <starvik@axis.com>, Jesper Nilsson <jespern@axis.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-cris-kernel <linux-cris-kernel@axis.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hej Jesper!

But in several other place in the feature ensures that main_mtd is not NULL.
(That's what cppcheck base their misjudgment on too)

Then all these checks are unnecessary?
You should know, looks like you've written most of the code in 2007 :)


Best regards
Rickard Strandqvist


2014-05-23 9:00 GMT+02:00 Jesper Nilsson <jesper.nilsson@axis.com>:
> On Fri, May 23, 2014 at 12:00:09AM +0200, Rickard Strandqvist wrote:
>> Cleaning up inconsistent NULL checks.
>> There is otherwise a risk of a possible null pointer dereference.
>>
>> Was largely found by using a static code analysis program called cppcheck.
>
> ... and is a false positive.
>
> We can't enter this if-block unless ptable_head is set,
> which is only set if main_mtd is set.
>
> It might be useful to add it anyways, but there's a refactoring
> needed for the axisflashmaps, so I'll keep it for then.
>
> /^JN - Jesper Nilsson
> --
>                Jesper Nilsson -- jesper.nilsson@axis.com
