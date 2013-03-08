Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760250Ab3CHDcl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 22:32:41 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:17363 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294Ab3CHDck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 22:32:40 -0500
Message-ID: <51395B88.4040701@huawei.com>
Date: Fri, 8 Mar 2013 11:31:20 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/8] ARM/etm/sysrq: fix inconstistent help message of
 sysrq key
References: <51385727.3080206@huawei.com> <20130307113653.GE17833@n2100.arm.linux.org.uk>
In-Reply-To: <20130307113653.GE17833@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/3/7 19:36, Russell King - ARM Linux wrote:
> On Thu, Mar 07, 2013 at 05:00:23PM +0800, zhangwei(Jovi) wrote:
>> Currently help message of /proc/sysrq-trigger highlight its
>> upper-case characters, like below:
>>
>>       SysRq : HELP : loglevel(0-9) reBoot Crash terminate-all-tasks(E)
>>       memory-full-oom-kill(F) kill-all-tasks(I) ...
>>
>> this would confuse user trigger sysrq by upper-case character, which is
>> inconsistent with the real lower-case character registed key.
>>
>> This inconsistent help message will also lead more confused when
>> 26 upper-case letters put into use in future.
>>
>> This patch fix arm etm sysrq key: "etm buffer dump(v)"
> 
> Umm, actually this is wrong.  sysrq doesn't deal with case.
> 
> static int sysrq_key_table_key2index(int key)
> {
>         int retval;
> 
>         if ((key >= '0') && (key <= '9'))
>                 retval = key - '0';
>         else if ((key >= 'a') && (key <= 'z'))
>                 retval = key + 10 - 'a';
>         else
>                 retval = -1;
>         return retval;
> }
> 
> It actually accepts no upper case characters (because they can't be
> typed on a PC keyboard with the simple code that is sysrq.)  The sysrq
> key combinations there are Alt+Sysrq+key.
> 
No,  sysrq doesn't accept upper-case characters just now,
function sysrq_key_table_key2index will be change if lower-case character is full for sysrq key use.

upper-case can be use for sysrq, whatever user trigger it by Sysrq key in PC keyboard, or echo "letter" into /proc/sysrq-trigger.
When trigger upper-case sysrq key by PC keyboard, you need open Caps-Lock firstly.
(Tested in my PC box)

> All sysrq help messages give the key in parens with a capital letter.
> However, there's one change you should make to this anyway - there
> should be no spaces in the help message - instead, the spaces should
> be the "-" character.  Space is used to separate each sysrq key help
> message.
You are right, I fix it by below patch. Thanks.

---------------------

>From 93a03255cc570ac0e7f306b0bbd815195944813e Mon Sep 17 00:00:00 2001
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Date: Fri, 8 Mar 2013 11:04:16 +0800
Subject: [PATCH 4/8] ARM/etm/sysrq: fix inconstistent help message of sysrq
 key

Currently help message of /proc/sysrq-trigger highlights its
upper-case characters, like below:

      SysRq : HELP : loglevel(0-9) reBoot Crash terminate-all-tasks(E)
      memory-full-oom-kill(F) kill-all-tasks(I) ...

this would confuse user trigger sysrq by upper-case character, which is
inconsistent with the real lower-case character registed key.

This inconsistent help message will also lead more confused when
26 upper-case letters put into use in future.

This patch fix arm etm sysrq key: "etm-buffer-dump(v)"
(This patch also add "-" to separate each sysrq key help word,
instead of spaces)

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Russell King <linux@arm.linux.org.uk>
---
 arch/arm/kernel/etm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/kernel/etm.c b/arch/arm/kernel/etm.c
index 9b6de8c..8ff0ecd 100644
--- a/arch/arm/kernel/etm.c
+++ b/arch/arm/kernel/etm.c
@@ -254,7 +254,7 @@ static void sysrq_etm_dump(int key)

 static struct sysrq_key_op sysrq_etm_op = {
 	.handler = sysrq_etm_dump,
-	.help_msg = "ETM buffer dump",
+	.help_msg = "etm-buffer-dump(v)",
 	.action_msg = "etm",
 };

-- 
1.7.9.7




