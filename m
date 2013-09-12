Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376Ab3ILWn1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 18:43:27 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:40802 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756123Ab3ILWnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 18:43:24 -0400
Date: Fri, 13 Sep 2013 01:43:12 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: smatch@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Smatch messages that are not understood
Message-ID: <20130912224312.GJ25896@mwanda>
References: <52324046.5060709@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52324046.5060709@lwfinger.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 05:29:26PM -0500, Larry Finger wrote:
> Hi,
> 
> I am in the process of fixing smatch warnings and errors in the
> rtlwifi family of drivers. Most are straight forward; however, some
> routines show info messages originating from an inline routine in
> the header files as follows:
> 
>   CHECK   drivers/net/wireless/rtlwifi/rtl8192ce/dm.c
> include/linux/etherdevice.h:278 ether_addr_equal_64bits() info:
> ignoring unreachable code.
> include/linux/etherdevice.h:278 ether_addr_equal_64bits() info:
> ignoring unreachable code.
> 
> The source code is a current pull of the mainline git tree. I'm not
> sure if this is a subtle case of unreachable code that I do not see,
> or if it is a smatch bug.

include/linux/etherdevice.h
   275          if (sizeof(fold) == 8)
   276                  return zap_last_2bytes(fold) == 0;
   277  
   278          fold |= zap_last_2bytes((*(unsigned long *)(addr1 + 4)) ^
   279                                  (*(unsigned long *)(addr2 + 4)));

It's hitting the (sizeof(fold) == 8) and returning.

regards,
dan carpenter

