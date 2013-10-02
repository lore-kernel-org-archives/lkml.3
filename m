Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab3JBIiW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 04:38:22 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:45963 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185Ab3JBIiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 04:38:15 -0400
X-AuditID: 9c93016f-b7b39ae0000004eb-e9-524bdb7534aa
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 1/3] perf tools: Separate lbfd check out of NO_DEMANGLE condition
References: <1380221754-29865-1-git-send-email-jolsa@redhat.com>
	<1380292332-6518-1-git-send-email-jolsa@redhat.com>
	<1380437526.1727.10.camel@leonhard>
	<87d2noo4gn.fsf@sejong.aot.lge.com>
	<20131002081757.GA3496@krava.brq.redhat.com>
Date: Wed, 02 Oct 2013 17:38:13 +0900
In-Reply-To: <20131002081757.GA3496@krava.brq.redhat.com> (Jiri Olsa's message
	of "Wed, 2 Oct 2013 10:17:57 +0200")
Message-ID: <87li2cm5je.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Wed, 2 Oct 2013 10:17:57 +0200, Jiri Olsa wrote:
> On Wed, Oct 02, 2013 at 10:18:32AM +0900, Namhyung Kim wrote:
>> It seems that it needs libdl for loading plugins.  Adding -ldl makes
>> above build successfully.  So we need to add -ldl for EXTLIBS IMHO.
>> Without it, make NO_GTK2=1 NO_LIBPERL=1 NO_LIBPYTHON=1 will fail to
>> check libbfd correctly (FYI, libperl and libpython add -ldl to the
>> dependency list).
>
> hum, so on my system -liberty check wins without -lbfd,
> so 'NO_GTK2=1 NO_LIBPERL=1 NO_LIBPYTHON=1' passes
>
> I need to check Ingo's latest changes on this, not sure how
> if this problem is relevant any longer ;-)

AFAICS, Ingo's patch does "-lbfd -ldl" rather than "-lbfd".  So probably
there's no problem then. :)

Thanks,
Namhyung
