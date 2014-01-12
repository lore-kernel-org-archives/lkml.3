Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751383AbaALMXn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 07:23:43 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:44663 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbaALMXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 07:23:39 -0500
Message-ID: <52D28946.3000202@dev.mellanox.co.il>
Date: Sun, 12 Jan 2014 14:23:34 +0200
From: Sagi Grimberg <sagig@dev.mellanox.co.il>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sagi Grimberg <sagig@mellanox.com>
CC: "Nicholas A. Bellinger" <nab@daterainc.com>,
        target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Oren Duer <oren@mellanox.com>
Subject: Re: [PATCH 13/14] target/rd: Add DIF protection into rd_execute_rw
References: <1389212157-14540-1-git-send-email-nab@daterainc.com>	<1389212157-14540-14-git-send-email-nab@daterainc.com>	<52CE7ABA.9080403@mellanox.com> <yq11u0fr1gr.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq11u0fr1gr.fsf@sermon.lab.mkp.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/10/2014 11:06 PM, Martin K. Petersen wrote:
>>>>>> "Sagi" == Sagi Grimberg <sagig@mellanox.com> writes:
> Sagi> I wander how we can skip sbc_dif_verify_xxxx if the transport
> Sagi> already offloaded DIF verify.  I think that the transport should
> Sagi> signal the core layer that it is able to offload DIF
> Sagi> (ADD/STRIP/PASS/VERIFY), in which case the core should turn off
> Sagi> the backstore DIF verify emulation to sustain performance.
>
> Yeah, for SAS and FC it would be nice to leverage DIX and let the ASIC
> do the actual checking and splitting. I assume the same is true for your
> hw.
>

Correct! we should avoid a duplicate DIF processing. if the HW supports 
offloading DIF processing, target core can shutdown backstore 
verfy_read/verify_write methods.
