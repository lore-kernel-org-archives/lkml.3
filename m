Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336Ab3KUVdx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 16:33:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2659 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754059Ab3KUVdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 16:33:47 -0500
Date: Thu, 21 Nov 2013 16:33:00 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: hpa@linux.intel.com, ebiederm@xmission.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, bp@alien8.de, akpm@linux-foundation.org,
        fengguang.wu@intel.com, jingbai.ma@hp.com
Subject: Re: [PATCH v6 2/3] x86, apic: Add disable_cpu_apicid kernel parameter
Message-ID: <20131121213300.GR16208@redhat.com>
References: <20131121015951.2748.47826.stgit@localhost6.localdomain6>
 <20131121020044.2748.70221.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131121020044.2748.70221.stgit@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 11:00:44AM +0900, HATAYAMA Daisuke wrote:

[..]
> @@ -2122,6 +2129,19 @@ void generic_processor_info(int apicid, int version)
>  	bool boot_cpu_detected = physid_isset(boot_cpu_physical_apicid,
>  				phys_cpu_present_map);
>  
> +	if (disabled_cpu_apicid != BAD_APICID &&
> +	    disabled_cpu_apicid != boot_cpu_physical_apicid &&

Hi Hatayama,

So we are comparing disabled_cpu_apicid with boot_cpu_physical_apicid
to make sure that one can not disable the cpu we are booting on. Can
we just read the apic id of booting cpu in local variable and compare
against that?

Something like as follows.

	if (disabled_cpu_apicid != BAD_APICID &&
	    disabled_cpu_apicid == apicid &&
	    disabled_cpu_apicid != read_apic_id()) {
		/* Disable cpu */	
	}

If above works, you will not need first patch in the series?

Thanks
Vivek
