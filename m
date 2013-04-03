Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762891Ab3DCGkD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 02:40:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63927 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758254Ab3DCGkB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 02:40:01 -0400
Date: Wed, 3 Apr 2013 12:09:52 +0530 (IST)
From: P J P <ppandit@redhat.com>
X-X-Sender: pjp@javelin.pnq.redhat.com
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Petr Matousek <pmatouse@redhat.com>
Subject: Re: [PATCH] To add NULL pointer check
In-Reply-To: <1364958193.4353.4.camel@kjgkr>
Message-ID: <alpine.LFD.2.03.1304031203050.21402@erqung.pbz>
References: <alpine.LFD.2.03.1304021808410.12716@erqung.pbz> <1364958193.4353.4.camel@kjgkr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello Jaegeuk,
+-- On Wed, 3 Apr 2013, Jaegeuk Kim wrote --+
| Therefore, I think f2fs_write_data_pages() is better to handle this. Please 
| review the modified patch. Thanks,
| 
| diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
| index 47a2d7c..cf9ff5f 100644
| --- a/fs/f2fs/data.c
| +++ b/fs/f2fs/data.c
| @@ -559,6 +559,10 @@ static int f2fs_write_data_pages(struct
| address_space *mapping,
|  	int ret;
|  	long excess_nrtw = 0, desired_nrtw;
|  
| +	/* deal with chardevs and other special file */
| +	if (!mapping->a_ops->writepage)
| +		return 0;
| +
|  	if (wbc->nr_to_write < MAX_DESIRED_PAGES_WP) {
|  		desired_nrtw = MAX_DESIRED_PAGES_WP;
|  		excess_nrtw = desired_nrtw - wbc->nr_to_write;
| 

  Yeah, I considered this, it saves us a call to `write_cache_pages'; But then 
thought it'll help if `__f2fs_writepage' is called from other place later.

I agree, above patch serves too.

Thank you.
--
Prasad J Pandit / Red Hat Security Response Team
DB7A 84C5 D3F9 7CD1 B5EB  C939 D048 7860 3655 602B
