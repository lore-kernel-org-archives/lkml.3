Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829Ab3LLUW6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 15:22:58 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:56521 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519Ab3LLUWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 15:22:55 -0500
Date: Thu, 12 Dec 2013 20:22:53 +0000
From: "Robin H. Johnson" <robbat2@gentoo.org>
To: Tejun Heo <tj@kernel.org>
Cc: "Robin H. Johnson" <robbat2@gentoo.org>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org
Subject: Re: [PATCH] libata: provide the ability to disable a disk via the
 params.
Message-ID: <robbat2-20131212T200207-028507804Z@orbis-terrarum.net>
References: <1386464187-6993-1-git-send-email-robbat2@gentoo.org>
 <20131212133935.GA32683@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131212133935.GA32683@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 08:39:35AM -0500, Tejun Heo wrote:
> Hello, Robin.
> 
> On Sat, Dec 07, 2013 at 04:56:27PM -0800, Robin H. Johnson wrote:
> > +		{ "disable",	.horkage_on	= ATA_HORKAGE_DISABLE },
> > +		{ "nodisable",	.horkage_off	= ATA_HORKAGE_DISABLE },
> Given the current usage of ATA_HORKAGE_DISABLE, I don't think we need
> "nodisable".  Let's just add "disable" for now.  Can you please update
> the patch and resend?
Before I do so, I have two questions:
1.
Countering your nodisable comment, would it be valid to do:
libata.force=2:disable libata.force=2.02:nodisable
To disable all of port 2 except device 2?

2. One of my friends wondered if it would be worthwhile to add force
keywords for other HORKAGE bits, and if so, should the
ata_lflag/ata_link force bits also be presented?

There are only 3 HORKAGE bits presently available in libata.force:
ATA_HORKAGE_NONCQ
ATA_HORKAGE_DUMP_ID
ATA_HORKAGE_ATAPI_DMADIR

And 3 ata_link flags:
ATA_LFLAG_NO_HRST
ATA_LFLAG_NO_SRST
ATA_LFLAG_RST_ONCE

-- 
Robin Hugh Johnson
Gentoo Linux: Developer, Infrastructure Lead
E-Mail     : robbat2@gentoo.org
GnuPG FP   : 11ACBA4F 4778E3F6 E4EDF38E B27B944E 34884E85
