Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015Ab3KFB2v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 20:28:51 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:55904 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755753Ab3KFB2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 20:28:50 -0500
X-IronPort-AV: E=Sophos;i="4.93,643,1378828800"; 
   d="scan'208";a="8956196"
Message-ID: <527999DC.1090206@cn.fujitsu.com>
Date: Wed, 06 Nov 2013 09:22:36 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: jfrederich@gmail.com, dsd@laptop.org, jon.nettleton@gmail.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH 2/2] staging/olpc_docn: reorder the lock sequence
 to avoid potential dead lock
References: <5278C1DC.9000609@cn.fujitsu.com> <20131105110242.GQ26669@mwanda>
In-Reply-To: <20131105110242.GQ26669@mwanda>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/06 09:26:51,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/06 09:26:55,
	Serialize complete at 2013/11/06 09:26:55
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,
On 11/05/2013 07:02 PM, Dan Carpenter wrote:

> On Tue, Nov 05, 2013 at 06:01:00PM +0800, Gu Zheng wrote:
>> The lock sequence of dcon_blank_fb(fb_info->lock ---> console_lock) is against
>> with the one of console_callback(console_lock ---> fb_info->lock), it'll
>> lead to a potential dead lock, so reorder the lock sequence of dcon_blank_fb
>> to avoid the potential dead lock.
>>
>> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
> 
> Relax, Greg isn't taking new patches for another three weeks because the
> merge window is open.

Got it, I just want to gain some comments about this patch.

> 
> Also what happened to [PATCH 1/2]?

It fixes the similar issue of fb subsystem.
https://patchwork.kernel.org/patch/3140121/

Regards,
Gu

> 
> regards,
> dan carpenter
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


