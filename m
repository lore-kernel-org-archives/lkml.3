Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab3A3CP6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 21:15:58 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:63405 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518Ab3A3CP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 21:15:56 -0500
X-AuditID: 9c93016f-b7b70ae000000e36-ab-5108825b040f
From: Namhyung Kim <namhyung@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Thomas Backlund <tmb@mageia.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: perf 3.8-rc build failure:  undefined reference to `strlcpy'
References: <51074E9D.3040803@mageia.org> <20130129103722.GE14444@pd.tnic>
Date: Wed, 30 Jan 2013 11:15:55 +0900
In-Reply-To: <20130129103722.GE14444@pd.tnic> (Borislav Petkov's message of
	"Tue, 29 Jan 2013 11:37:22 +0100")
Message-ID: <87ehh3v2jo.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Borislav,

On Tue, 29 Jan 2013 11:37:22 +0100, Borislav Petkov wrote:
> On Tue, Jan 29, 2013 at 06:22:53AM +0200, Thomas Backlund wrote:
>> 
>> [tmb@tmb linux-3.8-rc5]$ make -C tools/perf -s V=1
>> HAVE_CPLUS_DEMANGLE=1 prefix=%{_prefix} all
>> 
>> ...
>> 
>> /tmp/ccJEJv6m.o: In function `main':
>> :(.text+0x14): undefined reference to `strlcpy'
>> collect2: ld returned 1 exit status
>> 
>> ...
>> 
>> This did not show up in 3.7
>
> Ditto here:
>
> /tmp/ccC1kLwn.o: In function `main':
> :(.text+0x14): undefined reference to `strlcpy'
> collect2: error: ld returned 1 exit status
>
> Someone needs to get HAVE_STRLCPY and tools/perf/util/path.c in order so
> that the linker sees it, IMHO.

Please see my reply on another post from Thomas:

  https://lkml.org/lkml/2013/1/29/32


It's not like a build failure of perf tools, it's just a result of
feature test so should not affect the build of perf itself, right?  Why
it confuses us is that we don't show any compile message if -s option is
given to make, so I posted a patch to hide CHK and above failure message
when -s option is specified.

Thanks,
Namhyung
