Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933219AbaLJUtT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 15:49:19 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:20571 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932136AbaLJUtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 15:49:17 -0500
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: martin.petersen@oracle.com, jejb@kernel.org, hch@infradead.org,
        linux-scsi@vger.kernel.org, JBottomley@Parallels.com,
        Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/22] [SCSI] mpt2sas, mpt3sas: Added a support to set cpu affinity for each MSIX vector enabled by the HBA
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1418127401-10090-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Date: Wed, 10 Dec 2014 15:48:45 -0500
In-Reply-To: <1418127401-10090-1-git-send-email-Sreekanth.Reddy@avagotech.com>
	(Sreekanth Reddy's message of "Tue, 9 Dec 2014 17:46:41 +0530")
Message-ID: <yq11to7dydu.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Sreekanth" == Sreekanth Reddy <sreekanth.reddy@avagotech.com> writes:

Sreekanth,

@@ -1373,20 +1380,30 @@ _base_assign_reply_queues(struct MPT2SAS_ADAPTER *ioc)
 
 	cpu = cpumask_first(cpu_online_mask);
 
-	do {
+	list_for_each_entry(reply_q, &ioc->reply_queue_list, list) {
+

Why are you reverting to iterating over the queues? A while back I fixed
this up so it wouldn't fail when nr_cpus > the number of reply queues.

-- 
Martin K. Petersen	Oracle Linux Engineering
