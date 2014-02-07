Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144AbaBGOBw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 09:01:52 -0500
Received: from mail.skyhub.de ([78.46.96.112]:41515 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560AbaBGOBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 09:01:50 -0500
Date: Fri, 7 Feb 2014 15:01:44 +0100
From: Borislav Petkov <bp@alien8.de>
To: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Cc: dougthompson@xmission.com, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] AMD64_EDAC: Fix logic to determine channel for F15 M30h
 processors
Message-ID: <20140207140144.GI24395@pd.tnic>
References: <1390338216-3873-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1390338216-3873-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 03:03:36PM -0600, Aravind Gopalakrishnan wrote:
> The current logic that returns (sys_addr >> 8) & 0x7 when
> num_dcts_intlv = 4 is incorrect. We should really be doing-
> If intlv_addr = 0x4, then interleave on bits [9:8] and if
> intlv_addr = 0x5, interleave on bits [10:9].
> 
> Refer F15 M30h BKDG D18F2x110[7:6] (DRAM Controller Select Low)
> (Link:http://support.amd.com/TechDocs/49125_15h_Models_30h-3Fh_BKDG.pdf)
> 
> Tested on F15 M30h with mce_inj module and patch did not cause
> any regressions.
> 
> Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>

Applied, thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
