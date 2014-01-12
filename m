Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751375AbaALLxe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 06:53:34 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:58119 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbaALLxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 06:53:32 -0500
Message-ID: <52D28238.5010903@dev.mellanox.co.il>
Date: Sun, 12 Jan 2014 13:53:28 +0200
From: Sagi Grimberg <sagig@dev.mellanox.co.il>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Sagi Grimberg <sagig@mellanox.com>
CC: "Nicholas A. Bellinger" <nab@daterainc.com>,
        target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Or Gerlitz <ogerlitz@mellanox.com>
Subject: Re: [PATCH 13/14] target/rd: Add DIF protection into rd_execute_rw
References: <1389212157-14540-1-git-send-email-nab@daterainc.com>	 <1389212157-14540-14-git-send-email-nab@daterainc.com>	 <52CE7ABA.9080403@mellanox.com> <1389336761.5567.403.camel@haakon3.risingtidesystems.com>
In-Reply-To: <1389336761.5567.403.camel@haakon3.risingtidesystems.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<SNIP>

>> I wander how we can skip  sbc_dif_verify_xxxx if the transport already
>> offloaded DIF verify.
>> I think that the transport should signal the core layer that it is able
>> to offload DIF (ADD/STRIP/PASS/VERIFY), in which case the core should
>> turn off the backstore DIF verify emulation to sustain performance.
> So IBLOCK + PSCSI backends will need to be a non interleaved protection
> PASS for fast path operation, and backend protection emulation is
> reserved for RAMDISK and perhaps a special FILEIO full emulation mode.

But can't we avoid that if transport already verified? This will kill 
performance.

