Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270Ab3KUDND (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 22:13:03 -0500
Received: from mail-qe0-f50.google.com ([209.85.128.50]:42308 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab3KUDM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 22:12:59 -0500
MIME-Version: 1.0
In-Reply-To: <CALZtONA81=R4abFMpMMtDZKQe0s-8+JxvEfZO3NEZ910VwRDmw@mail.gmail.com>
References: <1384965522-5788-1-git-send-email-ddstreet@ieee.org>
	<20131120173347.GA2369@hp530>
	<CALZtONA81=R4abFMpMMtDZKQe0s-8+JxvEfZO3NEZ910VwRDmw@mail.gmail.com>
Date: Thu, 21 Nov 2013 11:12:58 +0800
Message-ID: <CAL1ERfMdOQ+DKiYEVBpP54RZYQWS_-7Xgf2YTA5jAZRxWsE6ag@mail.gmail.com>
Subject: Re: [PATCH] mm/zswap: change params from hidden to ro
From: Weijie Yang <weijie.yang.kh@gmail.com>
To: Dan Streetman <ddstreet@ieee.org>
Cc: Vladimir Murzin <murzin.v@gmail.com>, linux-mm@kvack.org,
        Seth Jennings <sjennings@variantweb.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bob Liu <bob.liu@oracle.com>, Minchan Kim <minchan@kernel.org>,
        Weijie Yang <weijie.yang@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 1:52 AM, Dan Streetman <ddstreet@ieee.org> wrote:
> On Wed, Nov 20, 2013 at 12:33 PM, Vladimir Murzin <murzin.v@gmail.com> wrote:
>> Hi Dan!
>>
>> On Wed, Nov 20, 2013 at 11:38:42AM -0500, Dan Streetman wrote:
>>> The "compressor" and "enabled" params are currently hidden,
>>> this changes them to read-only, so userspace can tell if
>>> zswap is enabled or not and see what compressor is in use.
>>
>> Could you elaborate more why this pice of information is necessary for
>> userspace?
>
> For anyone interested in zswap, it's handy to be able to tell if it's
> enabled or not ;-)  Technically people can check to see if the zswap
> debug files are in /sys/kernel/debug/zswap, but I think the actual
> "enabled" param is more obvious.  And the compressor param is really
> the only way anyone from userspace can see what compressor's being
> used; that's helpful to know for anyone that might want to be using a
> non-default compressor.
>
> And of course, eventually we'll want to make the params writable, so
> the compressor can be changed dynamically, and zswap can be enabled or
> disabled dynamically (or at least enabled after boot).

Please do not make them writable.
There is no requirement to do that, and it will make zswap more complex.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
