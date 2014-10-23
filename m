Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbaJWI6F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 04:58:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54957 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753894AbaJWI57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 04:57:59 -0400
Message-ID: <5448C315.9000001@suse.cz>
Date: Thu, 23 Oct 2014 10:57:57 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Masahiro Yamada <yamada.m@jp.panasonic.com>,
        Peter Foley <pefoley2@pefoley.com>, linux-kbuild@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] kbuild: Fix output of make kernelrelease
References: <20141022101944.70d637cc@gandalf.local.home>	<20141022194408.GA20989@pobox.suse.cz> <20141022211115.576b0053@gandalf.local.home>
In-Reply-To: <20141022211115.576b0053@gandalf.local.home>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-10-23 03:11, Steven Rostedt wrote:
> On Wed, 22 Oct 2014 21:44:08 +0200
> Michal Marek <mmarek@suse.cz> wrote:
> 
>> Dne 22.10.2014 v 16:19 Steven Rostedt napsal(a):
>>>
>>> Commit 7ff525712acf "kbuild: fake the "Entering directory ..." message
>>> more simply" changed the output of "make kernelrelease" such that the
>>> kernel release version was not the last line printed. This broke various
>>> tools that would find the kernel release with "make kernelrelease | tail -1".
>>
>> The cleaner and recommended (see recent make help) way is to use make -s:
>>
>> $ make O=build -s kernelrelease
>> 3.18.0-rc1+
>>
>> no further processing is needed.
> 
> 
> I don't mind changing my script with your patch. But this does break
> other scripts of mine that I need to hunt down and change. My fear is
> why do we need the '-s' when there may be other methods to preserve the
> old functionality.

If you have scripts that only do x=$(make kernelrelease), then you
should definitely fix them. You are right that the make kernelrelease |
tail -1 trick had always been working until 7ff525712acf, so I can apply
your patch. But please fix ktest.pl so that it's consistent with what
the help text says. Also, the Makefile patch should cover kernelversion
and image_name as well.

Michal
