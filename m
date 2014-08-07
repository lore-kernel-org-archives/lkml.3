Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009AbaHGB6S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 21:58:18 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:42323 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258AbaHGB6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 21:58:17 -0400
X-Original-SENDERIP: 10.177.31.16
X-Original-MAILFROM: hyogi.gim@lge.com
Message-ID: <53E2DD36.8000306@lge.com>
Date: Thu, 07 Aug 2014 10:58:14 +0900
From: Hyogi Gim <hyogi.gim@lge.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] driver/rtc/class.c: check the error after rtc_read_time()
References: <1405412723-10062-1-git-send-email-hyogi.gim@lge.com>	<20140723145634.656752d0fe2fa124db48b4fc@linux-foundation.org>	<5828425.VYTqh3MBtu@vostro.rjw.lan>	<2138754.87hr75v6vM@vostro.rjw.lan> <20140723171922.216f55bb.akpm@linux-foundation.org>
In-Reply-To: <20140723171922.216f55bb.akpm@linux-foundation.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/24/2014 09:19 AM, Andrew Morton wrote:
> 
> So what should rtc do in this case?  At present it pretends the read
> succeeded.  Either way, this doesn't seem to be the place to be making
> such policy decisions..
> 
> 
> 

I agree. But, in this case, RTC device driver can not do anything. And if       
rtc_suspend() returns a minus value, then suspend will be aborted. So,          
in the worst case, suspend will be failed continually. I think this is not      
good.                                                                           
                                                                                
Most RTC device drivers don't verify the read time value. Even some drivers     
just return '0' value(omap, tegra, ...). So, I think the higher level           
framework like /drivers/rtc/interface.c should check and handle the rtc         
read time.
