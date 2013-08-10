Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964938Ab3HJPPf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 11:15:35 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49669 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964777Ab3HJPPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 11:15:33 -0400
Date: Sat, 10 Aug 2013 17:15:31 +0200
From: Borislav Petkov <bp@alien8.de>
To: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        dougthompson@xmission.com, bhelgaas@google.com, jbeulich@suse.com,
        linux-kernel@vger.kernel.org, linux-edac@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 3/3 V4] EDAC, AMD64_EDAC: Add ECC decoding support for
 newer F15h models.
Message-ID: <20130810151530.GA4155@pd.tnic>
References: <1376067289-2753-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1376067289-2753-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 09, 2013 at 11:54:49AM -0500, Aravind Gopalakrishnan wrote:
> Adding support for handling ECC error decoding for new F15 models.
> On newer models, support has been included for upto 4 DCT's, however,
> only DCT0 and DCT3 are currently configured. (Refer BKDG Section 2.10)
> Routing DRAM Requests algorithm is different for F15h M30h.
> It is cleaner to use a brand new function rather than
> adding quirks in the more generic 'f1x_match_to_this_node'
> Refer "2.10.5 DRAM Routing Requests" in BKDG for info.
> 
> Tested on Fam15h M30h with ECC turned on using mce_amd_inj facility and
> verified to be functionally correct.
> 
> Changes from V3:
> 	- Remove compiler warnings
>         - Recheck models that need erratum workaround for E505:
> 	  - From looking up history of the bug, we find that
>             the workaround holds true only for Fam15 models upto 1h
>             and only upto stepping 0h. CPU revisions after these
>             do not need the workaround.
> 
> Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>

Ok, I've taken it and applied a cleanup ontop which uses the locally
cached family, model, stepping (sending it as a reply to this message).

I'd appreciate it if you tested the branch here

git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git amd-f15-m30

just to make sure everything is still kosher.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
