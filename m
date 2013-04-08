Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964926Ab3DHOeO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 10:34:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34279 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964883Ab3DHOeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 10:34:12 -0400
Message-ID: <5162D562.1090104@suse.cz>
Date: Mon, 08 Apr 2013 16:34:10 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130105 Thunderbird/17.0.2
MIME-Version: 1.0
To: Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts/mod: add device table offsets file to list of
 files to clean
References: <1362391043.6156.2.camel@nexus.lab.ntt.co.jp> <51480D07.5060505@lab.ntt.co.jp>
In-Reply-To: <51480D07.5060505@lab.ntt.co.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.3.2013 08:00, Fernando Luis Vazquez Cao wrote:
> Hi Michal,
> 
> On 2013/03/04 18:57, Fernando Luis Vázquez Cao wrote:
>> From: Fernando Luis Vázquez Cao <fernando@oss.ntt.co.jp>
>>
>> This file is generated so it does not get cleaned automagically. In
>> other words
>> we need to added to the clean-files list.
>>
>> Signed-off-by: Fernando Luis Vázquez Cao <fernando@oss.ntt.co.jp>
>> ---
>>
>> diff -urNp linux-3.9-rc1-orig/scripts/mod/Makefile
>> linux-3.9-rc1/scripts/mod/Makefile
>> --- linux-3.9-rc1-orig/scripts/mod/Makefile    2013-03-04
>> 16:09:29.297904000 +0900
>> +++ linux-3.9-rc1/scripts/mod/Makefile    2013-03-04
>> 18:06:16.359389000 +0900
>> @@ -49,3 +49,5 @@ $(obj)/elfconfig.h: $(obj)/empty.o $(obj
>>       $(call if_changed,elfconfig)
>>     targets += elfconfig.h
>> +
>> +clean-files    := $(devicetable-offsets-file)
> 
> Do you see any problem with this patch?

Yes, it does not work, at least not on top of 3.9-rc1. You need to add
'scripts' to the $(clean-dirs) list in the main Makefile, so that make
clean descends into scripts/mod.

Michal

