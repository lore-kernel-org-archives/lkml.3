Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146AbaAJVGz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 16:06:55 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:38510 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbaAJVGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 16:06:47 -0500
To: Sagi Grimberg <sagig@mellanox.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>,
        target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: Re: [PATCH 13/14] target/rd: Add DIF protection into rd_execute_rw
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1389212157-14540-1-git-send-email-nab@daterainc.com>
	<1389212157-14540-14-git-send-email-nab@daterainc.com>
	<52CE7ABA.9080403@mellanox.com>
Date: Fri, 10 Jan 2014 16:06:28 -0500
In-Reply-To: <52CE7ABA.9080403@mellanox.com> (Sagi Grimberg's message of "Thu,
	9 Jan 2014 12:32:26 +0200")
Message-ID: <yq11u0fr1gr.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130005 (Ma Gnus v0.5) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Sagi" == Sagi Grimberg <sagig@mellanox.com> writes:

Sagi> I wander how we can skip sbc_dif_verify_xxxx if the transport
Sagi> already offloaded DIF verify.  I think that the transport should
Sagi> signal the core layer that it is able to offload DIF
Sagi> (ADD/STRIP/PASS/VERIFY), in which case the core should turn off
Sagi> the backstore DIF verify emulation to sustain performance.

Yeah, for SAS and FC it would be nice to leverage DIX and let the ASIC
do the actual checking and splitting. I assume the same is true for your
hw.

-- 
Martin K. Petersen	Oracle Linux Engineering
