Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481AbbAASS7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 13:18:59 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:48826 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbbAASS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 13:18:57 -0500
MIME-Version: 1.0
X-Originating-IP: [76.119.162.148]
In-Reply-To: <CA+55aFxXvP9qXpFW=NeXquejaU5KiJGkFShGqrech_B03h9zHA@mail.gmail.com>
References: <3159430.4MhUX0bhoZ@sifl>
	<CA+55aFzwqafHa6ARO-zkCDaHZozZDDvETBMmbnvNsnu1L9v2=w@mail.gmail.com>
	<3787508.5gHb8qD3XR@sifl>
	<CA+55aFxXvP9qXpFW=NeXquejaU5KiJGkFShGqrech_B03h9zHA@mail.gmail.com>
Date: Thu, 1 Jan 2015 13:18:56 -0500
Message-ID: <CAHC9VhQUBjGtu0_SbGAwEZgkb=Rxr6TMF0TiX_EviwHN77MXqw@mail.gmail.com>
Subject: Re: [GIT PULL] Audit fixes for 3.19 #2
From: Paul Moore <paul@paul-moore.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-audit@redhat.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 31, 2014 at 5:54 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Dec 31, 2014 at 2:08 PM, Paul Moore <paul@paul-moore.com> wrote:
>>
>> The getname/putname hacks work in the normal file case, but it falls apart
>> when you start talking about AF_UNIX socket files where the filename string
>> doesn't go through the getname/putname refcount tricks.  In the past (no idea
>> how far back this goes off the top of my head) this wasn't an issue since the
>> code which recorded the filenames in the audit records was broken, but since
>> we just "fixed" that problem, the AF_UNIX socket problem is now making an
>> appearance.
>
> Ugh. Ok, I pulled the thing, even if I really hope for a better
> solution long-term. That better solution may well be to get rid of all
> the audit hackery in getname()/putname(), I wouldn't mind that at all.

Thanks.  We'll make this better, I'm confident of that, I'm just not
certain if it will be v3.19-rcX or v3.20 material at this point.

-- 
paul moore
www.paul-moore.com
