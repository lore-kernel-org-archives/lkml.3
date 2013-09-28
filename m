Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab3I1Lt6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 07:49:58 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:34506 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654Ab3I1Ltz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 07:49:55 -0400
Date: Sat, 28 Sep 2013 07:49:50 -0400
From: Tejun Heo <tj@kernel.org>
To: Xiangliang Yu <yxlraid@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] AHCI: disabled FBS prior to issuing software reset
Message-ID: <20130928114950.GA2620@htj.dyndns.org>
References: <1380366816-16221-1-git-send-email-yxlraid@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380366816-16221-1-git-send-email-yxlraid@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Sep 28, 2013 at 07:13:36PM +0800, Xiangliang Yu wrote:
> If device is attached to port multiplier, the detection process
> look like this:
> 	ahci_hardreset(link, class, deadline)
> 	if (class == ATA_DEV_PMP) {
> 		sata_pmp_attach(dev)    /* will enable FBS */
> 		sata_pmp_init_links(ap, nr_ports);
> 		ata_for_each_link(link, ap, EDGE) {
> 			sata_std_hardreset(link, class, deadline);
> 			if (link_is_online)
> 				ahci_softreset(link, class, deadline);
> 		}
> 	}
> But, according to chapter 9.3.9 in AHCI spec: Prior to issuing software reset,
> software shall clear PxCMD.ST to '0' and then clear PxFBS.EN to '0'.

How was this tested?  Do you observe any behavior difference?  At this
point, we are not using SRST on PMP ports anyway, so I can't see how
this would make any difference.

Thanks.

-- 
tejun
