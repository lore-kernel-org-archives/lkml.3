Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099Ab3HFQ51 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 12:57:27 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:17172 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755686Ab3HFQ5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 12:57:25 -0400
Message-ID: <1375808178.10300.181.camel@misato.fc.hp.com>
Subject: Re: [PATCH] ACPI, cpu hotplug: move try_offline_node() after
 acpi_unmap_lsapic()
From: Toshi Kani <toshi.kani@hp.com>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: rafael.j.wysocki@intel.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 06 Aug 2013 10:56:18 -0600
In-Reply-To: <5200CBBF.1090904@jp.fujitsu.com>
References: <5200CBBF.1090904@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-06 at 19:11 +0900, Yasuaki Ishimatsu wrote:
> try_offline_node() checks that all cpus related with removed node have been
> removed by using cpu_present_bits. If all cpus related with removed node have
> been removed, try_offline_node() clears the node information.
> 
> But try_offline_node() called from acpi_processor_remove() never clears
> the node information. For disabling cpu_present_bits, acpi_unmap_lsapic()
> need be called. But acpi_unmap_lsapic() is called after try_offline_node()
> runs. So when try_offline_node() runs, the cpu's cpu_present_bits is always
> set.
> 
> This patch moves try_offline_node() after acpi_unmap_lsapic().
> 
> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

The change looks good to me.

Acked-by: Toshi Kani <toshi.kani@hp.com>

BTW, do you know why try_offline_node() has to use stop_machine()?

Thanks,
-Toshi

