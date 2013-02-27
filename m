Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255Ab3B0Cbn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 21:31:43 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:59833 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755381Ab3B0Cbm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 21:31:42 -0500
X-AuditID: 9c930179-b7b61ae000004061-06-512d700af0af
From: Namhyung Kim <namhyung@kernel.org>
To: li guang <lig.fnst@cn.fujitsu.com>
Cc: Michael Ellerman <michael@ellerman.id.au>, acme@infradead.org,
        linux-kernel@vger.kernel.org, feng.tang@intel.com,
        namhyung.kim@lge.com
Subject: Re: [PATCH 1/2] perf annotate: Fix build with NO_NEWT=1
References: <1361854923-1814-1-git-send-email-michael@ellerman.id.au>
	<87y5ebsb0s.fsf@sejong.aot.lge.com>
	<1361927668.2262.36.camel@liguang.fnst.cn.fujitsu.com>
Date: Wed, 27 Feb 2013 11:31:37 +0900
In-Reply-To: <1361927668.2262.36.camel@liguang.fnst.cn.fujitsu.com> (li
	guang's message of "Wed, 27 Feb 2013 09:14:28 +0800")
Message-ID: <87ppzmsd12.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi li guang,

On Wed, 27 Feb 2013 09:14:28 +0800, li guang wrote:
> 在 2013-02-26二的 18:02 +0900，Namhyung Kim写道：
>> Hi Michael,
>> 
>> On Tue, 26 Feb 2013 16:02:02 +1100, Michael Ellerman wrote:
>> > Commit 18c9e5c "Make it to be able to skip unannotatable symbols" broke
>> > the build with NO_NEWT=1:
>> >
>> >    CC builtin-annotate.o
>> > builtin-annotate.c: In function 'hists__find_annotations':
>> > builtin-annotate.c:161:4: error: duplicate case value
>> > builtin-annotate.c:154:4: error: previously used here
>> > make: *** [builtin-annotate.o] Error 1
>> >
>> > This is because without NEWT support K_LEFT is #defined to -1 in
>> > utils/hist.h
>> >
>> > Fix it by shifting the K_LEFT/K_RIGHT #defines out of the likely range
>> > of error values.
>> 
>> Argh, didn't check NO_NEWT build on this, sorry.
>> 
>> The hist_entry__tui_annotate() - hence, symbol__tui_annotate() - returns
>> either key code or error code.  This is not good IMHO but not sure it's
>> worth refactoring.  Maybe we can move the error check to under default
>> case so that possible future error checks to be done?
>
> or can we skip gui-code-snippet when there's no gui library?
> anyway, for present fix-up, we can just temporarily change K_LEFT value
> like Michael's or my patch, I think.

That part of code won't be run on NO_NEWT build since the 'use_browser'
would be value of 0.  It's just a compilation problem.

Anyway, I have no objection from the both of patches for now.

Thanks,
Namhyung
