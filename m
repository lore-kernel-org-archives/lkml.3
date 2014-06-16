Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557AbaFPBUA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 21:20:00 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:34678 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbaFPBT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 21:19:59 -0400
Date: Mon, 16 Jun 2014 02:19:46 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Daniel Kiper <daniel.kiper@oracle.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xenproject.org, andrew.cooper3@citrix.com,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        eshelton@pobox.com, hpa@zytor.com, ian.campbell@citrix.com,
        jbeulich@suse.com, jeremy@goop.org, konrad.wilk@oracle.com,
        matt.fleming@intel.com, mingo@redhat.com,
        stefano.stabellini@eu.citrix.com, tglx@linutronix.de
Subject: Re: [PATCH v5 1/7] efi: Use early_mem*() instead of early_io*()
Message-ID: <20140616011946.GC5104@srcf.ucam.org>
References: <1402678823-24589-1-git-send-email-daniel.kiper@oracle.com>
 <1402678823-24589-2-git-send-email-daniel.kiper@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402678823-24589-2-git-send-email-daniel.kiper@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 07:00:17PM +0200, Daniel Kiper wrote:
> Use early_mem*() instead of early_io*() because all mapped EFI regions
> are true RAM not I/O regions. Additionally, I/O family calls do not work
> correctly under Xen in our case. AIUI, early_io*() maps/unmaps real machine
> addresses. However, all artificial EFI structures created under Xen live
> in dom0 memory and should be mapped/unmapped using early_mem*() family
> calls which map domain memory.

Mapped EFI regions may include memory mapped flash, not merely true RAM.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
