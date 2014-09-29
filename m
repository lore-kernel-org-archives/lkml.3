Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255AbaI2WW7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 18:22:59 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551AbaI2WW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 18:22:58 -0400
Message-ID: <5429DBC0.1010801@nod.at>
Date: Tue, 30 Sep 2014 00:22:56 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] UBI: Fix possible deadlock in erase_worker()
References: <1411375536-20067-1-git-send-email-richard@nod.at>	 <1411375536-20067-3-git-send-email-richard@nod.at> <1411728032.23429.63.camel@sauron.fi.intel.com>
In-Reply-To: <1411728032.23429.63.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 26.09.2014 12:40, schrieb Artem Bityutskiy:
> On Mon, 2014-09-22 at 10:45 +0200, Richard Weinberger wrote:
>> If sync_erase() fails with EINTR, ENOMEM, EAGAIN or
>> EBUSY erase_worker() re-schedules the failed work.
>> This will lead to a deadlock because erase_worker() is called
>> with work_sem held in read mode. And schedule_erase() will take
>> this lock again.
>>
>> Signed-off-by: Richard Weinberger <richard@nod.at>
> 
> Did you manage to test it?
> 
> Why no -stable this time? Not that important, or just something
> theoretical and you never actually hit this bug?

It is something theoretical, I was only able to trigger it by injecting
ENOMEM by hand.

Thanks,
//richard
