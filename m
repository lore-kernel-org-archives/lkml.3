Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101AbaBRWUf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 17:20:35 -0500
Received: from mail-ve0-f174.google.com ([209.85.128.174]:65469 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbaBRWUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:20:30 -0500
MIME-Version: 1.0
In-Reply-To: <87ha7wrtyz.fsf@xmission.com>
References: <CAJfpegsxgnSRUW-E5HM3uT5QfGyUtn_v=i4Ppkkkutp34287AA@mail.gmail.com>
	<87a9kkax0j.fsf@xmission.com>
	<CAJfpeguv+7giYNpAuXE9Ja_9BEwB0-fZBVgRSeVqpzSXgQYZ6Q@mail.gmail.com>
	<8761v7h2pt.fsf@tw-ebiederman.twitter.com>
	<CAJfpegtT7y-1HhbEVAMKkdQugTG_w7G_epGtQHGvQLpcZB5FVA@mail.gmail.com>
	<87li281wx6.fsf_-_@xmission.com>
	<87ob28kqks.fsf_-_@xmission.com>
	<8761ogkqhl.fsf_-_@xmission.com>
	<20140218171252.GC4026@tucsk.piliscsaba.szeredi.hu>
	<87ha7wrtyz.fsf@xmission.com>
Date: Tue, 18 Feb 2014 14:20:29 -0800
X-Google-Sender-Auth: QB_b4DczDFW6tRCHkBMoosHJgxY
Message-ID: <CA+55aFx8nksLjQt3aECVk2Ni5FNPXxL988mEqfFgqbbubZho6w@mail.gmail.com>
Subject: Re: [PATCH 03/11] vfs: Don't allow overwriting mounts in the current
 mount namespace
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>, Rob Landley <rob@landley.net>,
        Christoph Hellwig <hch@infradead.org>, Karel Zak <kzak@redhat.com>,
        "J. Bruce Fields" <bfields@fieldses.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 1:28 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
>>
>> Minor nit: return value of any is_* function is either true or false, so why not
>> declare it bool?
>
> Because I am working on the core of the kernel and C compilers do weird
> things with bool variables (storing them in bytes...).  I expected a
> type that the C compiler does not do weird things with would be more
> readily received on a path whose performance people are interested in.

Yeah, I have to say that I'm not a huge fan of "bool". It has some odd
properties, especially in memory (ie as a structure member).

For this kind of function return value it actually tends to work very
well, and in fact often generates slightly better code than "int". So
I don't _hate_ bool, and we've certainly had a lot more use creep in
lately, but I also don't really see "bool" as much of an upside.

             Linus
