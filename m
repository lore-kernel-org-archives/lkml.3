Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946931Ab3BHTWW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 14:22:22 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:36307 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946800Ab3BHTWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 14:22:21 -0500
Date: Fri, 08 Feb 2013 14:22:19 -0500 (EST)
Message-Id: <20130208.142219.278011265881366578.davem@davemloft.net>
To: chas@cmf.nrl.navy.mil
Cc: heiko.carstens@de.ibm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] atm/iphase: rename fregt_t -> ffreg_t
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130208095842.7df1a25e@thirdoffive.cmf.nrl.navy.mil>
References: <20130208101911.GA12195@osiris>
	<20130208095842.7df1a25e@thirdoffive.cmf.nrl.navy.mil>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: chas williams - CONTRACTOR <chas@cmf.nrl.navy.mil>
Date: Fri, 8 Feb 2013 09:58:42 -0500

> On Fri, 8 Feb 2013 11:19:11 +0100
> Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> 
>> We have conflicting type qualifiers for "freg_t" in s390's ptrace.h and the
>> iphase atm device driver, which causes the compile error below.
>> Unfortunately the s390 typedef can't be renamed, since it's a user visible api,
>> nor can I change the include order in s390 code to avoid the conflict.
>> 
>> So simply rename the iphase typedef to a new name. Fixes this compile error:
>> 
>> In file included from drivers/atm/iphase.c:66:0:
>> drivers/atm/iphase.h:639:25: error: conflicting type qualifiers for 'freg_t'
>> In file included from next/arch/s390/include/asm/ptrace.h:9:0,
>>                  from next/arch/s390/include/asm/lowcore.h:12,
>>                  from next/arch/s390/include/asm/thread_info.h:30,
>>                  from include/linux/thread_info.h:54,
>>                  from include/linux/preempt.h:9,
>>                  from include/linux/spinlock.h:50,
>>                  from include/linux/seqlock.h:29,
>>                  from include/linux/time.h:5,
>>                  from include/linux/stat.h:18,
>>                  from include/linux/module.h:10,
>>                  from drivers/atm/iphase.c:43:
>> next/arch/s390/include/uapi/asm/ptrace.h:197:3: note: previous declaration of 'freg_t' was here
>> 
>> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> seems like a fine idea.
> 
> Acked-by: chas williams - CONTRACTOR <chas@cmf.nrl.navy.mil>

Applied, thanks.
