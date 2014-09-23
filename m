Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912AbaIWLSt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 07:18:49 -0400
Received: from mail.skyhub.de ([78.46.96.112]:60598 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755887AbaIWLSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 07:18:44 -0400
Date: Tue, 23 Sep 2014 13:18:38 +0200
From: Borislav Petkov <bp@alien8.de>
To: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
Cc: dougthompson@xmission.com, m.chehab@samsung.com,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V5] edac, amd64_edac: Modify usage of
 amd64_read_dct_pci_cfg()
Message-ID: <20140923111838.GG22072@pd.tnic>
References: <1410799058-3149-1-git-send-email-aravind.gopalakrishnan@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1410799058-3149-1-git-send-email-aravind.gopalakrishnan@amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 11:37:38AM -0500, Aravind Gopalakrishnan wrote:
> From: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
> 
> Rationale behind this change:
>  - F2x1xx addresses were stopped from being mapped explicitly to DCT1
>    from F15h (OR) onwards. They use _dct[0:1] mechanism to access the
>    registers. So we should move away from using address ranges to select
>    DCT for these families.
>  - On newer processors, the address ranges used to indicate DCT1 (0x140,
>    0x1a0) have different meanings than what is assumed currently.
> 
> Changes introduced:
>  - amd64_read_dct_pci_cfg() now takes in dct value and uses it for
>    'selecting the dct'
>  - Update usage of the function. Keep in mind that different families
>    have specific handling requirements
>  - Remove [k8|f10]_read_dct_pci_cfg() as they don't do much different
>    from amd64_read_pci_cfg()
>    - Move the k8 specific check to amd64_read_pci_cfg
>  - Remove f15_read_dct_pci_cfg() and move logic to amd64_read_dct_pci_cfg()
>  - Remove now needless .read_dct_pci_cfg
> 
> Testing:
>  - Tested on Fam 10h; Fam15h Models: 00h, 30h; Fam16h using 'EDAC_DEBUG'
>    and mce_amd_inj
>  - driver obtains info from F2x registers and caches it in pvt
>    structures correctly
>  - ECC decoding works fine
> 
> Signed-off-by: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
> ---
> Changes in V5: (per Boris suggestion)
>  - use switch instead of if() in amd64_read_dct_pci_cfg() for better
>    readability.
>  - retain if(!dct_ganging_enabled) condition while reading dclr1.
> 
> Change in V4: (per Boris suggestion)
>  - move amd64_read_dct_pci_cfg() to amd64_edac.c and save exporting
>    f15h_select_dct() in the process
> 
> Changes in V3:
>  - per Boris suggestion
>    - move dct selection logic to amd64_read_dct_pci_cfg()
>    - remove f15_read_dct_pci_cfg() and move logic to amd64_read_dct_pci_cfg()
>  - misc
>    - modify logic in amd64_read_dct_pci_cfg() to keep in mind the specific
>      read handling requirements of different families. Previous version had
>      failed to do that.
> 
> Changes in V2: (per Boris suggestion)
>  - Hide family checks in amd64_read_dct_pci_cfg()
>  - Use pvt structure for family checks and not boot_cpu_data
> 
>  drivers/edac/amd64_edac.c | 146 +++++++++++++++++++++++++---------------------
>  drivers/edac/amd64_edac.h |   5 --
>  2 files changed, 80 insertions(+), 71 deletions(-)

Applied, thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
