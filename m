Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923Ab3EYF1y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 01:27:54 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:41258
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750954Ab3EYF1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 01:27:52 -0400
Date: Sat, 25 May 2013 01:27:44 -0400
From: Christoph Hellwig <hch@infradead.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Tejun Heo <tj@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, lkml <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: PING^7 (was Re: [PATCH v2 00/14] Corrections and customization
 of the SG_IO command whitelist (CVE-2012-4542))
Message-ID: <20130525052744.GA25186@infradead.org>
References: <20130522193009.GA23845@mtj.dyndns.org>
 <519D360D.4050309@redhat.com>
 <20130522221737.GA12339@mtj.dyndns.org>
 <519DC926.4000106@redhat.com>
 <20130523090222.GA26592@mtj.dyndns.org>
 <519DE5AD.7080303@redhat.com>
 <20130524014405.GB16882@mtj.dyndns.org>
 <519F12FF.6090809@redhat.com>
 <CAOS58YODjkSF=V7wADqbn_z8c6bmj=r03hWxEs5B1O+1cd0n6g@mail.gmail.com>
 <1369456502.5008.5.camel@dabdike>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369456502.5008.5.camel@dabdike>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 24, 2013 at 09:35:02PM -0700, James Bottomley wrote:
> I'll go along with this.  I'm also wondering what the problem would be
> if we just allowed all commands on either CAP_SYS_RAWIO or opening the
> device for write, so we just defer to the filesystem permissions and
> restricted read only opens to the basic all device opcodes.

I've been out of this area for a bit, but the problem used to be that
you could send destructive commands to a partition.  The right fix
for that would be to not allow SG_IO on partitions at all, just
wondering if anything would be broken by this.

