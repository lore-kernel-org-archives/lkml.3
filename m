Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222AbaD1WVl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 18:21:41 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:55909 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751400AbaD1WVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 18:21:40 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for Apr 28 (drivers/pnp/quirks.c)
Date: Tue, 29 Apr 2014 00:38:07 +0200
Message-ID: <4118646.t0YM8Nt49i@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140428220928.GA19838@google.com>
References: <20140428165724.6361cf10ebd3067b7f998c0f@canb.auug.org.au> <535EC4A7.5070001@intel.com> <20140428220928.GA19838@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 28, 2014 04:09:28 PM Bjorn Helgaas wrote:
> On Mon, Apr 28, 2014 at 11:14:15PM +0200, Rafael J. Wysocki wrote:
> > On 4/28/2014 11:11 PM, Bjorn Helgaas wrote:
> > >On Mon, Apr 28, 2014 at 10:45:37AM -0700, Randy Dunlap wrote:
> > >>On 04/27/14 23:57, Stephen Rothwell wrote:
> > >>>Hi all,
> > >>>
> > >>>This tree still fails (more than usual) the powerpc allyesconfig build.
> > >>>
> > >>>Changes since 20140424:
> > >>>
> > >>on i386:
> > >>
> > >>   CC      drivers/pnp/quirks.o
> > >>drivers/pnp/quirks.c: In function 'quirk_intel_mch':
> > >>drivers/pnp/quirks.c:393:2: error: implicit declaration of function 'pcibios_bus_to_resource' [-Werror=implicit-function-declaration]
> > >>cc1: some warnings being treated as errors
> > >>make[3]: *** [drivers/pnp/quirks.o] Error 1
> > >Thanks Randy.  This is a config that doesn't define CONFIG_PCI.  Rafael,
> > >here's an incremental fix, or the full updated patch is below.
> > 
> > Well, that went to Linus already, so a fix on top of 3.15-rc3 is needed.
> 
> Of course; I should have noticed that.
> 
> > >+#if defined(CONFIG_X86) && defined(CONFIG_PCI)
> > 
> > Do we need both or would CONFIG_PCI be sufficient?
> 
> CONFIG_PCI alone should be sufficient.  Here's a fix on top of
> v3.15-rc3.  Sorry for all the hassle.

Applied, thanks!


> commit c03ae9359c7f97854567f897bafcb2e6489d155f
> Author: Bjorn Helgaas <bhelgaas@google.com>
> Date:   Thu Apr 17 14:22:18 2014 -0600
> 
>     PNP: Fix compile error
>     
>     Fix the compile error:
>     
>       drivers/pnp/quirks.c:393:2: error: implicit declaration of function 'pcibios_bus_to_resource'
>     
>     that occurs when building with CONFIG_PCI unset.  The quirk is only
>     relevent to Intel devices, so we could use "#if defined(CONFIG_X86) &&
>     defined(CONFIG_PCI)" instead, but testing CONFIG_X86 is not strictly
>     necessary.
>     
>     Reported-by: Randy Dunlap <rdunlap@infradead.org>
>     Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> 
> diff --git a/drivers/pnp/quirks.c b/drivers/pnp/quirks.c
> index 3736bc408adb..ebf0d6710b5a 100644
> --- a/drivers/pnp/quirks.c
> +++ b/drivers/pnp/quirks.c
> @@ -335,7 +335,7 @@ static void quirk_amd_mmconfig_area(struct pnp_dev *dev)
>  }
>  #endif
>  
> -#ifdef CONFIG_X86
> +#ifdef CONFIG_PCI
>  /* Device IDs of parts that have 32KB MCH space */
>  static const unsigned int mch_quirk_devices[] = {
>  	0x0154,	/* Ivy Bridge */
> @@ -440,7 +440,7 @@ static struct pnp_fixup pnp_fixups[] = {
>  #ifdef CONFIG_AMD_NB
>  	{"PNP0c01", quirk_amd_mmconfig_area},
>  #endif
> -#ifdef CONFIG_X86
> +#ifdef CONFIG_PCI
>  	{"PNP0c02", quirk_intel_mch},
>  #endif
>  	{""}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
