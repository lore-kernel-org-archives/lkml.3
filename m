Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471AbaERWnd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 18:43:33 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:33977 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbaERWnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 18:43:31 -0400
MIME-Version: 1.0
In-Reply-To: <CANoiuGJC4CcZf-dzBQjFE72eBsb0zXTy4vxeE87cngT=kEiTVA@mail.gmail.com>
References: <1400385604-21086-1-git-send-email-matlackdavid@gmail.com>
 <1400385604-21086-2-git-send-email-matlackdavid@gmail.com>
 <1400386345.14720.3.camel@joe-AO725> <CANoiuGJC4CcZf-dzBQjFE72eBsb0zXTy4vxeE87cngT=kEiTVA@mail.gmail.com>
From: David Matlack <matlackdavid@gmail.com>
Date: Sun, 18 May 2014 15:43:10 -0700
Message-ID: <CANoiuGK-ys5Sf5Stw5cxRJ1y8SrH4RWYteZdhZwNxchoV4Hbvw@mail.gmail.com>
Subject: Re: [PATCH 1/2] staging: slicoss: rewrite eeprom checksum code
To: Joe Perches <joe@perches.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, Lior Dotan <liodot@gmail.com>,
        charrer@alacritech.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 17, 2014 at 9:51 PM, David Matlack <matlackdavid@gmail.com> wrote:
> On Sat, May 17, 2014 at 9:12 PM, Joe Perches <joe@perches.com> wrote:
>> The if seems unnecessary.
>>
>> Perhaps declare a u16 return var or use
>>
>>         return lower_16 + upper_16;
>
> I agree it's fishy... but using overflow doesn't produce the same result:
>
>          (u16) 65536   == 0
>          65536 - 65535 == 1
>
> Now which is the correct result, I have no idea.

I think the checksum algorithm being used here is RFC 1071 [1]. Which means the
if is correct and just accounting for double overflow.

> The eeprom on this device is
> small (0x80 bytes max, not enough to trigger overflow) and I have no

Sorry, I was wrong about this. I was thinking in terms of summing bytes,
but the checksum is summing words. Overflow _does_ get triggered.


I think I'll go over this patch again while looking at the RFC to make sure
everything is ok. Thanks!

[1] http://tools.ietf.org/html/rfc1071
