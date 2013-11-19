Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037Ab3KSCY4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 21:24:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41722 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582Ab3KSCYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 21:24:55 -0500
Message-ID: <528ACBD8.3070804@zytor.com>
Date: Mon, 18 Nov 2013 18:24:24 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Andreas Werner <wernerandy@gmx.de>, tglx@linutronix.de
CC: mingo@redhat.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        bp@alien8.de
Subject: Re: [PATCH v2] X86: MM: Add PAT Type write-through in combination
 with mtrr
References: <1383480142-5665-1-git-send-email-wernerandy@gmx.de>
In-Reply-To: <1383480142-5665-1-git-send-email-wernerandy@gmx.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2013 04:02 AM, Andreas Werner wrote:
> Revision 2:
> 	added comment in code.
> 
> This patch adds the Write-through memory type in combination with mtrr.
> If you call ioremap_cache to request cachable memory (write-back) the
> function tries to set the PAT to write-back only if the mtrr setting of
> the requested region is also marked as Write-Back.
> 
> If the mttr regions are marked e.g. as Write-through or with other
> types, the function will always return UC- memory.
> 
> If you check the Intel document " IA-32 SDM vol 3a table Effective
> Memory Type", there
> are many other combinations possible.
> 
> This patch will only add the following combination:
> PAT=Write-Back + MTRR=Write-Through.
> 
> Since marking IO Memory as cachable is not valid, WT is the
> best way for caching/bursting on MMIO Devices.
> 
> Tested on - Intel (R) Atom E680 (Tunnel Creek)
>           - Intel (R) Core(TM)2 Duo
> 
> Signed-off-by: Andreas Werner <wernerandy@gmx.de>

I don't quite know where this ended up, but I am *really* not happy
about going back to using MTRRs to mark I/O devices with the chronic
problems of MTRR exhaustion that entails.  As such I do insist that PAT
is properly updated to support WT if we're going to do this.

	-hpa


