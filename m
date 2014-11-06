Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252AbaKFReZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 12:34:25 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:46025 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbaKFReV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 12:34:21 -0500
To: Chris Friesen <chris.friesen@windriver.com>
Cc: Jens Axboe <axboe@kernel.dk>, lkml <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, Mike Snitzer <snitzer@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: absurdly high "optimal_io_size" on Seagate SAS disk
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <545BA625.40308@windriver.com> <545BAD05.3050800@windriver.com>
Date: Thu, 06 Nov 2014 12:34:14 -0500
In-Reply-To: <545BAD05.3050800@windriver.com> (Chris Friesen's message of
	"Thu, 6 Nov 2014 11:16:53 -0600")
Message-ID: <yq1k338b5d5.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Chris" == Chris Friesen <chris.friesen@windriver.com> writes:

Chris> Perhaps the ST900MM0026 should be blacklisted as well?

Sure. I'll widen the net a bit for that Seagate model.

commit 17f1ee2d16a6878269c4429306f6e678b7e61505
Author: Martin K. Petersen <martin.petersen@oracle.com>
Date:   Thu Nov 6 12:31:43 2014 -0500

    SCSI: Blacklist ST900MM0026
    
    Looks like this entire series of drives reports the wrong values in the
    block limits VPD. Widen the blacklist.
    
    Reported-by: Chris Friesen <chris.friesen@windriver.com>
    Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 49014a143c6a..9116531b415a 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -229,7 +229,7 @@ static struct {
 	{"SanDisk", "ImageMate CF-SD1", NULL, BLIST_FORCELUN},
 	{"SEAGATE", "ST34555N", "0930", BLIST_NOTQ},	/* Chokes on tagged INQUIRY */
 	{"SEAGATE", "ST3390N", "9546", BLIST_NOTQ},
-	{"SEAGATE", "ST900MM0006", NULL, BLIST_SKIP_VPD_PAGES},
+	{"SEAGATE", "ST900MM", NULL, BLIST_SKIP_VPD_PAGES},
 	{"SGI", "RAID3", "*", BLIST_SPARSELUN},
 	{"SGI", "RAID5", "*", BLIST_SPARSELUN},
 	{"SGI", "TP9100", "*", BLIST_REPORTLUN2},
