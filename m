Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751450AbaALMxt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 07:53:49 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:35857 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbaALMxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 07:53:46 -0500
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sagi Grimberg <sagig@mellanox.com>,
        "Nicholas A. Bellinger" <nab@daterainc.com>,
        target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Oren Duer <oren@mellanox.com>
Subject: Re: [PATCH 07/14] target/sbc: Add P_TYPE + PROT_EN bits to READ_CAPACITY_16
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1389212157-14540-1-git-send-email-nab@daterainc.com>
	<1389212157-14540-8-git-send-email-nab@daterainc.com>
	<52CE78EB.60108@mellanox.com> <yq1mwj3r2py.fsf@sermon.lab.mkp.net>
	<52D286D9.5050500@dev.mellanox.co.il>
	<yq17ga5pefv.fsf@sermon.lab.mkp.net>
	<52D28ED8.6020102@dev.mellanox.co.il>
Date: Sun, 12 Jan 2014 07:53:28 -0500
In-Reply-To: <52D28ED8.6020102@dev.mellanox.co.il> (Sagi Grimberg's message of
	"Sun, 12 Jan 2014 14:47:20 +0200")
Message-ID: <yq1y52lnyyf.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130005 (Ma Gnus v0.5) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Sagi" == Sagi Grimberg <sagig@dev.mellanox.co.il> writes:

>> Per SBC, PI must be initialized to 0xffffffffffffffff. Since an app
>> tag value of 0xffff is an escape, this will prevent both target and
>> initiator from performing PI-verification when that block is read.

Sagi> OK, so this is an implicit escape (which will become explicit in
Sagi> DIX1.1?). So I will open that in DIF RDMA verbs.

DIX 1.0 says:

"If a storage device returns a value of 0xFFFF in the application tag
and the device is formatted with T10 PI Type 1 or 2 protection, the I/O
controller must disable integrity checking for that sector."

In DIX 1.1 it is explicit by way of the DIX_APP_ESCAPE flag.

-- 
Martin K. Petersen	Oracle Linux Engineering
