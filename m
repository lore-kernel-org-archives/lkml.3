Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910Ab3HPKLP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 06:11:15 -0400
Received: from mail-ph.de-nserver.de ([85.158.179.214]:49159 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084Ab3HPKLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 06:11:12 -0400
X-Fcrdns: No
Message-ID: <520DFAB4.1050402@profihost.ag>
Date: Fri, 16 Aug 2013 12:11:00 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Kent Overstreet <kmo@daterainc.com>
CC: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-bcache@vger.kernel.org
Subject: Re: [GIT PULL] bcache fixes for 3.11
References: <20130814225904.GA6427@kmo-pixel> <520C788A.1060208@profihost.ag>
In-Reply-To: <520C788A.1060208@profihost.ag>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-User-Auth: Auth by hostmaster@profihost.com through 85.158.179.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

bcache: Fix a writeback performance regression

this one results in 3.10 into hung tasks in bcache_writeback read_dirty.

Stefan
Am 15.08.2013 08:43, schrieb Stefan Priebe - Profihost AG:
> Am 15.08.2013 00:59, schrieb Kent Overstreet:
>> Jens, here's the latest bcache fixes. Some urgent stuff in here:
>>
>>
>> The following changes since commit 79826c35eb99cd3c0873b8396f45fa26c87fb0b0:
>>
>>   bcache: Allocation kthread fixes (2013-07-12 00:22:49 -0700)
>>
>> are available in the git repository at:
>>
>>   git://evilpiepirate.org/~kent/linux-bcache.git bcache-for-3.11
>>
>> for you to fetch changes up to 0434a516e99ee51ac2d0dfa71b2f56c89ac5db05:
>>
>>   bcache: Fix a flush/fua performance bug (2013-08-14 15:44:51 -0700)
>>
>> ----------------------------------------------------------------
>> Gabriel de Perthuis (1):
>>       bcache: Strip endline when writing the label through sysfs
>>
>> Geert Uytterhoeven (1):
>>       bcache: Correct printf()-style format length modifier
>>
>> Kent Overstreet (4):
>>       bcache: Fix a dumb journal discard bug
>>       bcache: Fix for when no journal entries are found
>>       bcache: Fix a writeback performance regression
>>       bcache: Fix a flush/fua performance bug
>>
>>  drivers/md/bcache/bcache.h    |  7 +++----
>>  drivers/md/bcache/btree.c     |  2 +-
>>  drivers/md/bcache/journal.c   | 33 ++++++++++++++++++++-------------
>>  drivers/md/bcache/sysfs.c     |  9 +++++++--
>>  drivers/md/bcache/util.c      | 11 ++++++++++-
>>  drivers/md/bcache/util.h      | 12 +++++++++---
>>  drivers/md/bcache/writeback.c | 37 ++++++++++++++++++-------------------
>>  7 files changed, 68 insertions(+), 43 deletions(-)
>> --
> 
> As 3.10 is long term stable release. You might need CC the stable list
> for patches which have to go to 3.10 as well.
> 
> At least this one should go to 3.10:
>> Gabriel de Perthuis (1):
>>       bcache: Strip endline when writing the label through sysfs
> 
> Thanks!
> 
> Greets,
> Stefan
> 
