Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbaAVByd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 20:54:33 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:25214 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338AbaAVByb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 20:54:31 -0500
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Sagi Grimberg <sagig@dev.mellanox.co.il>,
        "Nicholas A. Bellinger" <nab@daterainc.com>,
        target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>,
        Roland Dreier <roland@kernel.org>
Subject: Re: [PATCH-v2 11/17] target/iblock: Add blk_integrity + BIP passthrough support
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1390099480-29013-1-git-send-email-nab@daterainc.com>
	<1390099480-29013-12-git-send-email-nab@daterainc.com>
	<52DBC32C.4060505@dev.mellanox.co.il>
	<1390342817.5567.778.camel@haakon3.risingtidesystems.com>
Date: Tue, 21 Jan 2014 20:54:14 -0500
In-Reply-To: <1390342817.5567.778.camel@haakon3.risingtidesystems.com>
	(Nicholas A. Bellinger's message of "Tue, 21 Jan 2014 14:20:17 -0800")
Message-ID: <yq1bnz4bx2x.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130005 (Ma Gnus v0.5) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "nab" == Nicholas A Bellinger <nab@linux-iscsi.org> writes:

>> Please remind me why we ignore IP-CSUM guard type again?  MKP, will
>> this be irrelevant for the initiator as well? if so, I don't see a
>> reason to expose this in RDMA verbs.

nab> My understanding is that this was used for pre-production
nab> prototyping, and is not supported by any real backend storage
nab> hardware.

We are shipping several products with support for the IP checksum. But
it's between application and initiator only. From there on it's all T10
CRC as required by the spec.

-- 
Martin K. Petersen	Oracle Linux Engineering
