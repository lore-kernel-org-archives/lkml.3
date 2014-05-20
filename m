Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751610AbaETIvF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 04:51:05 -0400
Received: from mx01-fr.bfs.de ([193.174.231.67]:7118 "EHLO mx01-fr.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714AbaETIvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 04:51:01 -0400
Message-ID: <537B1766.1090808@bfs.de>
Date: Tue, 20 May 2014 10:50:46 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Masaru Nomura <massa.nomura@gmail.com>, gregkh@linuxfoundation.org,
        andreas.dilger@intel.com, oleg.drokin@intel.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/5] staging: lustre: lnet: socklnd: Clean up memset(...)
References: <1400433557-24985-1-git-send-email-massa.nomura@gmail.com>	 <1400433557-24985-3-git-send-email-massa.nomura@gmail.com> <1400434032.21382.3.camel@joe-AO725>
In-Reply-To: <1400434032.21382.3.camel@joe-AO725>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Am 18.05.2014 19:27, schrieb Joe Perches:
> On Sun, 2014-05-18 at 18:19 +0100, Masaru Nomura wrote:
>> Remove prohibited space and fix line over 80 characters of
>> memset(...) to meet kernel coding style.
> []
>> diff --git a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
> []
>> @@ -113,7 +113,7 @@ ksocknal_create_peer(ksock_peer_t **peerp, lnet_ni_t *ni, lnet_process_id_t id)
>>  	if (peer == NULL)
>>  		return -ENOMEM;
>>  
>> -	memset (peer, 0, sizeof (*peer));       /* NULL pointers/clear flags etc */
>> +	memset(peer, 0, sizeof(*peer));     /* NULL pointers/clear flags etc */
> 
> It looks like this memset is unnecessary
> as it's already zeroed by LIBCFS_ALLOC->
> LIBCFS_ALLOC_GFP->LIBCFS_ALLOC_POST->memset.
> 
> It seems as if all these ALLOC macros could
> use quite a bit of cleaning/sorting out.
> 

for a start,
some kind soul could replace the malloc()/memset() with zalloc().

re,
 wh





