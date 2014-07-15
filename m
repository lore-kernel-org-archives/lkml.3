Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934AbaGOPQh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 11:16:37 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:64696 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbaGOPQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 11:16:35 -0400
Date: Tue, 15 Jul 2014 11:16:31 -0400
From: Tejun Heo <tj@kernel.org>
To: Alexey Asemov <alex@alex-at.ru>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] libata-eh.c should handle AMNF error condition (error
 byte bit 0, usually code 0x01) in libata-eh.c along with UNC as a media
 error so SCSI stack can handle it properly (translation code 0x01 is already
 present in libata-scsi.c) but was never passed down due to lack of handling
 in EH.
Message-ID: <20140715151631.GB19570@htj.dyndns.org>
References: <20140714161010.GE31610@htj.dyndns.org>
 <1405405722-12470-1-git-send-email-alex@alex-at.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405405722-12470-1-git-send-email-alex@alex-at.ru>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 10:28:42AM +0400, Alexey Asemov wrote:
> While using linux-based machine (AMD 6550M-based notebook, PCI IDs for the
> controller are 1022:7801 subsys 1025:059d) and ddrescue to salvage data
> from failing hard drive (WD7500BPVT 2.5" 750G SATA2), I've found that pure
> AMNF 0x01 error code generates generic "device error" that is retried
> several times by SCSI stack instead of "media error" that is passed up to
> software.
> 
> So we may assume deprecated AMNF error code is surely not dead yet, and
> it's better for it to be handled properly. As we may see it is used by
> modern enough devices, and used properly: drive returned AMNF only when IDs
> for track cannot be read completely due to dying head or positioning,
> otherwise it returned UNC(orrectables).
> 
> Not handling it causes wrong generic error code ("device error") reporting
> down the stack, can damage failing drives further because of excessive
> retries, and slows salvaging down a lot. Also, there is handling code in
> libata-scsi.c for 0x01 AMNF error already.
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=80031
> 
> Signed-off-by: Alexey Asemov <alex@alex-at.ru>

Applied to libata/for-3.16-fixes w/ shortened $SUBJ (moved to the
first paragraph).

Thanks.

-- 
tejun
