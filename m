Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927AbaAJVBg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 16:01:36 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:36463 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbaAJVBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 16:01:34 -0500
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: Re: [PATCH 09/14] target/configfs: Expose protection device attributes
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1389212157-14540-1-git-send-email-nab@daterainc.com>
	<1389212157-14540-10-git-send-email-nab@daterainc.com>
Date: Fri, 10 Jan 2014 16:01:23 -0500
In-Reply-To: <1389212157-14540-10-git-send-email-nab@daterainc.com> (Nicholas
	A. Bellinger's message of "Wed, 8 Jan 2014 20:15:52 +0000")
Message-ID: <yq161prr1p8.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130005 (Ma Gnus v0.5) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "nab" == Nicholas A Bellinger <nab@daterainc.com> writes:

nab> This patch adds support for exposing DIF protection device
nab> attributes via configfs.  This includes:

nab>    pi_prot_type: Protection Type (0, 1, 3 currently support)
nab>    pi_prot_version: Protection Version (DIF v1 currently supported)

What's DIF v2?

nab>    pi_guard_type: Guard Type (1=DIF CRC, 2=IP CRC)

The IP checksum is only supported by DIX between OS and initiator, not
by the target. I guess we could signal to the initiator via a
vendor-private VPD that IP checksum is supported directly. But now what
we have hardware-accelerated T10 CRC I don't think it's a big deal.

(scsi_debug supports IP checksum because it's both initiator and
target).

-- 
Martin K. Petersen	Oracle Linux Engineering
