Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757931Ab3BGC3H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 21:29:07 -0500
Received: from mail-qe0-f52.google.com ([209.85.128.52]:57769 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179Ab3BGC3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 21:29:03 -0500
MIME-Version: 1.0
In-Reply-To: <87k3qksw1n.fsf@sejong.aot.lge.com>
References: <CAJd=RBBsMaXS5hA1OCX8Sp2y90Crktp6p4a7MSRZ3p6xq6RCmg@mail.gmail.com>
	<20130206184749.GB2875@htj.dyndns.org>
	<87k3qksw1n.fsf@sejong.aot.lge.com>
Date: Wed, 6 Feb 2013 18:29:01 -0800
X-Google-Sender-Auth: H1ROX4uZJZDfRF0Z9j_6aysdy6M
Message-ID: <CAOS58YMvCuPn2wZbuCkHC8yeLusf_6fBGZr72_8BPG0xyhJrOw@mail.gmail.com>
Subject: Re: [PATCH 2/3] stop_machine: dequeue work before signal completion
From: Tejun Heo <tj@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Hillf Danton <dhillf@gmail.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Feb 6, 2013 at 6:21 PM, Namhyung Kim <namhyung@kernel.org> wrote:
>> Why does this matter?  It's inside spinlock.  What's being made better
>> by this change?
>
> IIUC the work should be deleted from the list, otherwise it'd trigger
> BUG_ON when the cpu gets online again.

Ah, okay, the original code was missing list_del_init(), so we end up
with trashy work list if CPU goes down while there are pending work
items which will trigger BUG_ON() later when the CPU comes back on.

Hillf, can you please redo the patch description? I can't tell what
the patch is about from the description at all. If it's a bug fix,
describe the bug and maybe accompany with oops trace if possible, and
then describe how it's fixed.

Thanks.

-- 
tejun
