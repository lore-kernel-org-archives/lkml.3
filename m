Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab3HVFZV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 01:25:21 -0400
Received: from mail-ph.de-nserver.de ([85.158.179.214]:46953 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469Ab3HVFZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 01:25:19 -0400
X-Fcrdns: No
Message-ID: <5215A0BE.1040903@profihost.ag>
Date: Thu, 22 Aug 2013 07:25:18 +0200
From: Stefan Priebe <s.priebe@profihost.ag>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Kent Overstreet <kmo@daterainc.com>
CC: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-bcache@vger.kernel.org
Subject: Re: bcache: Fix a writeback performance regression
References: <20130814225904.GA6427@kmo-pixel> <520C788A.1060208@profihost.ag> <520DFAB4.1050402@profihost.ag> <52114614.4070509@profihost.ag> <20130819222718.GA32104@kmo-pixel> <52132243.8050803@profihost.ag> <521323D1.1070503@profihost.ag> <20130821234715.GA4630@moria.home.lan>
In-Reply-To: <20130821234715.GA4630@moria.home.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-User-Auth: Auth by s.priebe@profihost.ag through 85.158.179.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 22.08.2013 01:47, schrieb Kent Overstreet:
> On Tue, Aug 20, 2013 at 10:07:45AM +0200, Stefan Priebe - Profihost AG wrote:
>> Am 20.08.2013 10:01, schrieb Stefan Priebe - Profihost AG:
>>> Am 20.08.2013 00:27, schrieb Kent Overstreet:
>>>> On Mon, Aug 19, 2013 at 12:09:24AM +0200, Stefan Priebe wrote:
>>>>>
>>>>> Vanilla 3.10.7 + bcache: Fix a writeback performance regression
>>>>>
>>>>> http://pastebin.com/raw.php?i=LXZk4cMH
>>>>
>>>> Whoops, at first I thought this was the same bug as one I'd already been
>>>> chasing down that had been a harmless bug - turns out I didn't look
>>>> closely enough at the backtrace.
>>>>
>>>> What happened is background writeback is deadlocking, because for some
>>>> reason the workqueue it's running out of is a singlethreaded workqueue,
>>>> so as soon as it decides to queue enough writeback bios that it has to
>>>> sleep on that semaphore (which often won't happen due to the PD
>>>> controller based ratelimiting) - boom, deadlock.
>>>>
>>>> Here's the fixup patch I just tested and am applying:
>>
>> Oh i'm now seeing very high CPU spikes of kworker... i don't see if i
>> remove bcache: Fix a writeback performance regression.
>
> Are you able to reproduce it? I'm not having any luck reproducing it...

Hi,

yes but only on production system it seems it happens when there is a 
big bunch in dirty and having heavy 4K random I/O.

Stefan
