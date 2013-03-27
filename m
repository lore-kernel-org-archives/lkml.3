Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab3C0GMj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 02:12:39 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:59390 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab3C0GMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 02:12:38 -0400
X-AuditID: 9c930197-b7c9dae000006959-bc-51528dd2553d
From: Namhyung Kim <namhyung@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] perf sort: Add 'addr' sort key
References: <1364299918-31175-1-git-send-email-namhyung@kernel.org>
	<20130326144023.GA1621@gmail.com>
Date: Wed, 27 Mar 2013 15:12:34 +0900
In-Reply-To: <20130326144023.GA1621@gmail.com> (Ingo Molnar's message of "Tue,
	26 Mar 2013 15:40:23 +0100")
Message-ID: <87ehf1gylp.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Tue, 26 Mar 2013 15:40:23 +0100, Ingo Molnar wrote:
> * Namhyung Kim <namhyung@kernel.org> wrote:
>
>> From: Namhyung Kim <namhyung.kim@lge.com>
>> 
>> New addr sort key provides a way to sort the entries by the symbol
>> addresses.
>
> No objections from me - just wondering about the motivation: why would we 
> want to sort by symbol address?

In fact, it came from bugzilla:

  https://bugzilla.kernel.org/show_bug.cgi?id=55561

>
> Perhaps to see the overhead layout/distribution within a DSO, to better 
> cache-pack hot functions by placing them next to each other?
>
> Putting a short usecase into the changelog (or even better, the 
> documentation) would be nice.

Well, I didn't thought it much, but yeah, aforementioned usecase looks
promising.  Also it might be useful to find out which part is the
hotpath in a function if you have some really big functions (possibly
due to auto-inlining or something).

Arnaldo, do you have other usecase/scenario in mind?

Thanks,
Namhyung
