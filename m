Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbaEHPha (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 11:37:30 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:34600 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbaEHPh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 11:37:28 -0400
Date: Thu, 8 May 2014 17:37:22 +0200
From: Robert Richter <rric@kernel.org>
To: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
Cc: bhelgaas@google.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>,
        Borislav Petkov <bp@suse.de>, Daniel J Blueman <daniel@numascale.com>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        Myron Stowe <myron.stowe@redhat.com>
Subject: Re: [PATCH V3 1/3] x86/PCI: Fix PCI root numa_node info on AMD
 family15h
Message-ID: <20140508153722.GO32718@rric.localhost>
References: <1399489127-6961-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1399489127-6961-2-git-send-email-suravee.suthikulpanit@amd.com>
 <20140508085905.GK32718@rric.localhost>
 <20140508090148.GL32718@rric.localhost>
 <536B973B.2000207@amd.com>
 <20140508151402.GN32718@rric.localhost>
 <536BA0E3.4050709@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <536BA0E3.4050709@amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08.05.14 10:21:07, Suravee Suthikulanit wrote:
> The reason I put it all these comments here is because it took us a while to
> discuss what to do with this file going forward. There were some confusions.
> Therefore, I just want to document it here.
> 
> Also, the check for (boot_cpu_data.x86 > 0x11) was needed because it should
> not be done for family15h.

Yes, the only functional change of this patch is adding the bridge and
the family check, right? Basically:

+       { 0, 0x18, PCI_VENDOR_ID_AMD, 0x1600 },

and

+        /*
+         * The following code is only supported until Fam11h.
+         * Newer processors will depend on ACPI MCFG table instead.
+         */
+        if (boot_cpu_data.x86 > 0x11)
+                return 0;
+

This patch should stripped down to only those changes with a
split. And maybe this should be added to linux-stable?

All other rework is a different story... Can be done on top of this,
though I would drop it.

-Robert
