Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932560AbaGQMl6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 08:41:58 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:33794 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756043AbaGQMl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 08:41:56 -0400
To: "hch\@infradead.org" <hch@infradead.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Elliott\, Robert \(Server Storage\)" <Elliott@hp.com>,
        James Bottomley <jbottomley@parallels.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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
References: <20140711063216.GA20660@infradead.org>
	<328b7a6174ef4dd8a54a7db5ac959834@BY2PR03MB299.namprd03.prod.outlook.com>
	<yq1a98d2z5x.fsf@sermon.lab.mkp.net>
	<20140716110111.GA7382@infradead.org>
	<yq14myhtijx.fsf@sermon.lab.mkp.net>
	<20140716173827.GB20528@infradead.org>
	<yq1fvi1rya0.fsf@sermon.lab.mkp.net>
	<1405533734.3165.12.camel@dabdike.int.hansenpartnership.com>
	<94D0CD8314A33A4D9D801C0FE68B402958BA721F@G9W0745.americas.hpqcorp.net>
	<yq138e1rtzz.fsf@sermon.lab.mkp.net>
	<20140717074234.GA7604@infradead.org>
Date: Thu, 17 Jul 2014 08:41:09 -0400
In-Reply-To: <20140717074234.GA7604@infradead.org> (hch@infradead.org's
	message of "Thu, 17 Jul 2014 00:42:34 -0700")
Message-ID: <yq1zjg8p38a.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130012 (Ma Gnus v0.12) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Christoph" == hch@infradead org <hch@infradead.org> writes:

Christoph> That's mostly because we don't support larger than 512 byte
Christoph> TRIM payloads yet..

I did add support for that a few years back but all hell broke loose and
we had to revert it. There were several drives that failed with more
than 512 bytes of payload despite advertising support for 4K.

It's the same problem that we have now with queued TRIM. There are
several vendors that have implemented it but until we added support in
Linux they had no way of testing it. And as a result their
implementations are buggy. Even with a Linux implementation readily
available it's hard to get them to test since Linux is not a tier 1
platform in the consumer segment. For enterprise drives it's an entirely
different matter, of course...

-- 
Martin K. Petersen	Oracle Linux Engineering
