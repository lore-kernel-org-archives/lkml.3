Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965851AbaGRRBL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 13:01:11 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:54115 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965751AbaGRRBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 13:01:09 -0400
Date: Fri, 18 Jul 2014 10:01:07 -0700
From: "hch@infradead.org" <hch@infradead.org>
To: James Bottomley <jbottomley@parallels.com>
Cc: "kys@microsoft.com" <kys@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: Re: [PATCH 1/1] [SCSI] Fix a bug in deriving the FLUSH_TIMEOUT from
 the basic I/O timeout
Message-ID: <20140718170107.GA7564@infradead.org>
References: <53911A35.7010805@cs.wisc.edu>
 <d9854e6ff97f4b0087dbe835a2a57c8f@BY2PR03MB299.namprd03.prod.outlook.com>
 <5391F801.4010107@cs.wisc.edu>
 <1402077167.2207.89.camel@dabdike.int.hansenpartnership.com>
 <539206FA.1020001@kernel.dk>
 <5b926a0a9f264edda91c7c2ab0acb7d1@BY2PR03MB299.namprd03.prod.outlook.com>
 <13807d2cc8744ae1bc374f20d8f9caec@BY2PR0301MB0711.namprd03.prod.outlook.com>
 <20140718151039.GA7425@infradead.org>
 <2d43adebbc47441084d8e1284507a427@BY2PR0301MB0711.namprd03.prod.outlook.com>
 <1405702633.30262.3.camel@dabdike.int.hansenpartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405702633.30262.3.camel@dabdike.int.hansenpartnership.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 04:57:13PM +0000, James Bottomley wrote:
> Actually, no you didn't.  The difference is in the derivation of the
> timeout.  Christoph's patch is absolute in terms of SD_TIMEOUT; yours is
> relative to the queue timeout setting ... I thought there was a reason
> for preferring the relative version.

Yes, KYs version is better.  It takes the base timeout drivers set
on the request queue into account.

