Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495AbaFSUWS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 16:22:18 -0400
Received: from smtprelay0208.hostedemail.com ([216.40.44.208]:37695 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754264AbaFSUWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 16:22:17 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3865:3866:3867:3872:4321:5007:7652:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12555:12740:13019:13069:13311:13357,
X-HE-Tag: ear60_30a39de5b8e24
X-Filterd-Recvd-Size: 2101
Message-ID: <1403209332.2753.2.camel@joe-AO725>
Subject: Re: [PATCH 6/8] wlan-ng/prism2sta:checkpatch: Fix long lines
From: Joe Perches <joe@perches.com>
To: Johannes Stadlinger <Johannes.Stadlinger@fau.de>
Cc: devel@linuxdriverproject.org,
        Maximilian Eschenbacher <maximilian@eschenbacher.email>,
        linux-kernel@i4.cs.fau.de,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tugce Sirin <ztugcesirin@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Neil Armstrong <superna9999@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Vitaly Osipov <vitaly.osipov@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Thu, 19 Jun 2014 13:22:12 -0700
In-Reply-To: <1403205620-10219-6-git-send-email-Johannes.Stadlinger@fau.de>
References: <1403205620-10219-1-git-send-email-Johannes.Stadlinger@fau.de>
	 <1403205620-10219-6-git-send-email-Johannes.Stadlinger@fau.de>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-06-19 at 21:20 +0200, Johannes Stadlinger wrote:
> This patch fixes all warning of checkpatch about lines over 80
> characters.

trivia:

> diff --git a/drivers/staging/wlan-ng/prism2sta.c b/drivers/staging/wlan-ng/prism2sta.c
[]
> @@ -1271,7 +1275,8 @@ void prism2sta_processing_defer(struct work_struct *data)
>  				     HFA384x_RID_CURRENTSSID, result);
>  				return;
>  			}
> -			prism2mgmt_bytestr2pstr((struct hfa384x_bytestr *) &ssid,
> +			prism2mgmt_bytestr2pstr((struct hfa384x_bytestr *)
> +									&ssid,
>  						(p80211pstrd_t *) &
>  						wlandev->ssid);

I don't find this better or easier to read.

Sometimes it's easier to read to cast to a
void * instead of the specific type

			prism2mgmt_bytestr2pstr((void *)&ssid,
						(void *)&wlandev->ssid);

 



