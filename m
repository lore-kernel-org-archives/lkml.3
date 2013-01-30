Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab3A3QQL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 11:16:11 -0500
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:46176 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845Ab3A3QQI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 11:16:08 -0500
In-Reply-To: <1359537979-39483-1-git-send-email-hare@suse.de>
References: <1359537979-39483-1-git-send-email-hare@suse.de>
To: Hannes Reinecke <hare@suse.de>
Cc: Hannes Reinecke <hare@suse.de>, heicars2@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, mschwid2@linux.vnet.ibm.com
MIME-Version: 1.0
Subject: Re: [PATCH 0/9][v2] dasd: implement block timeout
X-KeepSent: D72BD141:262FC15D-C1257B03:00583EF8;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 8.5.3 September 15, 2011
From: Stefan Weinhuber <WEIN@de.ibm.com>
Message-ID: <OFD72BD141.262FC15D-ONC1257B03.00583EF8-C1257B03.00595C7E@de.ibm.com>
Date: Wed, 30 Jan 2013 17:15:54 +0100
X-MIMETrack: Serialize by Router on D06ML030/06/M/IBM(Release 8.5.3 ZX853HP5|January 12, 2012) at
 30/01/2013 17:15:54,
	Serialize complete at 30/01/2013 17:15:54
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
x-cbid: 13013016-0542-0000-0000-00000446B879
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hannes Reinecke <hare@suse.de> wrote on 2013-01-30 10:26:10:
> This patch series implements a block timeout handler for
> DASDs. The main impetus was to allow for a fixed upper
> timeout value after which a request is aborted.
> This is required eg when implementing a host-based
> mirroring system where otherwise the entire mirror
> would stall under certain circumstances.
> 
> Changes since v1:
> - Fixed lock inversion in dasd_times_out()
> - Checked for 'device->block' when writing to 'timeout' attribute
> - Check against 'UINT_MAX' when verifying the 'timeout' value
> 
> Hannes Reinecke (9):
>   dasd: Clarify comment
>   dasd: make number of retries configurable
>   dasd: process all requests in the device tasklet
>   dasd: Implement block timeout handling
>   dasd: Reduce amount of messages for specific errors
>   dasd: detailed I/O errors
>   block: check for timeout function in blk_rq_timed_out()
>   dasd: Add 'timeout' attribute
>   dasd: Fail all requests when DASD_FLAG_ABORTIO is set
> 
>  arch/s390/include/uapi/asm/dasd.h |    4 +
>  block/blk-core.c                  |    3 +
>  block/blk-timeout.c               |    5 +-
>  drivers/s390/block/dasd.c         |  115 ++++++++++++++++++++++++++
> +++++++----
>  drivers/s390/block/dasd_devmap.c  |   97 
+++++++++++++++++++++++++++++++
>  drivers/s390/block/dasd_diag.c    |    8 ++-
>  drivers/s390/block/dasd_eckd.c    |   15 ++++-
>  drivers/s390/block/dasd_erp.c     |    8 +++
>  drivers/s390/block/dasd_fba.c     |   10 +++-
>  drivers/s390/block/dasd_int.h     |   10 +++
>  drivers/s390/block/dasd_ioctl.c   |   59 +++++++++++++++++++
>  11 files changed, 313 insertions(+), 21 deletions(-)
> 
> -- 
> 1.7.4.2
> 

This patch set looks fine to me now. Thanks!

Acked-by: Stefan Weinhuber <wein@de.ibm.com>

Mit freundlichen Grüßen / Kind regards
 
Stefan Weinhuber

-- 
Linux for zSeries kernel development
IBM Systems &Technology Group, Systems Software Development / SW Linux für 
zSeries Entwicklung

IBM Deutschland
Schoenaicher Str. 220
71032 Boeblingen
Phone: +49-7031-16-4018
E-Mail: wein@de.ibm.com

IBM Deutschland Research & Development GmbH / Vorsitzender des 
Aufsichtsrats: Martina Koederitz
Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: Amtsgericht Stuttgart, 
HRB 243294

