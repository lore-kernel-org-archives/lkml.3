Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415AbbAUKOG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 05:14:06 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:45784 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbbAUKN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 05:13:58 -0500
X-IronPort-AV: E=Sophos;i="5.09,440,1418083200"; 
   d="scan'208";a="220136804"
Message-ID: <54BF7BE4.2080005@citrix.com>
Date: Wed, 21 Jan 2015 11:13:56 +0100
From: =?windows-1252?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Bob Liu <bob.liu@oracle.com>, <xen-devel@lists.xen.org>
CC: <david.vrabel@citrix.com>, <linux-kernel@vger.kernel.org>,
        <konrad.wilk@oracle.com>
Subject: Re: [RESEND PATCH] xen/blkfront: increase the default value of xen_blkif_max_segments
References: <1421826963-6497-1-git-send-email-bob.liu@oracle.com>
In-Reply-To: <1421826963-6497-1-git-send-email-bob.liu@oracle.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El 21/01/15 a les 8.56, Bob Liu ha escrit:
> The default max-segments of indirect requests was 32, so IO operations with
> bigger block size(>32*4k) would be split and make performance drop.
> 
> Nowadays backend device usually support 512k max_sectors_kb on desktop,
> and usually larger on server machines connected with high-end storage system.
> The default max size(128k) is not appropriate anymore, this patch increases it
> to 128(128*4k=512k).
> 
> Signed-off-by: Bob Liu <bob.liu@oracle.com>

Looks fine to me, the Linux backend is also prepared to handle it
without any modifications. As I said in the last version, I would add
the following to the commit message:

This change implies we can now have 32*128+32 = 4128 in-flight grants,
which greatly surpasses the default amount of persistent grants blkback
can handle, so the LRU in blkback will kick in.

Roger.
