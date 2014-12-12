Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964937AbaLLDED (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 22:04:03 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:39113 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbaLLDEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 22:04:01 -0500
To: Long Li <longli@microsoft.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "JBottomley\@parallels.com" <JBottomley@parallels.com>,
        "linux-scsi\@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "devel\@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi:storvsc enable reading from VPD pages on SPC-2
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1418200705-488-1-git-send-email-longli@microsoft.com>
	<yq1h9x3cipr.fsf@sermon.lab.mkp.net>
	<BL2PR03MB1324E11F2CB6EC2652C2F85CE620@BL2PR03MB132.namprd03.prod.outlook.com>
Date: Thu, 11 Dec 2014 22:03:44 -0500
In-Reply-To: <BL2PR03MB1324E11F2CB6EC2652C2F85CE620@BL2PR03MB132.namprd03.prod.outlook.com>
	(Long Li's message of "Wed, 10 Dec 2014 22:28:07 +0000")
Message-ID: <yq1vblhbmcv.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Long" == Long Li <longli@microsoft.com> writes:

>> Handle the issues or handle WRITE SAME(10/16)?

Long> With this patch, the SCSI layer will be able to correctly send
Long> WRITE_SAME_16 to the Hyper-V host. It will not send WRITE_SAME_10:
Long> it has been disabled in the driver template. Do you want me to
Long> send another patch with these details?

no_write_same prevents us from attempting to use WRITE SAME(10/16) to
zero block ranges.

This is completely orthogonal to using the WRITE SAME(10/16) commands
with the UNMAP bit set to discard block ranges. The latter is controlled
by the logical block provisioning heuristics and is not affected by
no_write_same at all.

-- 
Martin K. Petersen	Oracle Linux Engineering
