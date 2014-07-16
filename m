Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934583AbaGPPpF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 11:45:05 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:45581 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934391AbaGPPpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 11:45:00 -0400
To: "hch\@infradead.org" <hch@infradead.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        KY Srinivasan <kys@microsoft.com>,
        James Bottomley <jbottomley@parallels.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel\@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "apw\@canonical.com" <apw@canonical.com>,
        "stable\@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-scsi\@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "ohering\@suse.com" <ohering@suse.com>,
        "jasowang\@redhat.com" <jasowang@redhat.com>
Subject: Re: [PATCH 4/8] Drivers: scsi: storvsc: Filter WRITE_SAME_16
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1404866812-26950-1-git-send-email-kys@microsoft.com>
	<1404866812-26950-4-git-send-email-kys@microsoft.com>
	<20140709084300.GD6012@infradead.org>
	<a31a45eddb544024a7538458b98c3611@BY2PR03MB299.namprd03.prod.outlook.com>
	<1404935792.2184.5.camel@dabdike.int.hansenpartnership.com>
	<2f3ae589e6f149acbe4c5dd79f905971@BY2PR03MB299.namprd03.prod.outlook.com>
	<1404944843.2184.8.camel@dabdike.int.hansenpartnership.com>
	<20140711063216.GA20660@infradead.org>
	<328b7a6174ef4dd8a54a7db5ac959834@BY2PR03MB299.namprd03.prod.outlook.com>
	<yq1a98d2z5x.fsf@sermon.lab.mkp.net>
	<20140716110111.GA7382@infradead.org>
Date: Wed, 16 Jul 2014 11:44:18 -0400
In-Reply-To: <20140716110111.GA7382@infradead.org> (hch@infradead.org's
	message of "Wed, 16 Jul 2014 04:01:11 -0700")
Message-ID: <yq14myhtijx.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130012 (Ma Gnus v0.12) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "hch" == hch@infradead org <hch@infradead.org> writes:

hch> read_capacity_16 calls sd_config_discard(sdkp, SD_LBP_WS16) if the
hch> LPBME bit is set.  At least older SBC drafts left it wide open if a
hch> target supports WRITE SAME with UNMAP or UNMAP in this case.

Correct.

hch> So I think we'd still want a patch to use UNMAP instead of WRITE
hch> SAME for this case, which should also fix hyperv. 

There are lots of devices out there that support WRITE SAME(10) or (16)
without the UNMAP bit. And there are devices that support WRITE SAME w/
UNMAP functionality but not "regular" WRITE SAME.

no_write_same is there to prevent the REQ_WRITE_SAME use case (for which
we have really weak heuristics). Your patch overloads no_write_same so
it also governs a REQ_DISCARD use case.

My proposed black list patch fixes the hyperv discard issue. So I don't
see why we'd need to overload no_write_same which was meant for an
entirely different purpose.

-- 
Martin K. Petersen	Oracle Linux Engineering
