Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565AbaAORGN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 12:06:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38988 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049AbaAORGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 12:06:10 -0500
Date: Wed, 15 Jan 2014 12:05:25 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: hpa@linux.intel.com, jingbai.ma@hp.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, bp@alien8.de, ebiederm@xmission.com,
        akpm@linux-foundation.org, fengguang.wu@intel.com
Subject: Re: [RESEND PATCH v10] x86, apic, kexec, Documentation: Add
 disable_cpu_apicid kernel parameter
Message-ID: <20140115170525.GF3180@redhat.com>
References: <20140115064458.1545.38775.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140115064458.1545.38775.stgit@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 03:44:58PM +0900, HATAYAMA Daisuke wrote:
> Add disable_cpu_apicid kernel parameter. To use this kernel parameter,
> specify an initial APIC ID of the corresponding CPU you want to
> disable.
> 
> This is mostly used for the kdump 2nd kernel to disable BSP to wake up
> multiple CPUs without causing system reset or hang due to sending INIT
> from AP to BSP.
> 
> Kdump users first figure out initial APIC ID of the BSP, CPU0 in the
> 1st kernel, for example from /proc/cpuinfo and then set up this kernel
> parameter for the 2nd kernel using the obtained APIC ID.
> 
> However, doing this procedure at each boot time manually is awkward,
> which should be automatically done by user-land service scripts, for
> example, kexec-tools on fedora/RHEL distributions.
> 
> This design is more flexible than disabling BSP in kernel boot time
> automatically in that in kernel boot time we have no choice but
> referring to ACPI/MP table to obtain initial APIC ID for BSP, meaning
> that the method is not applicable to the systems without such BIOS
> tables.
> 
> One assumption behind this design is that users get initial APIC ID of
> the BSP in still healthy state and so BSP is uniquely kept in
> CPU0. Thus, through the kernel parameter, only one initial APIC ID can
> be specified.
> 
> In a comparison with disabled_cpu_apicid, we use read_apic_id(), not
> boot_cpu_physical_apicid, because on some platforms, the variable is
> modified to the apicid reported as BSP through MP table and this
> function is executed with the temporarily modified
> boot_cpu_physical_apicid. As a result, disabled_cpu_apicid kernel
> parameter doesn't work well for apicids of APs.
> 
> Fixing the wrong handling of boot_cpu_physical_apicid requires some
> reviews and tests beyond some platforms and it could take some
> time. The fix here is a kind of workaround to focus on the main topic
> of this patch.
> 
> Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>

I think this is a reasonable approach to solve the issue. Use a command
line to not bring up specific cpu in second kernel which can create
problems.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

hpa, I know you are not excited about this approach. If you made up your
mind that this appoarch is not worth pursuing, please do suggest what
would you like to see and we can give that a try.

We want to solve this problem as on large memory machines saving dump can
take lot of time and we want to bring up multiple cpus and speed up
compression and save on dump time.

Thanks
Vivek
