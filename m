Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934304AbaGYQ57 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 12:57:59 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:33330 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932508AbaGYQ54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 12:57:56 -0400
To: KY Srinivasan <kys@microsoft.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sitsofe Wheeler <sitsofe@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        "gregkh\@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel\@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "ohering\@suse.com" <ohering@suse.com>,
        "apw\@canonical.com" <apw@canonical.com>,
        "jasowang\@redhat.com" <jasowang@redhat.com>,
        "jbottomley\@parallels.com" <jbottomley@parallels.com>,
        "linux-scsi\@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] [SCSI] Make LBP quirk skip lbpme checks tests
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20140724122223.GA31798@sucs.org>
	<yq1iommkgkv.fsf@sermon.lab.mkp.net> <20140724153612.GA23648@sucs.org>
	<yq1egxakb0z.fsf@sermon.lab.mkp.net>
	<16fea5bb87ba47019527cee788e07a72@BY2PR0301MB0711.namprd03.prod.outlook.com>
Date: Fri, 25 Jul 2014 12:57:02 -0400
In-Reply-To: <16fea5bb87ba47019527cee788e07a72@BY2PR0301MB0711.namprd03.prod.outlook.com>
	(KY Srinivasan's message of "Fri, 25 Jul 2014 16:47:35 +0000")
Message-ID: <yq1wqb1gyw1.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130012 (Ma Gnus v0.12) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "KY" == KY Srinivasan <kys@microsoft.com> writes:

KY> For the pass through case, the host validates the request and passes
KY> the request to the device.  However, not all scsi commands are
KY> passed through even though the device it is being passed through may
KY> support the command. WRITE_SAME is one such command. Consequently,
KY> in the EVPD page, we will set state indicating that WRITE_SAME is
KY> not supported (even if the device supports it).

The LBP VPD page flags UNMAP as being supported. Do you actually support
UNMAP to DSM TRIM SCSI-ATA translation?

One challenge in that department is that a single UNMAP command may turn
into many, many, many DSM TRIM commands on the underlying SATA device.
That's why we went with WRITE SAME for the internal Linux SATL, capping
the maximum number of blocks to what we can fit in a single DSM TRIM
command.

-- 
Martin K. Petersen	Oracle Linux Engineering
