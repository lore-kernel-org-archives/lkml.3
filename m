Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797Ab3ENA4I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 20:56:08 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:61561 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755657Ab3ENA4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 20:56:06 -0400
X-AuditID: 9c930197-b7b76ae000003523-21-51918ba44a32
From: Namhyung Kim <namhyung@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/2] perf report: Add --percent-limit option
References: <1368434503-29373-1-git-send-email-namhyung@kernel.org>
	<20130513141117.GC17814@two.firstfloor.org>
Date: Tue, 14 May 2013 09:56:04 +0900
In-Reply-To: <20130513141117.GC17814@two.firstfloor.org> (Andi Kleen's message
	of "Mon, 13 May 2013 16:11:17 +0200")
Message-ID: <87hai65qhn.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On Mon, 13 May 2013 16:11:17 +0200, Andi Kleen wrote:
> On Mon, May 13, 2013 at 05:41:42PM +0900, Namhyung Kim wrote:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>> 
>> The --percent-limit option is for not showing small overheaded entries
>> in the output.  Maybe we want to set a certain default value like 0.1.
>> 
>> Cc: Andi Kleen <andi@firstfloor.org>
>
> I like the option, but 0 is not a good default.
> Make it 1 or something.

Thanks.  I just wanted to reserve same behavior since I didn't know
what's the reasonable default value.  We might use a config variable for
this to customize the default value.

>
> Perhaps a better heuristic would be 
> percent < threshold || samples < sample-threshold
> with sample-threshold being several hundred at least.
>
> A very small number of hits on something is usually quite much useless,
> unless your original event was extremly rare in the beginning
> (but then it's unclear if the profile is any useful)

Looks reasonable, but I know there's also some users who use the perf
tools lightly.  A several hundreds sample-threshold looks too harsh to
them IMHO.  In addition, it should handle tracepoints.

Thanks,
Namhyung
