Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab3IZU7T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 16:59:19 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:12581 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443Ab3IZU7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 16:59:17 -0400
Message-ID: <1380229154.2170.13.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [tip:x86/reboot] x86/reboot: Remove the duplicate C6100 entry
 in the reboot quirks list
From: Davidlohr Bueso <davidlohr@hp.com>
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, msharbiani@twitter.com
Cc: linux-tip-commits@vger.kernel.org
Date: Thu, 26 Sep 2013 13:59:14 -0700
In-Reply-To: <tip-b5eafc6f07c95e9f3dd047e72737449cb03c9956@git.kernel.org>
References: <1380216643-4683-1-git-send-email-masoud.sharbiani@gmail.com>
	 <tip-b5eafc6f07c95e9f3dd047e72737449cb03c9956@git.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-09-26 at 11:58 -0700, tip-bot for Masoud Sharbiani wrote:
> Commit-ID:  b5eafc6f07c95e9f3dd047e72737449cb03c9956
> Gitweb:     http://git.kernel.org/tip/b5eafc6f07c95e9f3dd047e72737449cb03c9956
> Author:     Masoud Sharbiani <msharbiani@twitter.com>
> AuthorDate: Thu, 26 Sep 2013 10:30:43 -0700
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Thu, 26 Sep 2013 20:52:37 +0200
> 
> x86/reboot: Remove the duplicate C6100 entry in the reboot quirks list
> 
> Two entries for the same system type were added, with two different vendor
> names: 'Dell' and 'Dell, Inc.'.
> 
> Since a prefix match is being used by the DMI parsing code, we can eliminate
> the latter as redundant.
> 
> Reported-by: "H. Peter Anvin" <hpa@zytor.com>
> Signed-off-by: Masoud Sharbiani <msharbiani@twitter.com>
> Cc: holt@sgi.com
> Link: http://lkml.kernel.org/r/1380216643-4683-1-git-send-email-masoud.sharbiani@gmail.com
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> ---
>  arch/x86/kernel/reboot.c | 8 --------
>  1 file changed, 8 deletions(-)
> 
> diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
> index f0783a6..d9333a4 100644
> --- a/arch/x86/kernel/reboot.c
> +++ b/arch/x86/kernel/reboot.c
> @@ -362,14 +362,6 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
>  		.callback = set_pci_reboot,
>  		.ident = "Dell PowerEdge C6100",
>  		.matches = {
> -			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
> -			DMI_MATCH(DMI_PRODUCT_NAME, "C6100"),
> -		},
> -	},
> -	{	/* Some C6100 machines were shipped with vendor being 'Dell'. */
> -		.callback = set_pci_reboot,
> -		.ident = "Dell PowerEdge C6100",
> -		.matches = {
>  			DMI_MATCH(DMI_SYS_VENDOR, "Dell"),
>  			DMI_MATCH(DMI_PRODUCT_NAME, "C6100"),
>  		},

Hmm, I think we should be keeping the 'Dell Inc.' part instead of just
'Dell' - at least the rest of the entries use the same string:

arch/x86/kernel/reboot.c:                       DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
arch/x86/kernel/reboot.c:                       DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
arch/x86/kernel/reboot.c:                       DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
arch/x86/kernel/reboot.c:                       DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
arch/x86/kernel/reboot.c:                       DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
arch/x86/kernel/reboot.c:                       DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
arch/x86/kernel/reboot.c:                       DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
arch/x86/kernel/reboot.c:                       DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
arch/x86/kernel/reboot.c:                       DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
arch/x86/kernel/reboot.c:                       DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
arch/x86/kernel/reboot.c:                       DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
arch/x86/kernel/reboot.c:                       DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
arch/x86/kernel/reboot.c:                       DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
arch/x86/kernel/reboot.c:                       DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
arch/x86/kernel/reboot.c:                       DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
arch/x86/kernel/reboot.c:                       DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
arch/x86/kernel/reboot.c:                       DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),


