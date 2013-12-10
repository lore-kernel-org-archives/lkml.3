Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751065Ab3LJFIy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 00:08:54 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:43662 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764Ab3LJFIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 00:08:53 -0500
X-AuditID: 9c930197-b7bdbae000000e78-ff-52a6a1e30629
From: Namhyung Kim <namhyung@kernel.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Chad Paradis <chad.paradis@umit.maine.edu>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [patch] perf tools: perf list broken on ARM
References: <alpine.DEB.2.10.1312091646100.2337@vincent-weaver-1.um.maine.edu>
	<87iouxjvz6.fsf@sejong.aot.lge.com>
	<alpine.DEB.2.10.1312092250020.6229@vincent-weaver-1.um.maine.edu>
Date: Tue, 10 Dec 2013 14:08:51 +0900
In-Reply-To: <alpine.DEB.2.10.1312092250020.6229@vincent-weaver-1.um.maine.edu>
	(Vince Weaver's message of "Mon, 9 Dec 2013 22:58:46 -0500 (EST)")
Message-ID: <874n6hjnrw.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Dec 2013 22:58:46 -0500 (EST), Vince Weaver wrote:
> On Tue, 10 Dec 2013, Namhyung Kim wrote:
>
>> Hi Vince,
>> Okay, the reason I set the bit was consideration of a very strict
>> perf_event_paranoid setting (-2).
>> 
>> So maybe we can try it again with the bit cleared after a failure, or
>> checking the paranoid setting first.
>
> If perf_event_paranoid is set to 2 then you should get EPERM rather than 
> ENOENT or EINVAL, right?  Maybe that could be used too.

Ah, yes, it's 2. :)  And it also can use the return value then.

>
> As a side note, why doesn't paranoid 2 block events that don't have
> exclude_hv set?

Hmm.. maybe because it predated the bit?

Thanks,
Namhyung
