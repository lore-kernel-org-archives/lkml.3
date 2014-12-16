Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751101AbaLPKcg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 05:32:36 -0500
Received: from smtp.citrix.com ([66.165.176.89]:62059 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885AbaLPKcf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 05:32:35 -0500
X-IronPort-AV: E=Sophos;i="5.07,585,1413244800"; 
   d="scan'208";a="204831253"
Message-ID: <54900A3F.7070300@citrix.com>
Date: Tue, 16 Dec 2014 11:32:31 +0100
From: =?windows-1252?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Bob Liu <bob.liu@oracle.com>, <xen-devel@lists.xen.org>
CC: <david.vrabel@citrix.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] xen/blkfront: increase the default value
 of xen_blkif_max_segments
References: <1418724696-23922-1-git-send-email-bob.liu@oracle.com>
In-Reply-To: <1418724696-23922-1-git-send-email-bob.liu@oracle.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El 16/12/14 a les 11.11, Bob Liu ha escrit:
> The default maximum value of segments in indirect requests was 32, IO
> operations with bigger block size(>32*4k) would be split and performance start
> to drop.
> 
> Nowadays backend device usually support 512k max_sectors_kb on desktop, and
> may larger on server machines with high-end storage system.
> The default size 128k was not very appropriate, this patch increases the default
> maximum value to 128(128*4k=512k).

This looks fine, do you have any data/graphs to backup your reasoning?

I would also add to the commit message that this change implies we can
now have 32*128+32 = 4128 in-flight grants, which greatly surpasses the
default amount of persistent grants blkback can handle, so the LRU in
blkback will kick in.

Roger.

