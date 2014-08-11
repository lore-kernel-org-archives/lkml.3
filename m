Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886AbaHKTqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 15:46:19 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:49418 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825AbaHKTqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 15:46:18 -0400
MIME-Version: 1.0
In-Reply-To: <20140811091437.GA2730@katana>
References: <1407627938-24614-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <6ACE8FE9-A4AD-4A7A-890F-49F42B81C0A4@gmail.com> <20140811091437.GA2730@katana>
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date: Mon, 11 Aug 2014 21:45:57 +0200
Message-ID: <CAFo99gb4_1Qne+Mnt=iApepVyn00_eM2S4Nw+L3hMatZtwROSA@mail.gmail.com>
Subject: Re: [PATCH] misc: ti-st: st_kim.c: Cleaning up missing null-terminate
 after strncpy call
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Mark D Rustad <mrustad@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Peter Hurley <peter@hurleysoftware.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-08-11 11:14 GMT+02:00 Wolfram Sang <wsa@the-dreams.de>:
>
>> >     strncpy(kim_data->dev_name, buf, count);
>> > +   kim_data->dev_name[count - 1] = '\n';
>>
>> Of course this does not add termination, but adds a newline at the end of the buffer? Huh?
>
> strlcpy?
>

Hi Wolfram

Sure, strlcpy is preferable in many ways if we only can guarantee that
it is safe.
I have seldom been so much criticism when I start switching to
strlcpy, although much of it was justified :)
Even Linus was getting into the debate.  See more:

https://plus.google.com/111049168280159033135/posts/1amLbuhWbh5


I do this only when I'm sure it will not cause any other problems.
But if you or anyone else can guarantee that in this case, so I'd make
a new patch.


Kind regards
Rickard Strandqvist
