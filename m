Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756732AbaLIMIi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 07:08:38 -0500
Received: from exprod7og111.obsmtp.com ([64.18.2.175]:37713 "EHLO
	exprod7og111.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756675AbaLIMIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 07:08:34 -0500
MIME-Version: 1.0
In-Reply-To: <yq1a934i055.fsf@sermon.lab.mkp.net>
References: <1416467155-16869-1-git-send-email-Sreekanth.Reddy@avagotech.com>
	<1416467155-16869-8-git-send-email-Sreekanth.Reddy@avagotech.com>
	<yq1a934i055.fsf@sermon.lab.mkp.net>
Date: Tue, 9 Dec 2014 17:38:32 +0530
Message-ID: <CAK=zhgr-+MaT6UeXR96G-nMGfo8RdmHVRN1wkUKjz7h6gwLNhg@mail.gmail.com>
Subject: Re: [PATCH 07/22] [SCSI] mpt2sas: Complete the SCSI command with
 DID_RESET status for log_info value 0x0x32010081
From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: jejb@kernel.org, Christoph Hellwig <hch@infradead.org>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Sathya Prakash <Sathya.Prakash@avagotech.com>,
        Nagalakshmi Nandigama <Nagalakshmi.Nandigama@avagotech.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 4, 2014 at 8:36 AM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> "Sreekanth" == Sreekanth Reddy <sreekanth.reddy@avagotech.com> writes:
>
> Sreekanth> For any SCSI command, if the driver receives IOC status =
> Sreekanth> SCSI_IOC_TERMINATED and log info = 0x32010081 then that
> Sreekanth> command will be completed with DID_RESET host status.
>
> What does that log info value mean?

The meaning of this log info value is "Virtual IO has failed and has
to be retried".

Firmware will provide this log info value with IOC Status
"SCSI_IOC_TERMINATED", whenever a drive (with is a part of a volume)
is pulled and pushed back with some minimal delay.  With this log info
value, firmware informs the driver to retry the failed IO command
infinite times, so to provide some time for the firmware to discover
the reinserted drive successfully instated of just retrying failed
command for five times( doesn't giving enough time for firmware to
complete the drive discovery) and failing the IO permanently even
though drive came back successfully.

Regards,
Sreekanth.
