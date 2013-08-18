Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755738Ab3HRWJY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 18:09:24 -0400
Received: from mail-ph.de-nserver.de ([85.158.179.214]:55331 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755568Ab3HRWJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 18:09:22 -0400
X-Fcrdns: No
Message-ID: <52114614.4070509@profihost.ag>
Date: Mon, 19 Aug 2013 00:09:24 +0200
From: Stefan Priebe <s.priebe@profihost.ag>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Kent Overstreet <kmo@daterainc.com>
CC: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-bcache@vger.kernel.org
Subject: Re: bcache: Fix a writeback performance regression
References: <20130814225904.GA6427@kmo-pixel> <520C788A.1060208@profihost.ag> <520DFAB4.1050402@profihost.ag>
In-Reply-To: <520DFAB4.1050402@profihost.ag>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-User-Auth: Auth by s.priebe@profihost.ag through 85.158.179.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Vanilla 3.10.7 + bcache: Fix a writeback performance regression

http://pastebin.com/raw.php?i=LXZk4cMH

Stefan

Am 16.08.2013 12:11, schrieb Stefan Priebe - Profihost AG:
> Hi,
>
> bcache: Fix a writeback performance regression
>
> this one results in 3.10 into hung tasks in bcache_writeback read_dirty.
>
> Stefan
> Am 15.08.2013 08:43, schrieb Stefan Priebe - Profihost AG:
>> Am 15.08.2013 00:59, schrieb Kent Overstreet:
>>> Jens, here's the latest bcache fixes. Some urgent stuff in here:
>>>
>>>
>>> The following changes since commit 79826c35eb99cd3c0873b8396f45fa26c87fb0b0:
>>>
>>>    bcache: Allocation kthread fixes (2013-07-12 00:22:49 -0700)
>>>
>>> are available in the git repository at:
>>>
>>>    git://evilpiepirate.org/~kent/linux-bcache.git bcache-for-3.11
>>>
>>> for you to fetch changes up to 0434a516e99ee51ac2d0dfa71b2f56c89ac5db05:
>>>
>>>    bcache: Fix a flush/fua performance bug (2013-08-14 15:44:51 -0700)
>>>
>>> ----------------------------------------------------------------
>>> Gabriel de Perthuis (1):
>>>        bcache: Strip endline when writing the label through sysfs
>>>
>>> Geert Uytterhoeven (1):
>>>        bcache: Correct printf()-style format length modifier
>>>
>>> Kent Overstreet (4):
>>>        bcache: Fix a dumb journal discard bug
>>>        bcache: Fix for when no journal entries are found
>>>        bcache: Fix a writeback performance regression
>>>        bcache: Fix a flush/fua performance bug
>>>
>>>   drivers/md/bcache/bcache.h    |  7 +++----
>>>   drivers/md/bcache/btree.c     |  2 +-
>>>   drivers/md/bcache/journal.c   | 33 ++++++++++++++++++++-------------
>>>   drivers/md/bcache/sysfs.c     |  9 +++++++--
>>>   drivers/md/bcache/util.c      | 11 ++++++++++-
>>>   drivers/md/bcache/util.h      | 12 +++++++++---
>>>   drivers/md/bcache/writeback.c | 37 ++++++++++++++++++-------------------
>>>   7 files changed, 68 insertions(+), 43 deletions(-)
>>> --
>>
>> As 3.10 is long term stable release. You might need CC the stable list
>> for patches which have to go to 3.10 as well.
>>
>> At least this one should go to 3.10:
>>> Gabriel de Perthuis (1):
>>>        bcache: Strip endline when writing the label through sysfs
>>
>> Thanks!
>>
>> Greets,
>> Stefan
>>
