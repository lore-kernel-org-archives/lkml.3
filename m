Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710AbaAPBmd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 20:42:33 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:27776 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbaAPBm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 20:42:27 -0500
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: sagi grimberg <sagig@mellanox.com>,
        "Nicholas A. Bellinger" <nab@daterainc.com>,
        target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Or Gerlitz <ogerlitz@mellanox.com>
Subject: Re: [PATCH 00/14] target: Initial support for DIF Type1+Type3 emulation
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1389212157-14540-1-git-send-email-nab@daterainc.com>
	<52D6CD70.20706@mellanox.com>
	<1389822920.5567.560.camel@haakon3.risingtidesystems.com>
Date: Wed, 15 Jan 2014 20:42:11 -0500
In-Reply-To: <1389822920.5567.560.camel@haakon3.risingtidesystems.com>
	(Nicholas A. Bellinger's message of "Wed, 15 Jan 2014 13:55:20 -0800")
Message-ID: <yq1wqi0wvm4.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130005 (Ma Gnus v0.5) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "nab" == Nicholas A Bellinger <nab@linux-iscsi.org> writes:

nab> The issue is that existing fs/bio-integrity.c code always assumes
nab> client/initiator mode, in that it will attempt to
nab> bio_integrity_generate() protection information in the submit_bio
nab> WRITE path, and bio_integrity_verify() of protection information in
nab> the bio_endio READ completion path.

Only if the submit_bio() caller hasn't attached protection information
already. If you submit a bio with a bip already attached the block layer
will not generate/verify.

-- 
Martin K. Petersen	Oracle Linux Engineering
