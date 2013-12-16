Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903Ab3LPRQU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 12:16:20 -0500
Received: from mail-ea0-f180.google.com ([209.85.215.180]:52265 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536Ab3LPRQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 12:16:18 -0500
Message-ID: <52AF355E.3080105@linux.com>
Date: Mon, 16 Dec 2013 18:16:14 +0100
From: Levente Kurusa <levex@linux.com>
Reply-To: Levente Kurusa <levex@linux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>
CC: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Jean-Christophe Plagniol-Villard'" <plagnioj@jcrosoft.com>,
        "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>,
        linux-fbdev@vger.kernel.org
Subject: Re: [PATCH 3/4] backlight: lcd: call put_device if device_register
 fails
References: <1386959996-7958-1-git-send-email-levex@linux.com> <1386959996-7958-4-git-send-email-levex@linux.com> <006f01cefa1a$97ea4710$c7bed530$%han@samsung.com>
In-Reply-To: <006f01cefa1a$97ea4710$c7bed530$%han@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2013 05:52 AM, Jingoo Han wrote:
> On Saturday, December 14, 2013 3:40 AM, Levente Kurusa wrote:
>>
>> Currently we kfree the container of the device which failed to register.
>> This is wrong as the last reference is not given up with a put_device
>> call. Also, now that we have put_device() callen, we no longer need
>> the kfree as the new_ld->dev.release function will take care of kfreeing
>> the associated memory.
>>
>> Signed-off-by: Levente Kurusa <levex@linux.com>
> 
> (+cc Andrew Morton)
> 
> Acked-by: Jingoo Han <jg1.han@samsung.com>
> 
> It looks good.
> According to the comment of device_register, put_device()
> should be used, instead of directly freeing.
Indeed, this is also mostly explained in [0/4]. Thanks for the Ack!
> 
[...]
> 
> Levente Kurusa,
> By the way, don't send the same mails three times, without any
> reason. It is the waste of traffic. :-(
> 

Yea, sorry about that I messed up my git's smtp config and hence most of the
messages bounced off. It didn't even reach LKML. Sorry once more.


-- 
Regards,
Levente Kurusa
