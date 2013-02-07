Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758206Ab3BGLxz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 06:53:55 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:60214 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757344Ab3BGLxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 06:53:54 -0500
MIME-Version: 1.0
In-Reply-To: <CAOS58YMvCuPn2wZbuCkHC8yeLusf_6fBGZr72_8BPG0xyhJrOw@mail.gmail.com>
References: <CAJd=RBBsMaXS5hA1OCX8Sp2y90Crktp6p4a7MSRZ3p6xq6RCmg@mail.gmail.com>
	<20130206184749.GB2875@htj.dyndns.org>
	<87k3qksw1n.fsf@sejong.aot.lge.com>
	<CAOS58YMvCuPn2wZbuCkHC8yeLusf_6fBGZr72_8BPG0xyhJrOw@mail.gmail.com>
Date: Thu, 7 Feb 2013 19:53:53 +0800
Message-ID: <CAJd=RBBDC7oU0Zqm=zyr+UwjcHFBvMA2LXgYfMrEOeQ567xp2Q@mail.gmail.com>
Subject: Re: [PATCH 2/3] stop_machine: dequeue work before signal completion
From: Hillf Danton <dhillf@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 7, 2013 at 10:29 AM, Tejun Heo <tj@kernel.org> wrote:
> On Wed, Feb 6, 2013 at 6:21 PM, Namhyung Kim <namhyung@kernel.org> wrote:
>>> Why does this matter?  It's inside spinlock.  What's being made better
>>> by this change?
>>
>> IIUC the work should be deleted from the list, otherwise it'd trigger
>> BUG_ON when the cpu gets online again.
>
> Ah, okay, the original code was missing list_del_init(), so we end up
> with trashy work list if CPU goes down while there are pending work
> items which will trigger BUG_ON() later when the CPU comes back on.
>
> Hillf, can you please redo the patch description?

Sure, thanks;)
Hillf
