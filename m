Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897Ab3KAHvW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 03:51:22 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:51364 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399Ab3KAHvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 03:51:19 -0400
X-AuditID: 9c93017d-b7cd3ae000007ab3-7d-52735d75edb2
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Michael Hudson-Doyle <michael.hudson@linaro.org>,
        linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Will Deacon <will.deacon@arm.com>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH] perf tools: Remove cast of non-varadic function to varadic
References: <877gctxlry.fsf@canonical.com>
	<20131031200950.GA5949@infradead.org>
Date: Fri, 01 Nov 2013 16:51:17 +0900
In-Reply-To: <20131031200950.GA5949@infradead.org> (Arnaldo Carvalho de Melo's
	message of "Thu, 31 Oct 2013 18:09:50 -0200")
Message-ID: <87mwlo4l1m.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo and Michael,

On Thu, 31 Oct 2013 18:09:50 -0200, Arnaldo Carvalho de Melo wrote:
> Em Thu, Oct 31, 2013 at 12:50:25PM -0700, Michael Hudson-Doyle escreveu:
>> 4fb71074a570 (perf ui/hist: Consolidate hpp helpers) introduced a cast of
>> percent_color_snprintf to a function pointer type with varargs.  Change
>> percent_color_snprintf to be varadic and remove the cast.
>> 
>> The symptom of this was all percentages being reported as 0.00% in perf
>> report --stdio output on armhf.
>
> git bisect + visual inspection, right? Anyway, good catch, interesting
> it caused problems on just one arch, or have you tested this in other
> arches?
>
> Namhyung?

Yes, it'll affect the way of passing parameter on some arch's -  I only
tested it on x86_64.  So,

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung
