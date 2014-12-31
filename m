Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585AbaLaOWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 09:22:18 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:36057 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbaLaOWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 09:22:16 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <54A40077.1080806@suse.cz>
References: <CA+icZUXPt=GM08PD8LOpCdxCYhNMrr-2MHxPyNRWPXqUjQXFrw@mail.gmail.com>
	<CA+icZUVfiQ1+k2zD9HXMM40N8rwg6rEmYLdKfHGsGt3xvJu+4w@mail.gmail.com>
	<1419619556.4705.136.camel@decadent.org.uk>
	<54A40077.1080806@suse.cz>
Date: Wed, 31 Dec 2014 15:16:34 +0100
Message-ID: <CA+icZUWzEpgoQO8MEVF2PWOy-bQ9oYMdipBe3T+s2Os4tzKVZw@mail.gmail.com>
Subject: Re: deb-pkg: Cleaning of debian/*tmp files when running 'make (dist)clean'
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Ben Hutchings <ben@decadent.org.uk>, maximilian attems <max@stro.at>,
        LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 31, 2014 at 2:56 PM, Michal Marek <mmarek@suse.cz> wrote:
> On 2014-12-26 19:46, Ben Hutchings wrote:
>> On Fri, 2014-12-26 at 13:43 +0100, Sedat Dilek wrote:
>>> On Fri, Dec 26, 2014 at 1:02 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>>> [...]
>>>>
>>>> Any other make (PHONY) target I don't know?
>>>>
>>>
>>> I fell over "clean-dirs"...
>>>
>>> scripts/package/Makefile:93:clean-dirs += $(objtree)/debian/
>>>
>>> ...but did not really understood how it works.
>>> The main Makefile defines some clean-dirs PHONY#s.
>>> I can only speculate, someone with more skillz in Makefile handling
>>> should look at this.
>>
>> It looks like this has not worked for a long time.  The scripts
>> directory is not included in the main recursive processes; it seems to
>> be special-cased for build and not for clean.
>
> It is special-cased for mrproper and thus distclean:
>
>   mrproper-dirs      := $(addprefix _mrproper_,Documentation/DocBook
> scripts)
>
> The problem is that
>
>   clean-dirs += $(objtree)/debian/
>
> results in
>
>   clean-dirs += ./debian/
>
> and scripts/Makefile.clean treats it as relative to scripts/package.
>

Thanks for your reply.

IIRC I looked through some commits touching this area.
>From your description, is the simplification ("kbuild: simplify build,
clean, modbuiltin shorthands") in [1] the cause for this?

[ I haven't tried to revert it, returned home today, still looking
through my inbox :-). ]

- Sedat -

[1] http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/scripts/Makefile.clean?id=5b2389b45d1a9c12b9f4b976e38c36264bfc42f5
