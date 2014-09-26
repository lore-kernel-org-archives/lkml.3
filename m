Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647AbaIZJ5x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:57:53 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54138 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755630AbaIZJ5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:57:50 -0400
Message-ID: <1411725461.2183.2.camel@jarvis>
Subject: Re: linux-next: build failure after merge of the scsi tree
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Brian King <brking@linux.vnet.ibm.com>,
        Xiong <wenxiong@linux.vnet.ibm.com>
Date: Fri, 26 Sep 2014 10:57:41 +0100
In-Reply-To: <20140926083632.GA19463@lst.de>
References: <20140926183450.7474b448@canb.auug.org.au>
	 <20140926083632.GA19463@lst.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-09-26 at 10:36 +0200, Christoph Hellwig wrote:
> On Fri, Sep 26, 2014 at 06:34:50PM +1000, Stephen Rothwell wrote:
> > Hi James,
> > 
> > After merging the scsi tree, today's linux-next build (powerpc
> > ppc64_defconfig) failed like this:
> > 
> > drivers/scsi/ipr.c: In function 'ipr_handle_log_data':
> > drivers/scsi/ipr.c:2468:15: error: 'IPR_IOASC_HW_CMD_FAILED' undeclared (first use in this function)
> >   if (ioasc == IPR_IOASC_HW_CMD_FAILED &&
> >                ^
> > 
> > Caused by commit 3185ea63907c ("ipr: don't log error messages when
> > applications issues illegal requests").  Someone typoed that name in
> > ipr.h ...
> > 
> > I have reverted that commit for today.
> 
> Thanks.  The fix should be here:
> 
> http://git.infradead.org/users/hch/scsi-queue.git/commitdiff/d247a70a4d67623eb738176ee703a7bb8b6c325c

OK, Pushed out.

I'll wait for the next couple of build cycles before pushing (assuming
merge window opens on Sunday) just in case more things show up.

James


