Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbaCaQ0q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 12:26:46 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49170 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753014AbaCaQ0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 12:26:44 -0400
Date: Mon, 31 Mar 2014 18:26:33 +0200
From: Borislav Petkov <bp@alien8.de>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Borislav Petkov <bp@suse.de>,
        Jacob Shin <jacob.shin@amd.com>, Jeff Layton <jlayton@redhat.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] x86: microcode: report if no microcode file was found
Message-ID: <20140331162633.GC16144@pd.tnic>
References: <1396188574-2067-1-git-send-email-dvlasenk@redhat.com>
 <1396188574-2067-2-git-send-email-dvlasenk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1396188574-2067-2-git-send-email-dvlasenk@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 30, 2014 at 04:09:33PM +0200, Denys Vlasenko wrote:
> diff --git a/arch/x86/kernel/cpu/microcode/intel.c b/arch/x86/kernel/cpu/microcode/intel.c
> index ef8b17c..9ce22b0 100644
> --- a/arch/x86/kernel/cpu/microcode/intel.c
> +++ b/arch/x86/kernel/cpu/microcode/intel.c
> @@ -279,7 +279,7 @@ static enum ucode_state request_microcode_fw(int cpu, struct device *device,
>  		c->x86, c->x86_model, c->x86_mask);
>  
>  	if (request_firmware_direct(&firmware, name, device)) {

request_firmware_direct() already has dev_dbg() error messages down its
path.

> -		pr_debug("data file %s load failed\n", name);
> +		pr_info("data file %s load failed\n", name);

Also might spook users unnecessarily.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
