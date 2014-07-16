Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751473AbaGPTo4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 15:44:56 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:35511 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbaGPTox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 15:44:53 -0400
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
	<yq1bnsprvl1.fsf@sermon.lab.mkp.net>
	<1405536631.3165.23.camel@dabdike.int.hansenpartnership.com>
	<yq17g3drujm.fsf@sermon.lab.mkp.net>
	<1405538056.3165.27.camel@dabdike.int.hansenpartnership.com>
Date: Wed, 16 Jul 2014 15:44:13 -0400
In-Reply-To: <1405538056.3165.27.camel@dabdike.int.hansenpartnership.com>
	(James Bottomley's message of "Wed, 16 Jul 2014 19:14:16 +0000")
Message-ID: <yq1y4vtqeb6.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130012 (Ma Gnus v0.12) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "James" == James Bottomley <jbottomley@parallels.com> writes:

James> Well, your judgement: is this situation (support for UNMAP but
James> not for WRITE_SAME) in what is effectively a RAID driver (hv
James> drivers count as RAID) just a silly Microsoft one off?

I only recall seeing one or two devices that supported LBP but not WRITE
SAME w/UNMAP.

James> However, if we get any RAID drivers with strange discard support,
James> we'll likely get the same problem

The LBP VPD page is mandatory now. It wasn't for the first couple of
generations of devices that we still have to support. I think that if a
vendor were to support LBP, adding the mandatory VPD page would be a
given. And so far nobody has messed up the LBP VPD page contents.

My main gripe about linking no_write_same and discard functionality is
that the heuristics for the latter are already excessively complex
thanks to having to support devices that predate the spec. I'm wary of
adding another dimension to that.

Also, linking the two use cases we can get into inconsistent states
where no_write_same is set but the device does not support UNMAP and has
LBPWS=1 and LBPWS10=1 set in the LBP VPD.

I'll contemplate the LBPME => mandatory VPD lookup thing for bit.

-- 
Martin K. Petersen	Oracle Linux Engineering
