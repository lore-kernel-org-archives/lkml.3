Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243AbaGMRCm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 13:02:42 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:32795 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990AbaGMRCd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 13:02:33 -0400
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Reddy, Sreekanth" <Sreekanth.Reddy@avagotech.com>
CC: "jejb@kernel.org" <jejb@kernel.org>,
        "JBottomley@Parallels.com" <JBottomley@Parallels.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Sathya.Prakash@avagotech.com" <Sathya.Prakash@avagotech.com>,
        "Nagalakshmi.Nandigama@avagotech.com" 
	<Nagalakshmi.Nandigama@avagotech.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>
Subject: RE: [RESEND][PATCH 06/10][SCSI]mpt2sas: For >2TB volumes,
 DirectDrive support sends IO's with LBA bit 31 to IR FW instead of
 DirectDrive
Thread-Topic: [RESEND][PATCH 06/10][SCSI]mpt2sas: For >2TB volumes,
 DirectDrive support sends IO's with LBA bit 31 to IR FW instead of
 DirectDrive
Thread-Index: AQHPkGGz1fVFRM/I+E28oqcMFbsEH5uePZTogAAX6wA=
Date: Sun, 13 Jul 2014 17:02:21 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958BA02C2@G9W0745.americas.hpqcorp.net>
References: <20140625103418.GA12939@avagotech.com>
 <yq1oawtxoqv.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq1oawtxoqv.fsf@sermon.lab.mkp.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [15.201.58.27]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Martin K. Petersen


...
> Also, this is not touched by the patch, but you're then doing:
> 
>         (*(__be32 *)(&cdb_ptr[i])) = cpu_to_be32(p_lba);
> 
> What if this is a 6-byte READ/WRITE command? You'll end up exceeding the
> size of the LBA field.

All this is inside:
        if (cdb0 == READ_16 || cdb0 == READ_10 ||
            cdb0 == WRITE_16 || cdb0 == WRITE_10) {

so READ_6 and WRITE_6 and all their oddities are not a problem here.



