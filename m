Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759AbaHUVGu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 17:06:50 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:19397 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818AbaHUVGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 17:06:48 -0400
To: "Reddy\, Sreekanth" <Sreekanth.Reddy@avagotech.com>
Cc: <jejb@kernel.org>, <JBottomley@Parallels.com>,
        <linux-scsi@vger.kernel.org>, <Sathya.Prakash@avagotech.com>,
        <Nagalakshmi.Nandigama@avagotech.com>, <linux-kernel@vger.kernel.org>,
        <hch@infradead.org>, <martin.petersen@oracle.com>
Subject: Re: [RESEND][PATCH 09/10][SCSI]mpt2sas: Added module parameter 'unblock_io' to unblock IO's during disk addition
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20140625103615.GA12959@avagotech.com>
Date: Thu, 21 Aug 2014 17:06:15 -0400
In-Reply-To: <20140625103615.GA12959@avagotech.com> (Sreekanth Reddy's message
	of "Wed, 25 Jun 2014 16:06:15 +0530")
Message-ID: <yq1oavdr1rs.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Sreekanth" == Reddy, Sreekanth <Sreekanth.Reddy@avagotech.com> writes:

Sreekanth> This is because, when driver receives DELAY_NOT_RESPONDING
Sreekanth> for a disk when it is undergoing addition in the SCSI Mid
Sreekanth> layer, the driver would block the I/O to that disk resulting
Sreekanth> in a deadlock. i.e the disk addition work couldn't be
Sreekanth> completed as it can't send any I/O to the disk as I/Os are
Sreekanth> blocked. Any device removal (TARGET_NOT_RESPONDING) or link
Sreekanth> update(RC_PHY_CHANGED) couldn't be processed as they are in
Sreekanth> the queue to get processed after disk addition.

Sreekanth> An module parameter 'unblock_io' is introduced which needs to
Sreekanth> be set to have this functionality enabled. By default this
Sreekanth> functionality is disabled.

This really sounds like a scenario you should be able to handle in
general (without special "don't-be-broken" module parameters).

Also, shouldn't your internal task management be able to deal with this?
Why does the sdev's state during probe affect your ability to make
forward progress?

-- 
Martin K. Petersen	Oracle Linux Engineering
