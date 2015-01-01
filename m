Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751576AbbAASWL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 13:22:11 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:36678 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbbAASWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 13:22:10 -0500
MIME-Version: 1.0
X-Originating-IP: [76.119.162.148]
In-Reply-To: <20150101000149.GP22149@ZenIV.linux.org.uk>
References: <3159430.4MhUX0bhoZ@sifl>
	<CA+55aFzwqafHa6ARO-zkCDaHZozZDDvETBMmbnvNsnu1L9v2=w@mail.gmail.com>
	<3787508.5gHb8qD3XR@sifl>
	<20150101000149.GP22149@ZenIV.linux.org.uk>
Date: Thu, 1 Jan 2015 13:22:08 -0500
Message-ID: <CAHC9VhRhejMdfJodK-E_-vZ232rwNz4yGyh_+8R1cdNuU0a+VA@mail.gmail.com>
Subject: Re: [GIT PULL] Audit fixes for 3.19 #2
From: Paul Moore <paul@paul-moore.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-audit@redhat.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 31, 2014 at 7:01 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Wed, Dec 31, 2014 at 05:08:12PM -0500, Paul Moore wrote:
>
>> The getname/putname hacks work in the normal file case, but it falls apart
>> when you start talking about AF_UNIX socket files where the filename string
>> doesn't go through the getname/putname refcount tricks.  In the past (no idea
>> how far back this goes off the top of my head) this wasn't an issue since the
>> code which recorded the filenames in the audit records was broken, but since
>> we just "fixed" that problem, the AF_UNIX socket problem is now making an
>> appearance.
>>
>> At least that is how it looks to me right now, if I'm wrong about this and I'm
>> missing an obvious fix I'm all ears/eyes/etc.
>
> Umm...  How about just adding a function that would be used instead of
> all those
>         struct filename filename = { .name = name };
> and created an object that would be destroyed later by putname()?

That was one of the thoughts I had, but considering all the love for
the audit subsystem I wasn't certain if that would be well received by
the other kernel devs.  Now that we at least have the panic/oops
resolved, that frees up some time for debate/discussion; I'll work up
a patchset that takes this approach and we'll see what pushback there
is, if any.

-- 
paul moore
www.paul-moore.com
