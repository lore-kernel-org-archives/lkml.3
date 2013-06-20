Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422779Ab3FTUEM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 16:04:12 -0400
Received: from 8bytes.org ([85.214.48.195]:35788 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422769Ab3FTUEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 16:04:10 -0400
Date: Thu, 20 Jun 2013 22:04:06 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: iommu@lists.linux-foundation.org, ddutile@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] amd_iommu: Fix leak in free_pagetable()
Message-ID: <20130620200406.GE11309@8bytes.org>
References: <20130618014459.20440.73844.stgit@bling.home>
 <20130618015116.20711.90269.stgit@bling.home>
 <20130620182808.GC11309@8bytes.org>
 <1371755280.30572.4.camel@ul30vt.home>
 <20130620192638.GD11309@8bytes.org>
 <1371757608.30572.18.camel@ul30vt.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371757608.30572.18.camel@ul30vt.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Thu Jun 20 22:04:07 2013
X-DSPAM-Confidence: 0.9979
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 51c3603720861972777499
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 01:46:48PM -0600, Alex Williamson wrote:
> But that's true of a bug in any kernel code.  I think the only danger
> unique to recursion is using too much stack space, but I doubt that's
> really an issue for a tiny function with a fixed depth like this.  In
> case you didn't notice, I did send a recursive version along with the
> flat version, but I stupidly used the same subject for both.  It's a
> little less code and a tiny bit easier to understand than the macro
> version.  Up to you though.

Well, the limited kernel stack is exactly the problem for an
unterminating recursion. The size of the stack-footprint does also not
really matter in this situation, the code will overwrite random kernel
memory when the stack overflows. And that memory could potentially
contain data that is about to be written to disk and destroy file
systems.


	Joerg

