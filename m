Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817AbaHSGJt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 02:09:49 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:40810 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589AbaHSGJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 02:09:48 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Stephane Eranian <eranian@google.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 2/2] perf top: Handle 'z' key for toggle zeroing samples in TUI
References: <1407831366-28892-1-git-send-email-namhyung@kernel.org>
	<1407831366-28892-2-git-send-email-namhyung@kernel.org>
	<CABPqkBRirVbT05OhS4CVedpzt44hGijFSgdL+4XqjVW-ixcp7g@mail.gmail.com>
	<20140813203739.GL2718@kernel.org>
	<CABPqkBTLgcoDvL9stCOpa7tE3eobN0Us5pfquWKGRy-d88cvjg@mail.gmail.com>
Date: Tue, 19 Aug 2014 15:09:47 +0900
In-Reply-To: <CABPqkBTLgcoDvL9stCOpa7tE3eobN0Us5pfquWKGRy-d88cvjg@mail.gmail.com>
	(Stephane Eranian's message of "Wed, 13 Aug 2014 22:47:43 +0200")
Message-ID: <878umlc8no.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Aug 2014 22:47:43 +0200, Stephane Eranian wrote:
> On Wed, Aug 13, 2014 at 10:37 PM, Arnaldo Carvalho de Melo
> <acme@kernel.org> wrote:
>>
>> Em Wed, Aug 13, 2014 at 01:07:30AM +0200, Stephane Eranian escreveu:
>> > On Tue, Aug 12, 2014 at 10:16 AM, Namhyung Kim <namhyung@kernel.org> wrote:
>> > > The perf top TUI lacks 'z' key support to toggle sample zeroing.
>> > > Add it.
>> > >
>> > Works for me.
>> > Tested-by: Stephane Eranian <eranian@google.com>
>>
>> One thing that can be improved: Make it trigger a refresh in the right
>> after 'z' is pressed.
>>
>> Also, this toggles the zeroing before each sample, it would be nice to
>> have a visual cue that this is in effect, probably in the first line in
>> the screen, perhaps on the far right, something like [z] when this is in
>> effect and nothing when not.
>>
> I agree. Had to run a test on the side to verify that it was actually doing
> the right thing.
>
>>
>> Right now the way to figure this out is to observe the number of
>> samples, if it increases monotonically, zeroing before refresh is not in
>> effect, if it goes from a high number to a smaller or vice versa,
>> zeroing is in effect :-)
>>
>> Anyway, applied, people wanting this feature can figure this out, what I
>> suggested is just polishing.
>>
> We need to visual cue.

Got it.  Will add [z] on the header line.

Thanks,
Namhyung
