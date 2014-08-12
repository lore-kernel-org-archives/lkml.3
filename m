Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523AbaHLHRG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 03:17:06 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:56803 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410AbaHLHRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 03:17:03 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 8/8] perf symbol: Don't demangle parameters and such by default
References: <1406785662-5534-1-git-send-email-namhyung@kernel.org>
	<1406785662-5534-9-git-send-email-namhyung@kernel.org>
	<20140802133503.GE13375@kernel.org>
	<87mwbbfnj2.fsf@sejong.aot.lge.com> <20140811133223.GC3277@kernel.org>
Date: Tue, 12 Aug 2014 16:17:01 +0900
In-Reply-To: <20140811133223.GC3277@kernel.org> (Arnaldo Carvalho de Melo's
	message of "Mon, 11 Aug 2014 10:32:23 -0300")
Message-ID: <87egwmfa8i.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

On Mon, 11 Aug 2014 10:32:23 -0300, Arnaldo Carvalho de Melo wrote:
> Em Mon, Aug 11, 2014 at 05:17:37PM +0900, Namhyung Kim escreveu:
>> On Sat, 2 Aug 2014 10:35:03 -0300, Arnaldo Carvalho de Melo wrote:
>> > Em Thu, Jul 31, 2014 at 02:47:42PM +0900, Namhyung Kim escreveu:
>> >> Some C++ symbols have very long name and they make column length
>> >> longer.  Most of them are about parameters including templates and we
>> >> can ignore such info most of time IMHO.
>
>> >> This patch passes DMGL_NO_OPTS by default when calling bfd_demangle().
>> >> One can still see full symbols with -v/--verbose option.
>
>> >> before:
>> >>   JS_CallFunctionValue(JSContext*, JSObject*, JS::Value, unsigned int, JS::Value*, JS::Value*)
>
>> >> after:
>> >>   JS_CallFunctionValue
>
>> > Are you sure we want that?
>
>> > With this we'll end up having different instantiations having the same
>> > name, since the way to differentiate them is exactly by a different
>> > parameter list, no?
>> 
>> Right, but I think it's not a big problem since such overloaded
>> functions will not be shown at the same time as only one of them might
>> do the real work most cases.  Simply noticing one of them is a
>
> But then only someone that has deep knowledge of the code in question
> will figure that out from just the function name.
>
> A way to toggle that, starting with a sane value, in this case probably
> not showing the parameter listing due to it being overly long would be
> ideal.
>
> Perhaps I can process this patch now and leave this toggling of things
> that --verbose shows to a second patchset, where this and
> --show-total-period, --show-nr-samples, --hide-unresolved, even
> annotation stuff needs to be on-the-fly togglable, like
> --disassembly-style.
>
>> performance bottle neck would be helpful to the developer, I guess.
>> Even if it's not the case, one still can see and identify the correct
>> one using the -v option.
>  
>> For me, it's just annoying when (unimportant) C++ symbols occupy too
>> much space in a limited terminal width.
>
> What is annoying/unimportant to a person may be the missing detail for
> someone else.
>
> Not having to restart a possibly long top/report session from scratch
> looks like a nice feature to have.
>
> I'll take the patch, its just one more thing that gets in the --verbose
> grab bag till we make all on-the-fly togglable.

Thanks, I'll think about the toggling later. :)

Thanks,
Namhyung
