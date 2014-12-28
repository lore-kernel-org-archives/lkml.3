Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751442AbaL1J4e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 04:56:34 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:39061 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbaL1J4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 04:56:32 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1419619556.4705.136.camel@decadent.org.uk>
References: <CA+icZUXPt=GM08PD8LOpCdxCYhNMrr-2MHxPyNRWPXqUjQXFrw@mail.gmail.com>
	<CA+icZUVfiQ1+k2zD9HXMM40N8rwg6rEmYLdKfHGsGt3xvJu+4w@mail.gmail.com>
	<1419619556.4705.136.camel@decadent.org.uk>
Date: Sun, 28 Dec 2014 10:56:30 +0100
Message-ID: <CA+icZUX47rv=BqMdKuXeT0s9q1fageu1gUxBDc-Dn+tk=36vqg@mail.gmail.com>
Subject: Re: deb-pkg: Cleaning of debian/*tmp files when running 'make (dist)clean'
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Michal Marek <mmarek@suse.cz>, maximilian attems <max@stro.at>,
        LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org,
        Masahiro Yamada <yamada.m@jp.panasonic.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 26, 2014 at 7:46 PM, Ben Hutchings <ben@decadent.org.uk> wrote:
> On Fri, 2014-12-26 at 13:43 +0100, Sedat Dilek wrote:
>> On Fri, Dec 26, 2014 at 1:02 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>> [...]
>> >
>> > Any other make (PHONY) target I don't know?
>> >
>>
>> I fell over "clean-dirs"...
>>
>> scripts/package/Makefile:93:clean-dirs += $(objtree)/debian/
>>
>> ...but did not really understood how it works.
>> The main Makefile defines some clean-dirs PHONY#s.
>> I can only speculate, someone with more skillz in Makefile handling
>> should look at this.
>
> It looks like this has not worked for a long time.  The scripts
> directory is not included in the main recursive processes; it seems to
> be special-cased for build and not for clean.  This is partly deliberate
> because clean is supposed to leave 'enough to build external modules'.
> It's not obvious to include scripts/packages/ in clean.
>

[ CCing some more people (submitters to scripts/Makefile.clean) ]

Thanks for your reply and confirmation.

So, how to fix that issue?

Cleanup debian/*tmp dirs within builddeb script for now?

Fix that clean-dirs mechanism (or remove it)?
These 4 Makefile#s use it...

Documentation/DocBook/Makefile
Makefile
scripts/Makefile.clean
scripts/package/Makefile

Any help appreciated.

- Sedat -
