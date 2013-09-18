Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010Ab3IRSdz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 14:33:55 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:58011 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606Ab3IRSdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 14:33:54 -0400
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <20130918154224.GK9326@twins.programming.kicks-ass.net>
References: <1372425741-1676-2-git-send-email-adrian.hunter@intel.com>
	<tip-860f085b74e9f0075de8140ed3a1e5b5e3e39aa8@git.kernel.org>
	<alpine.DEB.2.02.1309171617400.13303@pianoman.cluster.toy>
	<20130918085722.GL12926@twins.programming.kicks-ass.net>
	<alpine.DEB.2.02.1309181013100.23210@pianoman.cluster.toy>
	<20130918154224.GK9326@twins.programming.kicks-ass.net>
Date: Wed, 18 Sep 2013 20:33:53 +0200
Message-ID: <CAMsRxfKRp5DRzCL54fzxLf02pNbBsA_61-LUBFTmbuL=L8QqzQ@mail.gmail.com>
Subject: Re: [tip:perf/core] perf: Fix broken union in ' struct perf_event_mmap_page'
From: Stephane Eranian <eranian@googlemail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vince Weaver <vince@deater.net>, Ingo Molnar <mingo@kernel.org>,
        Peter Anvin <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        adrian.hunter@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 18, 2013 at 5:42 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, Sep 18, 2013 at 10:19:32AM -0400, Vince Weaver wrote:
>> Can you point to any code that is fixed by the commit?
>
> I have some, but I don't think a lot of people use it.
>
> Would you be ok with something like the below? It should preserve
> functionality for code that only cares about cap_usr_rdpmc (PAPI).
>
> Stephane, does libpfm use any of these?
>
Yes, there is an example using this. Need to verify it is not broken
currently (self_count.c).

> --- a/include/uapi/linux/perf_event.h
> +++ b/include/uapi/linux/perf_event.h
> @@ -380,8 +380,8 @@ struct perf_event_mmap_page {
>         union {
>                 __u64   capabilities;
>                 struct {
> -                       __u64   cap_usr_time            : 1,
> -                               cap_usr_rdpmc           : 1,
> +                       __u64   cap_usr_rdpmc           : 1,
> +                               cap_usr_time            : 1,
>                                 cap_usr_time_zero       : 1,
>                                 cap_____res             : 61;
>                 };
