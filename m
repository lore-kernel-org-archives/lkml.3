Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab3KNI1B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 03:27:01 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:56173 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755Ab3KNI06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 03:26:58 -0500
Message-ID: <1384415082.18291.8.camel@linux-fkkt.site>
Subject: Re: [PATCH V3] usbnet: fix race condition caused spinlock bad
 magic issue
From: Oliver Neukum <oliver@neukum.org>
To: wangbiao <biao.wang@intel.com>
Cc: netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo.kernel.org@gmail.com>,
        akpm@linux-foundation.org, mingo@elte.hu, a.p.zijlstra@chello.nl,
        rusty@rustcorp.com.au, william.douglas@intel.com, di.zhang@intel.com
In-Reply-To: <1384394595.4229.24.camel@wangbiao>
References: <1384394595.4229.24.camel@wangbiao>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Nov 2013 08:44:42 +0100
Mime-Version: 1.0
X-Mailer: Evolution 3.9.4 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-11-14 at 10:03 +0800, wangbiao wrote:
> From: wang, biao <biao.wang@intel.com>
> Date: Mon, 11 Nov 2013 10:23:40 +0800
> Subject: [PATCH] usbnet: fix race condition caused spinlock bad magic issue
> 
> there is race between usbnet_terminate_urbs and usbnet_bh.
> for example:
>     cpu 0                                     cpu 1
>                                           usbnet_suspend
> usbnet_bh {                               ->usbnet_terminate_urbs {
>                                               dev->wait = &unlink_wakeup;
>                                               while(....){..}//break
>     if(dev->wait) is true
>                        		              dev->wait=NULL
>                                           }//unlink_wakeup is invalid
>     __wake_up(dev->wait)//garbage value
> }
> 
> the race is due to unprotection of dev->wait, so this patch involves a
> spinlock to avoid it.
> 
> Signed-off-by: wang, biao <biao.wang@intel.com>
> Signed-off-by: Zhang, Di <di.zhang@intel.com>
Acked-by: Oliver Neukum <oliver@neukum.org>

