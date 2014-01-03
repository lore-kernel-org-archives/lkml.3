Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012AbaACD6L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 22:58:11 -0500
Received: from smtprelay0242.hostedemail.com ([216.40.44.242]:34103 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750726AbaACD6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 22:58:10 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3865:3866:3867:3868:3874:4321:4605:5007:6691:7652:8957:10004:10400:10848:11026:11232:11657:11658:11914:12043:12296:12438:12517:12519:12740:13019:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: town15_46ec6e60fd04f
X-Filterd-Recvd-Size: 2378
Message-ID: <1388721483.2527.0.camel@joe-AO722>
Subject: Re: [PATCH v3] Staging: rtl8188eu: Fixed coding style issues
From: Joe Perches <joe@perches.com>
To: Tim Jester-Pfadt <t.jp@gmx.de>
Cc: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Thu, 02 Jan 2014 19:58:03 -0800
In-Reply-To: <20140102232259.GA4112@archlinux>
References: <20140102204640.GA1149@archlinux>
	 <20140102232259.GA4112@archlinux>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2014-01-03 at 00:22 +0100, Tim Jester-Pfadt wrote:
> Fixed indentation coding style issues on rtw_io.c
[]
> diff --git a/drivers/staging/rtl8188eu/core/rtw_io.c b/drivers/staging/rtl8188eu/core/rtw_io.c
[]
> @@ -205,9 +205,9 @@ void _rtw_read_mem(struct adapter *adapter, u32 addr, u32 cnt, u8 *pmem)
>  
>  	_func_enter_;
>  	if (adapter->bDriverStopped || adapter->bSurpriseRemoved) {
> -	     RT_TRACE(_module_rtl871x_io_c_, _drv_info_,
> -		      ("rtw_read_mem:bDriverStopped(%d) OR bSurpriseRemoved(%d)",
> -		      adapter->bDriverStopped, adapter->bSurpriseRemoved));
> +		RT_TRACE(_module_rtl871x_io_c_, _drv_info_,
> +			 ("rtw_read_mem:bDriverStopped(%d) OR bSurpriseRemoved(%d)",
> +			 adapter->bDriverStopped, adapter->bSurpriseRemoved));

Be nice to remove the unnecessary parentheses on all of these too

		RT_TRACE(_module_rtl871x_io_c_, _drv_info_,
			 "rtw_read_mem:bDriverStopped(%d) OR bSurpriseRemoved(%d)",
			 adapter->bDriverStopped, adapter->bSurpriseRemoved);

etc...

A few other things too:

o The _func_enter_ uses are unnecessary and could/should
  be removed.  There's a standard function tracing capability.
o The RT_TRACE uses that embed a function name could/should use
  %s:, __func__
o The RT_TRACE macro doesn't add a terminating newline and these
  uses should have them.

		RT_TRACE(_module_rtl871x_io_c_, _drv_info_,
			 "%s:bDriverStopped(%d) OR bSurpriseRemoved(%d)\n",
			 __func__, adapter->bDriverStopped, adapter->bSurpriseRemoved);



