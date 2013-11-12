Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449Ab3KLAnU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 19:43:20 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46328 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069Ab3KLAnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 19:43:13 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <52817916.9030104@jp.fujitsu.com>
Date: Tue, 12 Nov 2013 09:40:54 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: hpa@linux.intel.com, ebiederm@xmission.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, bp@alien8.de, akpm@linux-foundation.org,
        fengguang.wu@intel.com, jingbai.ma@hp.com
Subject: Re: [PATCH v4 1/3] x86, apic: Don't count the CPU with BP flag from
 MP table as booting-up CPU
References: <20131022150015.24240.39686.stgit@localhost6.localdomain6> <20131022150124.24240.20741.stgit@localhost6.localdomain6> <20131108160830.GB13068@redhat.com> <5280466E.9090504@jp.fujitsu.com> <20131111165202.GD11547@redhat.com>
In-Reply-To: <20131111165202.GD11547@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/11/12 1:52), Vivek Goyal wrote:
> On Mon, Nov 11, 2013 at 11:52:30AM +0900, HATAYAMA Daisuke wrote:
>
> [..]
>> Looking at my past investigation, kernel/mpparse.c, mm/amdtopology.c and
>> platform/visws/visws_quirks.c assumes that boot_cpu_physical_apicid
>> has initial apicid of the BSP, not the current actual booting-up cpu.
>>
>> These three are called in get_smp_config() below. If either of them is
>> called actually, boot_cpu_physical_apicid has the apicid different from
>> the current actual booting-up cpu temporarily. But init_apic_mappings()
>> soon modifies back the value to the one obtained by read_apic_id().
>>
>>          /*
>>           * Read APIC and some other early information from ACPI tables.
>>           */
>>          acpi_boot_init();
>>          sfi_init();
>>          x86_dtb_init();
>>
>>          /*
>>           * get boot-time SMP configuration:
>>           */
>>          if (smp_found_config)
>>                  get_smp_config();
>>
>>          prefill_possible_map();
>>
>>          init_cpu_to_node();
>>
>>          init_apic_mappings();
>>
>> So, thanks to init_apic_mappings(), the patch set would work without the
>> first patch... This is a careless point in this patch set.
>>
>
> If init_apic_mappings(), is making sure that boot_cpu_physical_apicid is
> apic id of booting processor, and you don't need first patch of your
> series, then I think atleast re-post your patch series without first
> patch.
>

Yes, I'll repost soon.

> And then there can be another series which looks into whether we need
> two different variables or not and if we do, then a separate variable
> bsp_physical_apicid will track the bsp id as reported by BIOS and
> boot_cpu_physical_apicid will track apic id of booting cpu. This might
> a very big and slow cleanup. So I think blocking the first patch series
> behind it might not make much sense.
>

Yes, the current handling of boot_cpu_physical_apicid looks strange and
should be cleaned up, but the cleaning up needs reviewing together with
the maintainers for the corresponding part; in particular, it can be
lengthy for the reviewing on amdtopology.c. I leave this as another
work for the time being.

-- 
Thanks.
HATAYAMA, Daisuke

