Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152AbaFIVE4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 17:04:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44514 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223AbaFIVEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 17:04:53 -0400
Message-ID: <5396216F.9000804@suse.cz>
Date: Mon, 09 Jun 2014 23:04:47 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Yann Droneaud <ydroneaud@opteya.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Sam Ravnborg <sam@ravnborg.org>,
        Joonsoo Kim <js1304@gmail.com>, Alexey Dobriyan <adobriyan@gmail.com>,
        Ian Campbell <ijc@hellion.org.uk>, Jiri Slaby <jirislaby@gmail.com>,
        linux-kernel@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?UTF-8?B?SGFucy1CZXJuaGFyZCBCcsO2a2Vy?= 
	<broeker@users.sourceforge.net>,
        Hans-Bernhard Broeker <broeker@physik.rwth-aachen.de>,
        Neil Horman <nhorman@users.sourceforge.net>,
        Neil Horman <nhorman@tuxdriver.com>, Gerhard Sittig <gsi@denx.de>,
        Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: [PATCH] scripts/tags.sh: ignore symlink'ed source files
References: <1396530975.4361.28.camel@localhost.localdomain> <20140407104216.GB5287@hmsreliant.think-freely.org> <20140407124259.GZ11339@book.gsilab.sittig.org> <20140407153647.GA17258@hmsreliant.think-freely.org> <534312F8.5090609@t-online.de> <20140408075610.GJ11339@book.gsilab.sittig.org> <20140408104959.GA26003@hmsreliant.think-freely.org> <1398993559.23822.1.camel@concordia> <1400679137-28122-1-git-send-email-ydroneaud@opteya.com>
In-Reply-To: <1400679137-28122-1-git-send-email-ydroneaud@opteya.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 21.5.2014 15:32, Yann Droneaud napsal(a):
> Since commit 22d651dcef536c75f75537290bf3da5038e68b6b ('selftests/powerpc:
> Import Anton's memcpy / copy_tofrom_user tests'), some source files in the
> tree appear as symlink.
> Until commit 8c38a5328af8080bc69a25b3e4e144b03eeea95e ('scripts/tags.sh:
> ignore code of user space tools'), those symlinks made cscope report some
> warnings:
> 
>     $ make ALLSOURCE_ARCHS=all O=./obj-cscope/ cscope
>       GEN     cscope
>     cscope: cannot find
> file .../tools/testing/selftests/powerpc/copyloops/copyuser_power7.S
>     cscope: cannot find
> file .../tools/testing/selftests/powerpc/copyloops/memcpy_64.S
>     cscope: cannot find
> file .../tools/testing/selftests/powerpc/copyloops/memcpy_power7.S
>     cscope: cannot find
> file .../tools/testing/selftests/powerpc/copyloops/copyuser_64.S
> 
> In order to prevent the same kind of warnings to be triggered by future
> addition of symlinks, the best option is to ignore all symlinks when
> building the file list to be processed by cscope (and other tools
> supported by scripts/tags.sh).
> 
> Ignoring symlinks won't hide source files from cscope (and others) as the
> target of these symlinks already appear somewhere else in the tree, and,
> as such, should be processed by cscope (or others).
> 
> Note that, cscope, when used with -R option to make it find the files to
> process by itself, already skip symlinks: it's not expected that cscope
> access source files through symlink.
> 
> On top of commit 8c38a5328af8080bc69a25b3e4e144b03eeea95e ('scripts/tags.sh:
> ignore code of user space tools'), scripts/tags.sh output from
> "make cscope tags TAGS" is the same with and without this patch: it doesn't
> seems to introduce any regression (on Fedora 20).
> 
> Link: http://lkml.kernel.org/r/1396530975.4361.28.camel@localhost.localdomain
> Link: http://mid.gmane.org/534312F8.5090609@t-online.de
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Anton Blanchard <anton@samba.org>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Hans-Bernhard Bröker <broeker@users.sourceforge.net>,
> Cc: Hans-Bernhard Broeker <broeker@physik.rwth-aachen.de>,
> Cc: Neil Horman <nhorman@users.sourceforge.net>
> Cc: Neil Horman <nhorman@tuxdriver.com>
> Cc: Gerhard Sittig <gsi@denx.de>
> Cc: Konstantin Khlebnikov <koct9i@gmail.com>
> Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>

Applied to kbuild.git#misc, thanks.

Michal

