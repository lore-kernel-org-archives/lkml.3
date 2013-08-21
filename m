Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620Ab3HUSn1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 14:43:27 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:53819 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743Ab3HUSn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 14:43:26 -0400
MIME-Version: 1.0
In-Reply-To: <20130821182053.GA19624@redhat.com>
References: <CALCETrXMQdjRyvP8RHOd5xjciurS7-hKUOExvkvQ1RWmdRdypA@mail.gmail.com>
 <0be9da18c0ca360773a397de3063d01019ff88d8.1377107508.git.luto@amacapital.net> <20130821182053.GA19624@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 21 Aug 2013 11:43:05 -0700
Message-ID: <CALCETrXtJBDqkvO3mHxDrHL3whCWX_B-LAXOnue7r90nyyWY_A@mail.gmail.com>
Subject: Re: [PATCH] vfs: Tighten up linkat(..., AT_EMPTY_PATH)
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "security@kernel.org" <security@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Willy Tarreau <w@1wt.eu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Brad Spengler <spender@grsecurity.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 11:20 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> Can't really comment the patch, just a nit:
>
> On 08/21, Andy Lutomirski wrote:
>>
>> +static bool may_flink(const struct path *path)
>> +{
>> +     bool ret;
>> +     struct inode *inode = path->dentry->d_inode;
>> +
>> +     /*
>> +      * This is racy: I_LINKABLE could be cleared between this check
>> +      * and the actual link operation.
>
> OK,
>
>> +     spin_lock(&inode->i_lock);
>> +     ret = !!(inode->i_state & I_LINKABLE);
>> +     spin_unlock(&inode->i_lock);
>
> so why do we need to take a lock ?
>

We probably don't.  But other accesses to this field take that lock,
so it seemed safer.

(In principle, someone could take the lock, write I_LINKABLE, clear
it, and unlock, and we'd get confused if we didn't take the lock
ourselves.)

> Oleg.
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
