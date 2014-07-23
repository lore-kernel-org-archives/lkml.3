Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758355AbaGWPbh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 11:31:37 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:36838 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755732AbaGWPbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 11:31:35 -0400
Date: Wed, 23 Jul 2014 16:31:25 +0100
From: Sitsofe Wheeler <sitsofe@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        ohering@suse.com, apw@canonical.com, jasowang@redhat.com,
        jbottomley@parallels.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/1] Drivers: scsi: storvsc: Add blist flags
Message-ID: <20140723153125.GA520@sucs.org>
References: <1405983961-18782-1-git-send-email-kys@microsoft.com>
 <20140723100448.GA2540@sucs.org>
 <20140723115128.GB16881@infradead.org>
 <20140723125443.GA16103@sucs.org>
 <20140723141014.GA892@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140723141014.GA892@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 07:10:14AM -0700, Christoph Hellwig wrote:
> On Wed, Jul 23, 2014 at 01:54:43PM +0100, Sitsofe Wheeler wrote:
> > That's good to know (I was worried the device would not be detected as
> > supporting discard because it doesn't report lbpme and doesn't declare a
> > conformance version (see below)).
> 
> Ok, that makes things worse - you might be able to force it through
> sysfs, though.

I've got a hack that seems to be working for me - see below.

> > Is there a tree with all these updates
> > in or do they need to be pieced together from this email thread?
> 
> I'm picking this up for my scsi-queue tree.  Still need a review
> for the patch we're replying to before that one can go in, though.

OK.

> > Additionally is it worth quirking sd_try_rc16_first on when
> > BLIST_TRY_VPD_PAGES is present?
> 
> Sounds reasonable to me.

OK did you want me to post a set of changes to your patch? I've
basically changed the patches from bypassing the SCSI level check (to
allow scanning of VPD pages) to also try READ_CAPACITY(16) first and
bypass lbpme checks. Now it's more of a case of BLIST_TRY_LBP...

-- 
Sitsofe | http://sucs.org/~sits/
