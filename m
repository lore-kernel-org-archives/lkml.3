Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab3KLBNI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 20:13:08 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53623 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751427Ab3KLBNE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 20:13:04 -0500
X-IronPort-AV: E=Sophos;i="4.93,681,1378828800"; 
   d="scan'208";a="9006539"
Message-ID: <52817F25.2090808@cn.fujitsu.com>
Date: Tue, 12 Nov 2013 09:06:45 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH 1/2] fb: reorder the lock sequence to fix potential
 dead lock
References: <5278C1D9.9030101@cn.fujitsu.com> <5280E2BF.7040602@ti.com>
In-Reply-To: <5280E2BF.7040602@ti.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/12 09:11:17,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/12 09:11:20,
	Serialize complete at 2013/11/12 09:11:20
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomi,
On 11/11/2013 09:59 PM, Tomi Valkeinen wrote:

> On 2013-11-05 12:00, Gu Zheng wrote:
>> Following commits:
>> 50e244cc79 fb: rework locking to fix lock ordering on takeover
>> e93a9a8687 fb: Yet another band-aid for fixing lockdep mess
>> 054430e773 fbcon: fix locking harder
>> reworked locking to fix related lock ordering on takeover, and introduced console_lock
>> into fbmem, but it seems that the new lock sequence(fb_info->lock ---> console_lock)
>> is against with the one in console_callback(console_lock ---> fb_info->lock), and leads to
>> a potential dead lock as following:
> 
> <snip>
> 
>> so we reorder the lock sequence the same as it in console_callback() to
>> avoid this issue. And following Tomi's suggestion, fix these similar
>> issues all in fb subsystem.
>>
>> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
>> ---
>>  drivers/video/fbmem.c            |   50 ++++++++++++++++++++++++-------------
>>  drivers/video/fbsysfs.c          |   19 ++++++++++----
>>  drivers/video/sh_mobile_lcdcfb.c |   10 ++++---
>>  3 files changed, 51 insertions(+), 28 deletions(-)
> 
> I'll apply this for 3.13. It's a bit difficult to verify if the locking
> is now correct, but looks fine to me. And we can revert this easily if
> things break badly.

Thanks very munch.:)

Regards,
Gu

> 
>  Tomi
> 
> 


