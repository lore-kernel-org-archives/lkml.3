Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758671Ab3GZMNJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 08:13:09 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:51321 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757545Ab3GZMNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 08:13:04 -0400
X-AuditID: 85900ec0-d4ccab900000151e-22-51f267cd2237
Message-ID: <51F267CE.1040008@hitachi.com>
Date: Fri, 26 Jul 2013 21:13:02 +0900
From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        akpm@linux-foundation.org, gregkh@linuxfoundation.org, kay@vrfy.org,
        davem@davemloft.net, itoukzo@nttdata.co.jp
Subject: Re: Re: [RESEND RFC PATCH 0/5] Add a hash value for each line
 in /dev/kmsg
References: <20130725083730.20349.50797.stgit@localhost.localdomain> <1374771118.1957.8.camel@joe-AO722>
In-Reply-To: <1374771118.1957.8.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

(2013/07/26 1:51), Joe Perches wrote:> On Thu, 2013-07-25 at 17:37 +0900, Hidehiro Kawai wrote:
>> ================
>> This patch series adds hash values of printk format strings into
>> each line of /dev/kmsg outputs as follows:
>>
>>         6,154,325061,-,b7db707c@kernel/smp.c:554;Brought up 4 CPUs
>>
>> These hash values allow use space to identify messages easily and
>> do valuable things.  There is no guarantee that the hash values
>> are unique.  However, user space can know which one collides to
>> others from a message-and-hash catalog generated at build time, so
>> finally it should be able to identify the messages.  User space
>> can also use filename:lineno information to do that, although the
>> information is not portable among various kernel versions.
>>
>>
>> Background
>> ==========
>> We sometimes want to identify each kernel message automatically
>> because of the following purposes:
>>
>> (1) Show more detailed information about the message by cooperating
>>     with external system
>> (2) Take actions automatically depending on the message, for example
>>     trigger a fail over or collect related information to analyze the
>>     problem
>
> If there are really "take action" uses, perhaps
> it'd be better to mark the specific areas of code
> where this needs to be done and add a notifier
> function there instead of depending on post effect
> processing.

It is one of the solution if we can add such notifiers easily, but I think
it's not true.  Adding a notifier means that it gives the portion of
the codes fixed meaning.  This is similar to adding a tracepoint.
Maintainer and developers have to keep the meaning consistent, but they
wouldn't like to do that so much.  Moreover, events users want to
handle differ depending on users and system vendors.  As the result,
we would have to add many notifiers into many places.

On the other hand, printk message handling is a flexible, readily
available and multipurpose way.

Regards,
-- 
Hidehiro Kawai
Hitachi, Yokohama Research Laboratory
Linux Technology Center


