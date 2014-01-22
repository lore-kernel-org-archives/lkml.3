Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528AbaAVBxM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 20:53:12 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:18069 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910AbaAVBxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 20:53:09 -0500
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>,
        target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>,
        Roland Dreier <roland@kernel.org>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: Re: [PATCH-v2 11/17] target/iblock: Add blk_integrity + BIP passthrough support
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1390099480-29013-1-git-send-email-nab@daterainc.com>
	<1390099480-29013-12-git-send-email-nab@daterainc.com>
	<52DBC32C.4060505@dev.mellanox.co.il>
Date: Tue, 21 Jan 2014 20:52:49 -0500
In-Reply-To: <52DBC32C.4060505@dev.mellanox.co.il> (Sagi Grimberg's message of
	"Sun, 19 Jan 2014 14:21:00 +0200")
Message-ID: <yq1fvogbx5a.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130005 (Ma Gnus v0.5) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Sagi" == Sagi Grimberg <sagig@dev.mellanox.co.il> writes:

Sagi> Please remind me why we ignore IP-CSUM guard type again?  MKP,
Sagi> will this be irrelevant for the initiator as well? if so, I don't
Sagi> see a reason to expose this in RDMA verbs.

I don't see much use for IP checksum for the target. You are required by
SBC to use T10 CRC on the wire so there is no point in converting to IP
checksum in the backend.

My impending patches will allow you to pass through PI with T10 CRC to a
device with an IP checksum block integrity profile (i.e. the choice of
checksum is a per-bio bip flag instead of an HBA-enforced global).

-- 
Martin K. Petersen	Oracle Linux Engineering
