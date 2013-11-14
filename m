Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751791Ab3KNJSz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 04:18:55 -0500
Received: from canardo.mork.no ([148.122.252.1]:47519 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232Ab3KNJSw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 04:18:52 -0500
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Oliver Neukum <oliver@neukum.org>
Cc: wangbiao <biao.wang@intel.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo.kernel.org@gmail.com>, akpm@linux-foundation.org,
        mingo@elte.hu, a.p.zijlstra@chello.nl, rusty@rustcorp.com.au,
        william.douglas@intel.com, di.zhang@intel.com
Subject: Re: [PATCH V3] usbnet: fix race condition caused spinlock bad magic issue
Organization: m
References: <1384394595.4229.24.camel@wangbiao>
	<1384415082.18291.8.camel@linux-fkkt.site>
Date: Thu, 14 Nov 2013 10:18:05 +0100
In-Reply-To: <1384415082.18291.8.camel@linux-fkkt.site> (Oliver Neukum's
	message of "Thu, 14 Nov 2013 08:44:42 +0100")
Message-ID: <87fvqznxyq.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Neukum <oliver@neukum.org> writes:

> On Thu, 2013-11-14 at 10:03 +0800, wangbiao wrote:
>> From: wang, biao <biao.wang@intel.com>
>> Date: Mon, 11 Nov 2013 10:23:40 +0800
>> Subject: [PATCH] usbnet: fix race condition caused spinlock bad magic issue
>> 
>> there is race between usbnet_terminate_urbs and usbnet_bh.
>> for example:
>>     cpu 0                                     cpu 1
>>                                           usbnet_suspend
>> usbnet_bh {                               ->usbnet_terminate_urbs {
>>                                               dev->wait = &unlink_wakeup;
>>                                               while(....){..}//break
>>     if(dev->wait) is true
>>                        		              dev->wait=NULL
>>                                           }//unlink_wakeup is invalid
>>     __wake_up(dev->wait)//garbage value
>> }
>> 
>> the race is due to unprotection of dev->wait, so this patch involves a
>> spinlock to avoid it.
>> 
>> Signed-off-by: wang, biao <biao.wang@intel.com>
>> Signed-off-by: Zhang, Di <di.zhang@intel.com>
> Acked-by: Oliver Neukum <oliver@neukum.org>


Really?  Serializing the suspend of all usbnet devices seems like a good
idea?


Bjørn
