Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596AbaJWBuk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 21:50:40 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:45943 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801AbaJWBui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 21:50:38 -0400
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Subject: Re: [PATCH 0/3] scsi: Add Hyper-V logical block provisioning quirks
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20141010074901.GA32028@sucs.org>
	<yq1r3ya6t0i.fsf@sermon.lab.mkp.net> <20141021041707.GA11691@sucs.org>
Date: Wed, 22 Oct 2014 21:50:22 -0400
In-Reply-To: <20141021041707.GA11691@sucs.org> (Sitsofe Wheeler's message of
	"Tue, 21 Oct 2014 05:17:08 +0100")
Message-ID: <yq1a94nwo4h.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Sitsofe" == Sitsofe Wheeler <sitsofe@gmail.com> writes:

Sitsofe> 2. On top of the above, when a disk is "small" (has less than
Sitsofe>    2^32 sectors which is typically < 2 TBytes in size) READ
Sitsofe>    CAPACITY(16) won't be triggered.

static int sd_try_rc16_first(struct scsi_device *sdp)
{
        if (sdp->host->max_cmd_len < 16)
                return 0;
        if (sdp->try_rc_10_first)
                return 0;
        if (sdp->scsi_level > SCSI_SPC_2)
                return 1;
        if (scsi_device_protection(sdp))
                return 1;
        return 0;
}

-- 
Martin K. Petersen	Oracle Linux Engineering
