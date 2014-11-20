Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042AbaKTGSr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 01:18:47 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:60487 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbaKTGSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 01:18:45 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: kan.liang@intel.com, jolsa@redhat.com, linux-kernel@vger.kernel.org,
        ak@linux.intel.com
Subject: Re: [PATCH V4 3/3] perf tool: Add sort key symoff for perf diff
References: <1416328700-1836-1-git-send-email-kan.liang@intel.com>
	<1416328700-1836-4-git-send-email-kan.liang@intel.com>
	<20141118211319.GD3790@kernel.org>
Date: Thu, 20 Nov 2014 15:18:44 +0900
In-Reply-To: <20141118211319.GD3790@kernel.org> (Arnaldo Carvalho de Melo's
	message of "Tue, 18 Nov 2014 18:13:19 -0300")
Message-ID: <87a93mpf7f.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Nov 2014 18:13:19 -0300, Arnaldo Carvalho de Melo wrote:
> Em Tue, Nov 18, 2014 at 11:38:20AM -0500, kan.liang@intel.com escreveu:
>> From: Kan Liang <kan.liang@intel.com>
>> 
>> Sometime, especially debugging scaling issue, the function level diff
>> may be high granularity. The user may want to do deeper diff analysis
>> for some cache or lock issue. The "symoff" key can let the user sort
>> differential profile by ips. This feature should only work when the
>> perf.data comes from same binary.
>
> So, to avoid having people scratching heads, and since we have the
> build-id for both perf.data files, hence for both binaries being
> compared, can we check the build ids and either refuse to do the diff or
> print a big warning about different binaries being compared?

Why do you think so?  I think it's fine to use symoff for different
binaries for same reason as the symbol sort key.  Even if some functions
were changed, other DSOs and/or functions still have same offset and
thus have meaningful diff result IMHO.

Thanks,
Namhyung
