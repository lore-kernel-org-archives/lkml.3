Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751775AbaKYVXT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 16:23:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54067 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751366AbaKYVXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 16:23:15 -0500
Message-ID: <5474F33F.2030402@suse.cz>
Date: Tue, 25 Nov 2014 22:23:11 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Masahiro Yamada <yamada.m@jp.panasonic.com>
CC: Sam Ravnborg <sam@ravnborg.org>, linux-kbuild@vger.kernel.org,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: collect shorthands into the top Makefile
References: <1414567651-2503-1-git-send-email-yamada.m@jp.panasonic.com> <20141029185907.GA701@ravnborg.org> <20141031111254.8FF3.AA925319@jp.panasonic.com>
In-Reply-To: <20141031111254.8FF3.AA925319@jp.panasonic.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 31.10.2014 v 03:12 Masahiro Yamada napsal(a):
> Hi Sam,
> 
> On Wed, 29 Oct 2014 19:59:07 +0100
> Sam Ravnborg <sam@ravnborg.org> wrote:
> 
>> On Wed, Oct 29, 2014 at 04:27:31PM +0900, Masahiro Yamada wrote:
>>> The motivation of this commit is to avoid duplicated definitions
>>> of "clean" and "hdr-inst" shorthands.
>>>
>>> The shorthand "clean" is defined in both the top Makefile and
>>> scripts/Makefile.clean.
>>>
>>> Likewise, "hdr-inst" is defined in both the top Makefile and
>>> scripts/Makefile.headersinst.
>>>
>>> The idea here is define and export them in the top Makefile
>>> because $(srctree) is constant during the build process.
>>>
>>> For consistency, "build" and "modbuiltin" should be also moved.
>>
>> As a general rule the exported names are always UPPERCASE, and local variables
>> are lowercase. (srctree, objtree are the exceptions).
>> This patch define new lowercase variables that conflicts with this.
>>
>> And it is not that logical these are picked up from the enviroment.
>> Could you find a central place to define them rahter than using
>> the environemnt to export them?
> 
> Maybe we can collect them into scripts/Kbuild.include
> although it might be too much for Makefile.clean to include
> the whole things in Kbuild.include.

Kbuild.include sounds like a good idea to me. It would also allow to
de-duplicate the $(cmd) defition in Makefile.include.

BTW:
$ time -p make $(perl -e 'print "-f scripts/Kbuild.include "x1500')
make: *** No targets.  Stop.
real 0.44
user 0.18
sys 0.08

So 0.44s in total for the 1500 or so subdirectories we visit during make
clean. But the subprocesses can run in parallel, so the real difference
is negligible.

Michal
