Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287AbaAMUUK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 15:20:10 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:26571 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbaAMUUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 15:20:06 -0500
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Nicholas A. Bellinger" <nab@daterainc.com>,
        target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>
Subject: Re: [PATCH 09/14] target/configfs: Expose protection device attributes
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1389212157-14540-1-git-send-email-nab@daterainc.com>
	<1389212157-14540-10-git-send-email-nab@daterainc.com>
	<yq161prr1p8.fsf@sermon.lab.mkp.net>
	<1389637859.5567.431.camel@haakon3.risingtidesystems.com>
	<1389639177.12062.21.camel@dabdike.int.hansenpartnership.com>
	<1389641243.5567.445.camel@haakon3.risingtidesystems.com>
Date: Mon, 13 Jan 2014 15:19:47 -0500
In-Reply-To: <1389641243.5567.445.camel@haakon3.risingtidesystems.com>
	(Nicholas A. Bellinger's message of "Mon, 13 Jan 2014 11:27:23 -0800")
Message-ID: <yq1a9ezocrg.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130005 (Ma Gnus v0.5) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "nab" == Nicholas A Bellinger <nab@linux-iscsi.org> writes:

>> What proposed 16 byte scheme?  The only DIF proposals I know for
>> SBC-4 are 13-185R0 and 12-369R0 and that's a couple of new algorithms
>> and types because we cannot change the 8 byte PI.

nab> Then I'm probably getting the SBC version wrong..  It's the one
nab> that includes using CRC32C for the block guard, and larger space
nab> for reference tag as mentioned by MKP.

This is the Type 4 we have been shopping among various vendors. It
predates and is simpler than HP's proposal (which met resistance in T10
and was subsequently dropped). So we revived our original Type 4
proposal which is 16 bytes of protection information per interval
(CRC32C, 48-bit LBA and 6 bytes of app tag). The proposal has been
sitting around for a while waiting for SBC-4 to open.

-- 
Martin K. Petersen	Oracle Linux Engineering
