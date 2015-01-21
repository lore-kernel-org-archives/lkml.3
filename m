Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819AbbAUGoQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 01:44:16 -0500
Received: from mail-oi0-f51.google.com ([209.85.218.51]:35952 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbbAUGoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 01:44:15 -0500
MIME-Version: 1.0
In-Reply-To: <1420304509-13072-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1420304509-13072-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Date: Wed, 21 Jan 2015 14:44:14 +0800
Message-ID: <CAMk6uB=+h8d8mpwbW5HwO_MdFuLz4b-P9BgtmY9pz2nu5xzM4Q@mail.gmail.com>
Subject: Re: [PATCH] blackfin: mach-common: ints-priority: Remove unused function
From: Steven Miao <realmz6@gmail.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Sonic Zhang <sonic.zhang@analog.com>, Jiri Kosina <jkosina@suse.cz>,
        Randy Dunlap <rdunlap@infradead.org>, Christoph Lameter <cl@linux.com>,
        Masanari Iida <standby24x7@gmail.com>,
        bfin <adi-buildroot-devel@lists.sourceforge.net>,
        "open list:CAN NETWORK DRIVERS <linux-can@vger.kernel.org>, open
	list:NETWORKING DRIVERS <netdev@vger.kernel.org>, open list" 
	<linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rickard,

On Sun, Jan 4, 2015 at 1:01 AM, Rickard Strandqvist
<rickard_strandqvist@spectrumdigital.se> wrote:
> Remove the function bfin_sec_resume() that is not used anywhere.
>
> This was partially found by using a static code analysis program called cppcheck.
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  arch/blackfin/mach-common/ints-priority.c |    8 --------
>  1 file changed, 8 deletions(-)
>
> diff --git a/arch/blackfin/mach-common/ints-priority.c b/arch/blackfin/mach-common/ints-priority.c
> index dd2af74..7236bdf 100644
> --- a/arch/blackfin/mach-common/ints-priority.c
> +++ b/arch/blackfin/mach-common/ints-priority.c
> @@ -429,14 +429,6 @@ static void init_software_driven_irq(void)
>         bfin_sec_enable_ssi(37);
>  }
>
> -void bfin_sec_resume(void)
> -{
> -       bfin_write_SEC_SCI(0, SEC_CCTL, SEC_CCTL_RESET);
> -       udelay(100);
> -       bfin_write_SEC_GCTL(SEC_GCTL_EN);
> -       bfin_write_SEC_SCI(0, SEC_CCTL, SEC_CCTL_EN | SEC_CCTL_NMI_EN);
> -}
> -
>  void handle_sec_sfi_fault(uint32_t gstat)
>  {
>
> --
> 1.7.10.4
>
Yes, this bfin_sec_resume() should be dropped.

-steven
