Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933523AbaD2Agb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 20:36:31 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:60293 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932969AbaD2Ag1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 20:36:27 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jean Pihet <jean.pihet@linaro.org>
Subject: Re: [PATCH 1/3] perf tools: Cache register accesses for unwind processing
References: <1397756352-26694-1-git-send-email-jolsa@redhat.com>
	<1397756352-26694-2-git-send-email-jolsa@redhat.com>
	<1398608961.1689.9.camel@leonhard>
	<20140428094826.GD1109@krava.brq.redhat.com>
	<1398690175.1724.5.camel@leonhard>
	<20140428132420.GD18628@krava.brq.redhat.com>
Date: Tue, 29 Apr 2014 09:36:19 +0900
In-Reply-To: <20140428132420.GD18628@krava.brq.redhat.com> (Jiri Olsa's
	message of "Mon, 28 Apr 2014 15:24:20 +0200")
Message-ID: <87ha5dotto.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2014 15:24:20 +0200, Jiri Olsa wrote:
> On Mon, Apr 28, 2014 at 10:02:55PM +0900, Namhyung Kim wrote:
>> Hi Jiri,
>> 
>> 2014-04-28 (월), 11:48 +0200, Jiri Olsa:
>> > On Sun, Apr 27, 2014 at 11:29:21PM +0900, Namhyung Kim wrote:
>> > > Hi Jiri,
>> > > 
>> > > 2014-04-17 (목), 19:39 +0200, Jiri Olsa:
>> > > > Caching registers value into an array. Got about 4% speed up
>> > > > of perf_reg_value function for report command processing
>> > > > dwarf unwind stacks.
>> > > 
>> > > I'm not familiar with the code base, so probably silly questions:  Where
>> > > does the speed up come from?  IOW I don't know what's the difference
>> > > between the regs->regs and regs->cached_regs.  And does the cached_regs
>> > > contain correct values of registers for each frame?
>> > 
>> > the current way register's value is accessed is to get its
>> > index in the sample's regs array.. based on register's id
>> > and the registers mask
>> > 
>> > so each time you want register value you traverse the registers
>> > mask and count reg's index for the sample regs array
>> > 
>> > this patch does this only once for each register (at the time it's
>> > first accessed) and cache its value in the array (cache_regs). The
>> > cache_mask is used to identify which regs are already cached.
>> 
>> That means it'll get the same value everytime it accesses a register in
>> frames in a sample?
>
> right..

Hmm.. I thought it'd be changed somehow as it unwinds frames.

Thanks,
Namhyung
