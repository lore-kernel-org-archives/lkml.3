Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348AbaAOXD6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 18:03:58 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:58238 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018AbaAOXDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 18:03:54 -0500
Message-ID: <1389827148.5567.597.camel@haakon3.risingtidesystems.com>
Subject: [LSF/MM TOPIC] [ATTEND] scsi-mq
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: lsf-pc@lists.linux-foundation.org
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 15 Jan 2014 15:05:48 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I'd like to discuss the current state of scsi-mq prototype code.

And now that blk-mq is upstream for v3.13, exploring the remaining TODO
items towards an initial scsi-mq merge sometime before 2015 is upon us.

The benefits of scsi-mq remain unchanged:

  - Utilizes blk-mq's native per-cpu primitive + NUMA local friendly 
    queuing of pre-allocated struct request descriptor memory
  - Eliminates all fast-path memory allocations in SCSI-core + 
    optionally the underlying SCSI LLDs
  - Avoids fast-path Scsi_Host->host_lock + request_queue->queue_lock 
    accesses in submission + completion paths

These benefits have been discussed in greater detail in [1], and the
latest alpha quality code is available at [2] below.

The current TODO items include:

 - A plan for per device SCSI error handling
 - Proper scsi_device->sdev_gendev reference counting
 - Queuing fairness across multiple scsi-mq devices per host
 - Support for > 1 nr_hw_queues + conversion of qla2xxx + lpfc 
   LLDs that support native hardware multiqueue

Thank you,

--nab

References:

[1]:
[ATTEND] scsi-mq prototype discussion
http://marc.info/?l=linux-scsi&m=137358831329753&w=2

[2]:
scsi-mq WIP updated to v3.13-rc3
http://marc.info/?l=linux-scsi&m=138782535731722&w=2

