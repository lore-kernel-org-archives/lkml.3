Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758279AbaGPKie (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 06:38:34 -0400
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:46591 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbaGPKic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 06:38:32 -0400
Message-ID: <53C655C7.6050606@hp.com>
Date: Wed, 16 Jul 2014 18:36:55 +0800
From: "Li, ZhenHua" <zhen-hual@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: Peter Hurley <peter@hurleysoftware.com>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] driver/tty: Fix a warning in check_tty_count
References: <1405317257-5491-1-git-send-email-zhen-hual@hp.com> <53C3CC4E.9010000@hurleysoftware.com> <53C4EFA8.3080308@hp.com> <53C4F154.3000009@suse.cz>
In-Reply-To: <53C4F154.3000009@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,
You are right, I tested the latest kernel, did not see this bug.
So I will only submit this patch to Redhat.

Thanks
Zhenhua

On 07/15/2014 05:16 PM, Jiri Slaby wrote:
> Hi,
>
> On 07/15/2014 11:08 AM, Li, ZhenHua wrote:
>> This bug  was founded in RHEL 6, kernel version 2.6.32.
>>
>> But I also checked the file tty_io.c in  latest kernel, not all the code
>> protected by tty_lock(tty).
>>
>> For example,  in function tty_del_file,
>>
>>      if (--tty->count < 0) {
>>      }
>> and
>>      tty_del_file(filp);
>> are not surrounded by tty_lock(tty).
> Sure, but there is tty_lock_pair instead.
>
>> So I think the new lock is necessary.
> Nope, sorry, you have to complain to RedHat about this kernel. Unless
> you can reproduce this with the vanilla kernel.
>
> thanks,

