Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827Ab3LJD6b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 22:58:31 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:64067 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763Ab3LJD62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 22:58:28 -0500
Date: Mon, 9 Dec 2013 22:58:46 -0500 (EST)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Namhyung Kim <namhyung@kernel.org>
cc: Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org,
        Chad Paradis <chad.paradis@umit.maine.edu>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [patch] perf tools: perf list broken on ARM
In-Reply-To: <87iouxjvz6.fsf@sejong.aot.lge.com>
Message-ID: <alpine.DEB.2.10.1312092250020.6229@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1312091646100.2337@vincent-weaver-1.um.maine.edu> <87iouxjvz6.fsf@sejong.aot.lge.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Dec 2013, Namhyung Kim wrote:

> Hi Vince,
> Okay, the reason I set the bit was consideration of a very strict
> perf_event_paranoid setting (-2).
> 
> So maybe we can try it again with the bit cleared after a failure, or
> checking the paranoid setting first.

If perf_event_paranoid is set to 2 then you should get EPERM rather than 
ENOENT or EINVAL, right?  Maybe that could be used too.

As a side note, why doesn't paranoid 2 block events that don't have
exclude_hv set?

Vince
