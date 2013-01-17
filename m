Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587Ab3AQLT1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 06:19:27 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:56630 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751944Ab3AQLT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 06:19:26 -0500
Message-ID: <1358421561.2394.27.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH v2 1/1] block: blk-merge: don't merge the pages with
 non-contiguous descriptors
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Subhash Jadavani <subhashj@codeaurora.org>, Tejun Heo <tj@kernel.org>,
        asias@redhat.com, linux-arm-kernel@lists.infradead.org
Date: Thu, 17 Jan 2013 11:19:21 +0000
In-Reply-To: <20130117110438.GZ23505@n2100.arm.linux.org.uk>
References: <1358265681-25671-1-git-send-email-subhashj@codeaurora.org>
	 <1358266794.10591.8.camel@dabdike.int.hansenpartnership.com>
	 <50F64AC1.3040304@codeaurora.org>
	 <1358332355.2384.11.camel@dabdike.int.hansenpartnership.com>
	 <20130116231857.GU2668@htj.dyndns.org>
	 <1358413880.2394.7.camel@dabdike.int.hansenpartnership.com>
	 <20130117103742.GX23505@n2100.arm.linux.org.uk>
	 <20130117104741.GY23505@n2100.arm.linux.org.uk>
	 <1358420507.2394.19.camel@dabdike.int.hansenpartnership.com>
	 <20130117110438.GZ23505@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.6.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-17 at 11:04 +0000, Russell King - ARM Linux wrote:
> On Thu, Jan 17, 2013 at 11:01:47AM +0000, James Bottomley wrote:
> > On Thu, 2013-01-17 at 10:47 +0000, Russell King - ARM Linux wrote:
> > > Also, couldn't the addition of the scatterlist offset to the page also
> > > be buggy too?
> > 
> > No, fortunately, offset must be within the first page from the point of
> > view of block generated sg lists.  As long as nothing within arm
> > violates this, it should be a safe assumption ... although the code
> > seems to assume otherwise.
> 
> Are you absolutely sure about that?  I believe I have seen cases where
> that has been violated in the past, though it was many years ago.

>From the point of view of the block layer, absolutely: the scatterlist
is generated from an array of bio_vecs.  Each bio_vec is a page, offset
and length element and obeys the rule that offset must be within the
page and offset + length cannot stray over the page.

>From the point of view of other arm stuff, I don't know.

James


