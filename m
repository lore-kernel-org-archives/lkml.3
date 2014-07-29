Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682AbaG2GjB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 02:39:01 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:51310 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115AbaG2GjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 02:39:00 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
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
	<53D242DC.9070503@tu-dresden.de> <87silmibxd.fsf@sejong.aot.lge.com>
	<53D62FC9.2010404@tu-dresden.de>
Date: Tue, 29 Jul 2014 15:38:59 +0900
In-Reply-To: <53D62FC9.2010404@tu-dresden.de> (Thomas Ilsche's message of
	"Mon, 28 Jul 2014 13:11:05 +0200")
Message-ID: <877g2wis8s.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Mon, 28 Jul 2014 13:11:05 +0200, Thomas Ilsche wrote:
> Hi Namhyung,
>
>>>> I'm thinking about something like below.. but sadly it doesn't work for
>>>> me.. hmm.
>>>
>>> Actually this appears to work for me (with 2.6.9 & 2.7.6) and I  
>>> find this solution more
>>> elegant.
>>
>> Thanks for testing.  It was my fault on setting symlink to a
>> non-existing file for testing.  It now works well for me too.
>>
>> Can I add your Tested-by then?
>
> Yes
> Tested-by: Thomas Ilsche <thomas.ilsche@tu-dresden.de>
>
> Plase note that your patch requires the previous patch that just set
> the default to python2.

Ah, I'll fix it when sending v2.


>
> I tested in an Arch Linux VM with:
> A) no system install of python, source installation 2.6.9 in PATH
> B) no system install of python, source installation 2.7.6 in PATH
> C) python3 (as python) and python2 system installation
>
> In all cases it reports to build with libpython and perf script with a dummy Python script
> works.
>
> If no python whatsoever is in PATH it reports:
>
> config/Makefile:121: The path 'python' is not executable.
> sh: line 0: command: -c: invalid option
> command: usage: command [-pVv] command [arg ...]
> config/Makefile:122: The path '-config' is not executable.
>
> And the created perf executable does not work with the dummy script.
>
> If only pthon3 is in PATH I get the expected version error message (build stops.)
>
> Note that for the manual old installations of python I had an issue with linking order and
> a -Werror issue that I resolved manually. But this is fixed with the latest system install
> of python.

Thank you a lot for testing and explaining various cases!

Namhyung
