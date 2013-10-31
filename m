Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103Ab3JaBXJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 21:23:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:21504 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750715Ab3JaBXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 21:23:07 -0400
X-IronPort-AV: E=Sophos;i="4.93,605,1378828800"; 
   d="scan'208";a="8904952"
Message-ID: <5271AF91.4090109@cn.fujitsu.com>
Date: Thu, 31 Oct 2013 09:17:05 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH RESEND] fb: reorder the lock sequence to fix a potential
 lockdep
References: <526DFDA8.7010806@cn.fujitsu.com> <5270EB85.1030103@ti.com>
In-Reply-To: <5270EB85.1030103@ti.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/31 09:21:21,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/31 09:21:21,
	Serialize complete at 2013/10/31 09:21:21
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomi,

On 10/30/2013 07:20 PM, Tomi Valkeinen wrote:

> Hi,
> 
> On 2013-10-28 08:01, Gu Zheng wrote:
>> Following commits:
>> 50e244cc79 fb: rework locking to fix lock ordering on takeover
>> e93a9a8687 fb: Yet another band-aid for fixing lockdep mess
>> 054430e773 fbcon: fix locking harder
>>
>> reworked locking to fix related lock ordering on takeover, and introduced console_lock
>> into fbmem, but it seems that the new lock sequence(fb_info->lock ---> console_lock)
>> is against with the one in console_callback(console_lock ---> fb_info->lock), and leads to
>> a potential deadlock as following:
> 
> A quick grep shows that there are other places than fbmem.c which use
> lock_fb_info and console_lock, for example drivers/video/sh_mobile_lcdcfb.c.

Yes, thanks for your reminder, I'll fix them all in the next version.

Regards,
Gu

> 
>  Tomi
> 
> 


