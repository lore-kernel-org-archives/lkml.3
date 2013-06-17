Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025Ab3FQHG4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 03:06:56 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49955 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619Ab3FQHGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 03:06:53 -0400
Date: Mon, 17 Jun 2013 09:06:50 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Naveen N. Rao" <naveen.n.rao@gmail.com>
Cc: "ananth@in.ibm.com" <ananth@in.ibm.com>, masbock@linux.vnet.ibm.com,
        lcm@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, ying.huang@intel.com
Subject: Re: [PATCH] Re: [Patch] MCE, APEI: Don't enable CMCI when Firmware
 First mode is set in
Message-ID: <20130617070650.GA7203@pd.tnic>
References: <3908561D78D1C84285E8C5FCA982C28F2DA47F03@ORSMSX101.amr.corp.intel.com>
 <20130614181721.11206.95341.stgit@localhost.localdomain>
 <20130615144830.GA13310@pd.tnic>
 <51BEB3F5.8070002@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51BEB3F5.8070002@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 12:30:05PM +0530, Naveen N. Rao wrote:
> >Hmm, so if CMCI is not supported, you just disabled polling of this bank
> >and returned here. Not good.
> 
> This is on purpose. If the bank doesn't support CMCI and we were
> polling it earlier, we want to disable that. The firmware should be
> notifying us of error events in either case.

Not for corrected errors - for those we poll since the hardware doesn't
generate an exception for them.

Basically, the absence of CMCI support shouldn't change the old polling
behavior.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
