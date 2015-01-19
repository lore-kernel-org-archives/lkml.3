Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574AbbASSVu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 13:21:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60961 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752320AbbASSVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 13:21:48 -0500
Date: Mon, 19 Jan 2015 19:21:42 +0100
From: Borislav Petkov <bp@suse.de>
To: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        riel@redhat.com, mgorman@suse.de, jolsa@kernel.org,
        pbonzini@redhat.com, jacob.w.shin@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, cpu, amd: Use 8-bit extractor for NodeId field
Message-ID: <20150119182142.GF4486@pd.tnic>
References: <1421691538-7152-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1421691538-7152-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 12:18:58PM -0600, Aravind Gopalakrishnan wrote:
> The NodeId field in cpuid_ecx(0x8000001e) is a 8 bit field.
> Although current extractor works fine, it will break if/when
> the most significant 5 bits ever get used.
> 
> So, lets honor the field as architected in the BKDG
> 
> Reference: BKDG for AMD Fam15h Models 00h-0fh,
> CPUID Fn8000_001E_ECX Node Identifiers
> 
> Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
> ---
>  arch/x86/kernel/cpu/amd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> index a220239..9942b83 100644
> --- a/arch/x86/kernel/cpu/amd.c
> +++ b/arch/x86/kernel/cpu/amd.c
> @@ -300,7 +300,7 @@ static void amd_get_topology(struct cpuinfo_x86 *c)
>  
>  		cpuid(0x8000001e, &eax, &ebx, &ecx, &edx);
>  		nodes = ((ecx >> 8) & 7) + 1;
> -		node_id = ecx & 7;
> +		node_id = ecx & 0xff;

That's {00000b,D18F0x60[NodeId]} and NodeId is 3 bits for enumerating
8 nodes so checking the 3 bits is actually correct as it says that the
other 5 are 0b.

Regardless, is this something hypothetical you've noticed from code
inspection or are we really going to have more than 8 nodes? If the
former, then patch is unnecessary churn.

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
