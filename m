Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab3CZRat (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:30:49 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:60413 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198Ab3CZRan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:30:43 -0400
X-IronPort-AV: E=Sophos;i="4.84,913,1355097600"; 
   d="scan'208";a="2932634"
Message-ID: <5151DB41.6070506@citrix.com>
Date: Tue, 26 Mar 2013 18:30:41 +0100
From: =?ISO-8859-1?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
Subject: Re: [PATCH RFC 08/12] xen-blkback: use balloon pages for all mappings
References: <1362047335-26402-1-git-send-email-roger.pau@citrix.com> <1362047335-26402-9-git-send-email-roger.pau@citrix.com> <20130304202248.GK15386@phenom.dumpdata.com>
In-Reply-To: <20130304202248.GK15386@phenom.dumpdata.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/13 21:22, Konrad Rzeszutek Wilk wrote:
[...]
>> @@ -535,13 +604,17 @@ purge_gnt_list:
>>                               msecs_to_jiffies(xen_blkif_lru_interval);
>>               }
>>
>> +             remove_free_pages(blkif, xen_blkif_max_buffer_pages);
>> +
>>               if (log_stats && time_after(jiffies, blkif->st_print))
>>                       print_stats(blkif);
>>       }
>>
>> +     remove_free_pages(blkif, 0);
> 
> What purpose does that have?

This removes all the pages from the pool before closing down.
