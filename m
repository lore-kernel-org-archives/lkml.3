Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970AbaEMQbC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 12:31:02 -0400
Received: from smtprelay0091.hostedemail.com ([216.40.44.91]:34137 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751515AbaEMQa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 12:30:56 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3871:3876:4321:5007:7652:8957:10004:10400:10848:11026:11232:11473:11658:11914:12050:12438:12517:12519:12555:12740:13069:13071:13311:13357:21060,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: hose01_5f40657618362
X-Filterd-Recvd-Size: 1555
Message-ID: <1399998653.24350.4.camel@joe-AO725>
Subject: Re: [PATCH 1/1] fs/cifs/netmisc.c: convert printk to pr_foo()
From: Joe Perches <joe@perches.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Steve French <sfrench@samba.org>, akpm <akpm@linux-foundation.org>
Date: Tue, 13 May 2014 09:30:53 -0700
In-Reply-To: <20140513181039.9766ed456a097164a195d2fe@skynet.be>
References: <20140513181039.9766ed456a097164a195d2fe@skynet.be>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-05-13 at 18:10 +0200, Fabian Frederick wrote:
> Also fixes array checkpatch warning.
[]
> diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
[]
> @@ -941,8 +941,8 @@ cifs_UnixTimeToNT(struct timespec t)
>  	return (u64) t.tv_sec * 10000000 + t.tv_nsec/100 + NTFS_TIME_OFFSET;
>  }
>  
> -static int total_days_of_prev_months[] =
> -{0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334};
> +static int total_days_of_prev_months[] = {
> +	0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334};

Hi Fabian.

A preferred form for initialized array declarations is

type array[] = {
	val1, val2, ..., valn
};

Also this instance should probably be static const.


