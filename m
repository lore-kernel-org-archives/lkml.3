Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912AbaAPQaA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 11:30:00 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:44745 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273AbaAPQ3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 11:29:55 -0500
Message-ID: <52D808FD.9010007@dev.mellanox.co.il>
Date: Thu, 16 Jan 2014 18:29:49 +0200
From: Sagi Grimberg <sagig@dev.mellanox.co.il>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        lsf-pc@lists.linux-foundation.org
CC: linux-scsi <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [LSF/MM TOPIC] [ATTEND] scsi-mq
References: <1389827148.5567.597.camel@haakon3.risingtidesystems.com>
In-Reply-To: <1389827148.5567.597.camel@haakon3.risingtidesystems.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/16/2014 1:05 AM, Nicholas A. Bellinger wrote:
> Hi all,
>
> I'd like to discuss the current state of scsi-mq prototype code.
>
> And now that blk-mq is upstream for v3.13, exploring the remaining TODO
> items towards an initial scsi-mq merge sometime before 2015 is upon us.
>
> The benefits of scsi-mq remain unchanged:
>
>    - Utilizes blk-mq's native per-cpu primitive + NUMA local friendly
>      queuing of pre-allocated struct request descriptor memory
>    - Eliminates all fast-path memory allocations in SCSI-core +
>      optionally the underlying SCSI LLDs
>    - Avoids fast-path Scsi_Host->host_lock + request_queue->queue_lock
>      accesses in submission + completion paths
>
> These benefits have been discussed in greater detail in [1], and the
> latest alpha quality code is available at [2] below.
>
> The current TODO items include:
>
>   - A plan for per device SCSI error handling
>   - Proper scsi_device->sdev_gendev reference counting
>   - Queuing fairness across multiple scsi-mq devices per host
>   - Support for > 1 nr_hw_queues + conversion of qla2xxx + lpfc
>     LLDs that support native hardware multiqueue
>
> Thank you,
>
> --nab
>
> References:
>
> [1]:
> [ATTEND] scsi-mq prototype discussion
> http://marc.info/?l=linux-scsi&m=137358831329753&w=2
>
> [2]:
> scsi-mq WIP updated to v3.13-rc3
> http://marc.info/?l=linux-scsi&m=138782535731722&w=2
>

+1
I would be happy to join this discussion, I think it is also important 
to think about the interaction with iSCSI and LLDs.

Sagi.

