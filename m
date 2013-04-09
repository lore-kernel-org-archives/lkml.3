Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937212Ab3DIQug (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 12:50:36 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:56336 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934679Ab3DIQub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 12:50:31 -0400
MIME-Version: 1.0
In-Reply-To: <20130409161222.GZ24058@zurbaran>
References: <20130408142124.ac540429a889cdc9800e529a@canb.auug.org.au>
	<1365438469.322553103@f51.mail.ru>
	<20130409072059.GC23447@zurbaran>
	<1365522460.690965802@f12.mail.ru>
	<20130409161222.GZ24058@zurbaran>
Date: Tue, 9 Apr 2013 11:50:30 -0500
Message-ID: <CAL_Jsq+=n6SYpMCUNc0PSBdGOWOWcbdmtBrAxZhRqhLr4stxow@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the mfd tree
From: Rob Herring <robherring2@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Alexander Shiyan <shc_work@mail.ru>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 9, 2013 at 11:12 AM, Samuel Ortiz <sameo@linux.intel.com> wrote:
> Hi Alexander,
>
> On Tue, Apr 09, 2013 at 07:47:40PM +0400, Alexander Shiyan wrote:
>> > On Mon, Apr 08, 2013 at 08:27:49PM +0400, Alexander Shiyan wrote:

[...]

>> From 3296415f29818a430bad12c92dc65cd81e4d133f Mon Sep 17 00:00:00 2001
>> From: Alexander Shiyan <shc_work@mail.ru>
>> Date: Tue, 9 Apr 2013 19:41:27 +0400
>> Subject: [PATCH] of: add stub of_get_parent for non-OF builds
>>
>> Fixes build error on x86_64 allmodconfig, introduced by commit
>> 5ab3a89a741f ("mfd: syscon: Add non-DT support").
>>
>> drivers/regulator/anatop-regulator.c: In function 'anatop_regulator_probe':
>> drivers/regulator/anatop-regulator.c:134:2: error: implicit declaration of function 'of_get_parent' [-Werror=implicit-function-declaration]
>>
>> Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
>> ---
>>  include/linux/of.h | 5 +++++
>>  1 file changed, 5 insertions(+)
>>
>> diff --git a/include/linux/of.h b/include/linux/of.h
>> index a0f1292..9f5923f 100644
>> --- a/include/linux/of.h
>> +++ b/include/linux/of.h
>> @@ -353,6 +353,11 @@ static inline struct device_node *of_find_node_by_name(struct device_node *from,
>>       return NULL;
>>  }
>>
>> +static inline struct device_node *of_get_parent(const struct device_node *node)
>> +{
>> +     return NULL;
>> +}
>> +
> That looks like a proper fix, but I'd like to get Grant or/and Rob's ACK for
> it before merging it. Please look at MAINTAINERS and cc them on this thread.

Acked-by: Rob Herring <rob.herring@calxeda.com>
