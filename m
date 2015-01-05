Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424AbbAEShu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 13:37:50 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:40359 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754347AbbAEShq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 13:37:46 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <54A3FFCA.9030501@suse.cz>
References: <CA+icZUXPt=GM08PD8LOpCdxCYhNMrr-2MHxPyNRWPXqUjQXFrw@mail.gmail.com>
	<CA+icZUVfiQ1+k2zD9HXMM40N8rwg6rEmYLdKfHGsGt3xvJu+4w@mail.gmail.com>
	<1419619556.4705.136.camel@decadent.org.uk>
	<54A3FFCA.9030501@suse.cz>
Date: Mon, 5 Jan 2015 19:37:45 +0100
Message-ID: <CA+icZUWnr7_A4FbYOYyS6CVeK-Cu2AaviHF48Xfq02J72aFP9g@mail.gmail.com>
Subject: Re: deb-pkg: Cleaning of debian/*tmp files when running 'make (dist)clean'
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Ben Hutchings <ben@decadent.org.uk>, maximilian attems <max@stro.at>,
        LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 31, 2014 at 2:53 PM, Michal Marek <mmarek@suse.cz> wrote:
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
> It actually is special-cased for mrproper, which is a subset if
> distclean. The real problem is that
>
> clean-dirs += $(objtree)/debian/
>
> expands to
>
> clean-dirs += ./debian/
>
> and scripts/Makefile.clean things that this is relative to the
> scripts/package directory.
>
> Michal

For the sake of completeness... Issue fixed by...

commit a16c5f99a28c9945165c46da27fff8e6f26f8736
"kbuild: Fix removal of the debian/ directory"

- Sedat -

[1] http://git.kernel.org/cgit/linux/kernel/git/mmarek/kbuild.git/commit/?h=rc-fixes&id=a16c5f99a28c9945165c46da27fff8e6f26f8736
