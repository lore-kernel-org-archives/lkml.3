Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546AbaG1AHA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 20:07:00 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:43063 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbaG1AG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 20:06:57 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Thomas Ilsche <thomas.ilsche@tu-dresden.de>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 2/2] perf tools: Default to python version 2
References: <53D135F9.1070104@tu-dresden.de>
	<1406258045-25726-1-git-send-email-namhyung@kernel.org>
	<1406258045-25726-2-git-send-email-namhyung@kernel.org>
	<53D22357.9010005@tu-dresden.de> <87wqb1ivnb.fsf@sejong.aot.lge.com>
	<53D242DC.9070503@tu-dresden.de>
Date: Mon, 28 Jul 2014 09:06:54 +0900
In-Reply-To: <53D242DC.9070503@tu-dresden.de> (Thomas Ilsche's message of
	"Fri, 25 Jul 2014 13:43:24 +0200")
Message-ID: <87silmibxd.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Fri, 25 Jul 2014 13:43:24 +0200, Thomas Ilsche wrote:
> Hi Namhyung,
>
> apologies for mixing up your first name earlier.

It's okay, nevermind. :)


> On 2014-07-25 12:24, Namhyung Kim wrote:
>> On Fri, 25 Jul 2014 11:28:55 +0200, Thomas Ilsche wrote:
>>>  ifndef NO_LIBPYTHON
>>> -  override PYTHON := \
>>> -    $(call get-executable-or-default,PYTHON,python)
>>> +  PYTHON2 := $(call get-executable-or-default,PYTHON,python2)
>> 
>> But wouldn't it set PYTHON2 to python2 even if the system doesn't have
>> python2 actually?
>> 
>> 
>>> +  override PYTHON := $(if $(PYTHON2),$(PYTHON2),$(call get-executable,python))
>> 
>> And then it'll set PYTHON to python2, no?
>> 
>
> No, get-executable-or-default only returns anything if it is an actual executable
> (asserted by a 'command -v' and 'test -f $ -a -x $'). At least this is how I understand
> the Makefile code. I also tested it with a Python 2.6.9 (no python2 in path) and it worked
> (after fixing some totally unrelated issues in python headers). It will however complain
> that "The path 'python2' is not executable." before using python.

Yeah, that's annoying.


>
>> 
>>>    override PYTHON_CONFIG := \
>>>      $(call get-executable-or-default,PYTHON_CONFIG,$(PYTHON)-config)
>> 
>> 
>> I'm thinking about something like below.. but sadly it doesn't work for
>> me.. hmm.
>
> Actually this appears to work for me (with 2.6.9 & 2.7.6) and I find this solution more
> elegant.

Thanks for testing.  It was my fault on setting symlink to a
non-existing file for testing.  It now works well for me too.

Can I add your Tested-by then?

Thanks,
Namhyung
