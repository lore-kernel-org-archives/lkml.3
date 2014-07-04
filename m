Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757161AbaGDOIJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 10:08:09 -0400
Received: from mail.skyhub.de ([78.46.96.112]:37879 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751554AbaGDOIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 10:08:07 -0400
Date: Fri, 4 Jul 2014 16:07:55 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jason Baron <jbaron@akamai.com>
Cc: m.chehab@samsung.com, tony.luck@intel.com, hpa@zytor.com, mingo@kernel.org,
        dougthompson@xmission.com, mitake@dcl.info.waseda.ac.jp,
        aris@redhat.com, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] readq/writeq: Add explicit lo_hi_[read|write]_q
 and hi_lo_[read|write]_q
Message-ID: <20140704140755.GA3340@pd.tnic>
References: <cover.1403818526.git.jbaron@akamai.com>
 <281f09da7ad01e5cea99737ec34d2399bdbbbf63.1403818526.git.jbaron@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <281f09da7ad01e5cea99737ec34d2399bdbbbf63.1403818526.git.jbaron@akamai.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 09:58:28PM +0000, Jason Baron wrote:
> Even on x86-64, I've found the need to break up a readq() into 2 readl()
> calls. According to the Intel datasheet for the E3-1200 processor:
> 
> "
> Software must not access B0/D0/F0 32-bit memory-mapped registers with
> requests that cross a DW boundary.
> "
> 
> (http://www.intel.com/content/www/us/en/processors/xeon/xeon-e3-1200-family-vol-2-datasheet.html p. 16)
> 
> I can confirm this is true via several hard machine lockups.
> 
> Thus, add explicit hi_lo_[readq|write]_q and lo_hi_[read|write]_q so that these
> uses are spelled out.
> 
> Signed-off-by: Jason Baron <jbaron@akamai.com>

Applied, thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
