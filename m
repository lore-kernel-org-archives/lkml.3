Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751489Ab3HTIBN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 04:01:13 -0400
Received: from mail-ph.de-nserver.de ([85.158.179.214]:35417 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213Ab3HTIBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 04:01:11 -0400
X-Fcrdns: No
Message-ID: <52132243.8050803@profihost.ag>
Date: Tue, 20 Aug 2013 10:01:07 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Kent Overstreet <kmo@daterainc.com>
CC: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-bcache@vger.kernel.org
Subject: Re: bcache: Fix a writeback performance regression
References: <20130814225904.GA6427@kmo-pixel> <520C788A.1060208@profihost.ag> <520DFAB4.1050402@profihost.ag> <52114614.4070509@profihost.ag> <20130819222718.GA32104@kmo-pixel>
In-Reply-To: <20130819222718.GA32104@kmo-pixel>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-User-Auth: Auth by hostmaster@profihost.com through 85.158.179.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 20.08.2013 00:27, schrieb Kent Overstreet:
> On Mon, Aug 19, 2013 at 12:09:24AM +0200, Stefan Priebe wrote:
>>
>> Vanilla 3.10.7 + bcache: Fix a writeback performance regression
>>
>> http://pastebin.com/raw.php?i=LXZk4cMH
> 
> Whoops, at first I thought this was the same bug as one I'd already been
> chasing down that had been a harmless bug - turns out I didn't look
> closely enough at the backtrace.
> 
> What happened is background writeback is deadlocking, because for some
> reason the workqueue it's running out of is a singlethreaded workqueue,
> so as soon as it decides to queue enough writeback bios that it has to
> sleep on that semaphore (which often won't happen due to the PD
> controller based ratelimiting) - boom, deadlock.
> 
> Here's the fixup patch I just tested and am applying:

thanks, this works fine. The only issue i still have, is that the
dirty_date value starts at 0 and goes to a negative value after reboot.

Greets,
Stefan
