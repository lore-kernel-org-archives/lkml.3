Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934783AbaGPRzb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 13:55:31 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:46842 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932418AbaGPRzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 13:55:24 -0400
Date: Wed, 16 Jul 2014 10:55:22 -0700
From: "hch@infradead.org" <hch@infradead.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: KY Srinivasan <kys@microsoft.com>,
        James Bottomley <jbottomley@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: Re: [PATCH 4/8] Drivers: scsi: storvsc: Filter WRITE_SAME_16
Message-ID: <20140716175522.GA29315@infradead.org>
References: <1404935792.2184.5.camel@dabdike.int.hansenpartnership.com>
 <2f3ae589e6f149acbe4c5dd79f905971@BY2PR03MB299.namprd03.prod.outlook.com>
 <1404944843.2184.8.camel@dabdike.int.hansenpartnership.com>
 <20140711063216.GA20660@infradead.org>
 <328b7a6174ef4dd8a54a7db5ac959834@BY2PR03MB299.namprd03.prod.outlook.com>
 <yq1a98d2z5x.fsf@sermon.lab.mkp.net>
 <20140716110111.GA7382@infradead.org>
 <yq14myhtijx.fsf@sermon.lab.mkp.net>
 <20140716173827.GB20528@infradead.org>
 <yq1fvi1rya0.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1fvi1rya0.fsf@sermon.lab.mkp.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 01:47:35PM -0400, Martin K. Petersen wrote:
> There were several SSDs that did not want to support wearing out flash
> by writing gobs of zeroes and only support the UNMAP case.

Given that SSDs usually aren't hard provisioned anyway that seems like
an odd decision.  But SAS SSD would be something I'd at least expect
to properly fail these..

> I don't have a problem with a BLIST_PREFER_UNMAP flag or something like
> that. But BLIST_TRY_VPD_PAGES seems more generally useful and it does
> fix the problem at hand. That's why I went that route.

As I said I'm perfectly fine with your patch and I think we'll find more
uses for it.  I'll apply it as soon as I get a second review.
