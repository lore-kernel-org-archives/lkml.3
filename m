Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbaDNJU6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 05:20:58 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:44133 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbaDNJUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 05:20:52 -0400
Date: Mon, 14 Apr 2014 11:20:47 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Igor Mammedov <imammedo@redhat.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, bp@suse.de,
        paul.gortmaker@windriver.com, JBeulich@suse.com, prarit@redhat.com,
        drjones@redhat.com, toshi.kani@hp.com, riel@redhat.com,
        gong.chen@linux.intel.com, andi@firstfloor.org, lenb@kernel.org,
        rjw@rjwysocki.net, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v3 4/5] x86: fix memory corruption in acpi_unmap_lsapic()
Message-ID: <20140414092047.GC19771@gmail.com>
References: <1397150061-29735-1-git-send-email-imammedo@redhat.com>
 <1397150061-29735-5-git-send-email-imammedo@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397150061-29735-5-git-send-email-imammedo@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Igor Mammedov <imammedo@redhat.com> wrote:

> if during CPU hotplug master CPU failed to wake up AP
> it set percpu x86_cpu_to_apicid to BAD_APICID=0xFFFF for AP.
> 
> However following attempt to unplug that CPU will lead to
> out of bound write access to __apicid_to_node[] which is
> 32768 items long on x86_64 kernel.
> 
> So drop setting x86_cpu_to_apicid to BAD_APICID in do_boot_cpu()
> and allow acpi_processor_remove()->acpi_unmap_lsapic() cleanly
> remove CPU.

Same suggestion as for the other fix patch: the fix should precede the 
patch that exposes it.

Thanks,

	Ingo
