Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326AbaDTKyg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 06:54:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40750 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754911AbaDTKy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 06:54:28 -0400
Date: Sun, 20 Apr 2014 12:54:19 +0200
From: Borislav Petkov <bp@suse.de>
To: Myron Stowe <myron.stowe@redhat.com>
Cc: bhelgaas@google.com, linux-pci@vger.kernel.org,
        suravee.suthikulpanit@amd.com, aravind.gopalakrishnan@amd.com,
        kim.naru@amd.com, daniel@numascale.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org, sp@numascale.com,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/5] PCI: Remove redundant 'quirk_amd_nb_node'
Message-ID: <20140420105419.GB19676@pd.tnic>
References: <20140419025308.2408.51252.stgit@amt.stowe>
 <20140419025345.2408.99229.stgit@amt.stowe>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140419025345.2408.99229.stgit@amt.stowe>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2014 at 08:53:46PM -0600, Myron Stowe wrote:
> With the amd_bus.c updates to support additional AMD processors (11h, 12h,
> 14h 15h  and 16h) 'quirk_amd_nb_node' seems to be redundant.  This patch
> removes it.
> 
> Signed-off-by: Myron Stowe <myron.stowe@redhat.com>

Good idea. Has this been tested, though? There are a bunch of places
using dev_to_node() which this quirk corrects, especially 'local_cpus'
in a bunch of sysfs nodes in the PCI hierarchy /sys/devices/pci*.

We want to make sure this doesn't break that and other dev_to_node()
callsites.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
