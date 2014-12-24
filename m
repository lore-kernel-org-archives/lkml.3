Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751216AbaLXBA7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 20:00:59 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:60379 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbaLXBA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 20:00:58 -0500
Message-ID: <549A1043.30003@hitachi.com>
Date: Wed, 24 Dec 2014 10:00:51 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: Namhyung Kim <namhyung@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ftracetest: Replace usleep with sleep 0.000001
References: <1418186307-1259-1-git-send-email-mpe@ellerman.id.au>  <20141220204213.GA16705@amd> <20141220170725.776363ac@gandalf.local.home>  <20141223042118.GD14960@sejong> <1419318514.32430.1.camel@ellerman.id.au>
In-Reply-To: <1419318514.32430.1.camel@ellerman.id.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/12/23 16:08), Michael Ellerman wrote:
> On Tue, 2014-12-23 at 13:21 +0900, Namhyung Kim wrote:
>> On Sat, Dec 20, 2014 at 05:07:25PM -0500, Steven Rostedt wrote:
>>> On Sat, 20 Dec 2014 21:42:13 +0100
>>> Pavel Machek <pavel@ucw.cz> wrote:
>>>
>>>> On Wed 2014-12-10 15:38:27, Michael Ellerman wrote:
>>>>> usleep is a Fedoraism, it's not generally available on Debian based
>>>>> systems AFAICS.
>>>>>
>>>>> GNU sleep accepts a floating point argument, so use that instead.
>>>>>
>>>>> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
>>>>
>>>> Could ftrace user interface be enhanced not to need random delays?
>>>>
>>>
>>> Not sure what you are talking about. These "random delays" are not for
>>> the interface, but instead to force some events to happen and to make
>>> sure they did.
>>>
>>> As the subject states, this is for "ftracetest" which is the selftests
>>> for ftrace.
>>>
>>> The usleep is basically a "do something to trigger events", and we
>>> don't want to wait long in doing it.
>>
>> Right.  AFAIK what ftracetest expects is a scheduler event so it
>> doesn't need to be the [u]sleep.
> 
> Would /bin/true work in that case?

As other scripts doing, just (echo "forked") would be enough. It forks
sub shell and wait for that.
Please check test.d/kprobe/kprobe_args.tc

Thanks!


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


