Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932297Ab3DCHBp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 03:01:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47149 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762591Ab3DCHBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 03:01:44 -0400
Date: Wed, 3 Apr 2013 12:30:00 +0530 (IST)
From: P J P <ppandit@redhat.com>
X-X-Sender: pjp@javelin.pnq.redhat.com
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Petr Matousek <pmatouse@redhat.com>
Subject: Re: [PATCH] To add NULL pointer check
In-Reply-To: <1364958193.4353.4.camel@kjgkr>
Message-ID: <alpine.LFD.2.03.1304031224180.21402@erqung.pbz>
References: <alpine.LFD.2.03.1304021808410.12716@erqung.pbz> <1364958193.4353.4.camel@kjgkr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+-- On Wed, 3 Apr 2013, Jaegeuk Kim wrote --+
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

  Small question, is it okay to `return 0' here?

Earlier even if `generic_writepages' returned 0, that did not abort routine 
`f2fs_write_data_pages'.

Thank you.
--
Prasad J Pandit / Red Hat Security Response Team
DB7A 84C5 D3F9 7CD1 B5EB  C939 D048 7860 3655 602B
