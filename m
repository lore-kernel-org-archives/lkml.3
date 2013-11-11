Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749Ab3KKQwx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 11:52:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35189 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753789Ab3KKQwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 11:52:47 -0500
Date: Mon, 11 Nov 2013 11:52:03 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: hpa@linux.intel.com, ebiederm@xmission.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, bp@alien8.de, akpm@linux-foundation.org,
        fengguang.wu@intel.com, jingbai.ma@hp.com
Subject: Re: [PATCH v4 1/3] x86, apic: Don't count the CPU with BP flag from
 MP table as booting-up CPU
Message-ID: <20131111165202.GD11547@redhat.com>
References: <20131022150015.24240.39686.stgit@localhost6.localdomain6>
 <20131022150124.24240.20741.stgit@localhost6.localdomain6>
 <20131108160830.GB13068@redhat.com>
 <5280466E.9090504@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5280466E.9090504@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 11:52:30AM +0900, HATAYAMA Daisuke wrote:

[..]
> Looking at my past investigation, kernel/mpparse.c, mm/amdtopology.c and
> platform/visws/visws_quirks.c assumes that boot_cpu_physical_apicid
> has initial apicid of the BSP, not the current actual booting-up cpu.
> 
> These three are called in get_smp_config() below. If either of them is
> called actually, boot_cpu_physical_apicid has the apicid different from
> the current actual booting-up cpu temporarily. But init_apic_mappings()
> soon modifies back the value to the one obtained by read_apic_id().
> 
>         /*
>          * Read APIC and some other early information from ACPI tables.
>          */
>         acpi_boot_init();
>         sfi_init();
>         x86_dtb_init();
> 
>         /*
>          * get boot-time SMP configuration:
>          */
>         if (smp_found_config)
>                 get_smp_config();
> 
>         prefill_possible_map();
> 
>         init_cpu_to_node();
> 
>         init_apic_mappings();
> 
> So, thanks to init_apic_mappings(), the patch set would work without the
> first patch... This is a careless point in this patch set.
> 

If init_apic_mappings(), is making sure that boot_cpu_physical_apicid is
apic id of booting processor, and you don't need first patch of your
series, then I think atleast re-post your patch series without first
patch.  

And then there can be another series which looks into whether we need
two different variables or not and if we do, then a separate variable
bsp_physical_apicid will track the bsp id as reported by BIOS and
boot_cpu_physical_apicid will track apic id of booting cpu. This might
a very big and slow cleanup. So I think blocking the first patch series
behind it might not make much sense.

Thanks
Vivek
