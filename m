Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751437AbaALMeB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 07:34:01 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:33731 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbaALMd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 07:33:57 -0500
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sagi Grimberg <sagig@mellanox.com>,
        "Nicholas A. Bellinger" <nab@daterainc.com>,
        target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: Re: [PATCH 07/14] target/sbc: Add P_TYPE + PROT_EN bits to READ_CAPACITY_16
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1389212157-14540-1-git-send-email-nab@daterainc.com>
	<1389212157-14540-8-git-send-email-nab@daterainc.com>
	<52CE78EB.60108@mellanox.com> <yq1mwj3r2py.fsf@sermon.lab.mkp.net>
	<52D286D9.5050500@dev.mellanox.co.il>
Date: Sun, 12 Jan 2014 07:33:40 -0500
In-Reply-To: <52D286D9.5050500@dev.mellanox.co.il> (Sagi Grimberg's message of
	"Sun, 12 Jan 2014 14:13:13 +0200")
Message-ID: <yq17ga5pefv.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130005 (Ma Gnus v0.5) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Sagi" == Sagi Grimberg <sagig@dev.mellanox.co.il> writes:

>> I don't know of any non-disk devices that actually implement FORMAT
>> UNIT. Usually such configuration is done using the array management
>> interface.

Sagi> So this takes me to a corner I still don't understand, if a LUN is
Sagi> pre-formatted as T10-protected, what happens to unwritten blocks
Sagi> read?  I mean, SCSI login executes some reads from sevel LBAs
Sagi> which will probably fail as blocks are unwritten.

Per SBC, PI must be initialized to 0xffffffffffffffff. Since an app tag
value of 0xffff is an escape, this will prevent both target and
initiator from performing PI-verification when that block is read.

If a block is subsequently written and no PI is sent from the host
(WRPROTECT=0), the target must generate valid PI for each block.

-- 
Martin K. Petersen	Oracle Linux Engineering
