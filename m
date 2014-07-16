Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935012AbaGPSqi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 14:46:38 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:47213 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934772AbaGPSqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 14:46:34 -0400
To: James Bottomley <jbottomley@parallels.com>
Cc: "martin.petersen\@oracle.com" <martin.petersen@oracle.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch\@infradead.org" <hch@infradead.org>,
        "devel\@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "apw\@canonical.com" <apw@canonical.com>,
        "kys\@microsoft.com" <kys@microsoft.com>,
        "stable\@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-scsi\@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "ohering\@suse.com" <ohering@suse.com>,
        "jasowang\@redhat.com" <jasowang@redhat.com>
Subject: Re: [PATCH 4/8] Drivers: scsi: storvsc: Filter WRITE_SAME_16
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20140709084300.GD6012@infradead.org>
	<a31a45eddb544024a7538458b98c3611@BY2PR03MB299.namprd03.prod.outlook.com>
	<1404935792.2184.5.camel@dabdike.int.hansenpartnership.com>
	<2f3ae589e6f149acbe4c5dd79f905971@BY2PR03MB299.namprd03.prod.outlook.com>
	<1404944843.2184.8.camel@dabdike.int.hansenpartnership.com>
	<20140711063216.GA20660@infradead.org>
	<328b7a6174ef4dd8a54a7db5ac959834@BY2PR03MB299.namprd03.prod.outlook.com>
	<yq1a98d2z5x.fsf@sermon.lab.mkp.net>
	<20140716110111.GA7382@infradead.org>
	<yq14myhtijx.fsf@sermon.lab.mkp.net>
	<20140716173827.GB20528@infradead.org>
	<yq1fvi1rya0.fsf@sermon.lab.mkp.net>
	<1405533734.3165.12.camel@dabdike.int.hansenpartnership.com>
Date: Wed, 16 Jul 2014 14:45:46 -0400
In-Reply-To: <1405533734.3165.12.camel@dabdike.int.hansenpartnership.com>
	(James Bottomley's message of "Wed, 16 Jul 2014 18:02:14 +0000")
Message-ID: <yq1bnsprvl1.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130012 (Ma Gnus v0.12) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "James" == James Bottomley <jbottomley@parallels.com> writes:

>> I don't have a problem with a BLIST_PREFER_UNMAP flag or something
>> like that. But BLIST_TRY_VPD_PAGES seems more generally useful and it
>> does fix the problem at hand. That's why I went that route.

James> Hang on ... unless we apply Christoph or my fix, we'll get the
James> same issue with every raid driver (that's about 10 I think) that
James> set no_write_same when they hit a >2TB RAID volume,

no_write_same is set for all the RAID controller drivers (54b2b50c20a6).

If a WRITE SAME(10/16) command fails and the UNMAP bit is not set we'll
set no_write_same=1 and disable REQ_WRITE_SAME support.

If a WRITE SAME(10/16) command fails and the UNMAP bit is set we'll
disable REQ_DISCARD support.

Not sure where the 10 vs. 16 byte 2TB limitation comes into play here?

-- 
Martin K. Petersen	Oracle Linux Engineering
