Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751213AbaGJKRQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 06:17:16 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:34289 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbaGJKRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 06:17:14 -0400
Date: Thu, 10 Jul 2014 03:17:13 -0700
From: Christoph Hellwig <hch@infradead.org>
To: KY Srinivasan <kys@microsoft.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "jbottomley@parallels.com" <jbottomley@parallels.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "apw@canonical.com" <apw@canonical.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 7/8] drivers: scsi: storvsc: Set srb_flags in all cases
Message-ID: <20140710101713.GC1151@infradead.org>
References: <1404866789-26910-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-7-git-send-email-kys@microsoft.com>
 <20140709084453.GG6012@infradead.org>
 <651b6b11c6d6415cb0046ce03b6b2c63@BY2PR03MB299.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <651b6b11c6d6415cb0046ce03b6b2c63@BY2PR03MB299.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 06:40:09PM +0000, KY Srinivasan wrote:
> > On Tue, Jul 08, 2014 at 05:46:51PM -0700, K. Y. Srinivasan wrote:
> > > Correctly set SRB flags for all valid I/O directions. Some IHV drivers
> > > on the Windows host require this.
> > 
> > What are IHV drivers?
> 
> If the target is a SAN device, the host simply passes the request over to the native driver stack on the host. Some specific hardware (IHV - independent hadware vendor) drivers on Windows require that SRB flags be correctly set in all cases.
> 

I'm fine with putting this in, but treating I/O request from guests as
trusted in a hypervisor doesn't seem like a good idea in general..

