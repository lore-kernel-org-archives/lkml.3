Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759108AbaJaTmO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 15:42:14 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33277 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758145AbaJaTmL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 15:42:11 -0400
Date: Fri, 31 Oct 2014 20:42:07 +0100
From: Borislav Petkov <bp@alien8.de>
To: Juergen Gross <jgross@suse.com>
Cc: hpa@zytor.com, x86@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        stefan.bader@canonical.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, konrad.wilk@oracle.com,
        ville.syrjala@linux.intel.com, david.vrabel@citrix.com,
        jbeulich@suse.com, toshi.kani@hp.com, plagnioj@jcrosoft.com,
        tomi.valkeinen@ti.com, bhelgaas@google.com
Subject: Re: [PATCH 01/17] x86: Make page cache mode a real type
Message-ID: <20141031194207.GA15367@pd.tnic>
References: <1414764033-30011-1-git-send-email-jgross@suse.com>
 <1414764033-30011-2-git-send-email-jgross@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1414764033-30011-2-git-send-email-jgross@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 03:00:17PM +0100, Juergen Gross wrote:
> At the moment there are a lot of places that handle setting or getting
> the page cache mode by treating the pgprot bits equal to the cache mode.
> This is only true because there are a lot of assumptions about the setup
> of the PAT MSR. Otherwise the cache type needs to get translated into
> pgprot bits and vice versa.
> 
> This patch tries to prepare for that by introducing a separate type
> for the cache mode and adding functions to translate between those and
> pgprot values.
> 
> To avoid too much performance penalty the translation between cache mode
> and pgprot values is done via tables which contain the relevant
> information.  Write-back cache mode is hard-wired to be 0, all other
> modes are configurable via those tables. For large pages there are
> translation functions as the PAT bit is located at different positions
> in the ptes of 4k and large pages.
> 
> Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
> Signed-off-by: Juergen Gross <jgross@suse.com>

Just a clarification question: how is one to understand this attribution
here? Is Stefan the original author, was he a reviewer, or? Because this
SOB chain is misleading...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
