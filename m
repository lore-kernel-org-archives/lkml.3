Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950AbaFWONw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 10:13:52 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:32284 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980AbaFWONv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 10:13:51 -0400
Date: Mon, 23 Jun 2014 16:13:10 +0200
From: Daniel Kiper <daniel.kiper@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: David Vrabel <david.vrabel@citrix.com>, x86@kernel.org,
        xen-devel@lists.xenproject.org, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, andrew.cooper3@citrix.com,
        ian.campbell@citrix.com, stefano.stabellini@eu.citrix.com,
        jeremy@goop.org, matt.fleming@intel.com, tglx@linutronix.de,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com, eshelton@pobox.com,
        mingo@redhat.com, mjg59@srcf.ucam.org, hpa@zytor.com
Subject: Re: [PATCH v6 2/9] arch/x86: Do not access EFI memory map if it is
 not available
Message-ID: <20140623141310.GI28489@olila.local.net-space.pl>
References: <1403299768-9955-1-git-send-email-daniel.kiper@oracle.com>
 <1403299768-9955-3-git-send-email-daniel.kiper@oracle.com>
 <53A7F8FF.2050309@citrix.com>
 <53A824D1020000780001C630@mail.emea.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A824D1020000780001C630@mail.emea.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 12:00:01PM +0100, Jan Beulich wrote:
> >>> On 23.06.14 at 11:53, <david.vrabel@citrix.com> wrote:
> > On 20/06/14 22:29, Daniel Kiper wrote:
> >> Do not access EFI memory map if it is not available. At least
> >> Xen dom0 EFI implementation does not have an access to it.
> >
> > Could it make one based on the XENMEM_memory_map or
> > XENMEM_machine_memory_map hypercall?
>
> No, the correct operation to implement this and efi_mem_type()
> similar function is XEN_FW_EFI_INFO, index XEN_FW_EFI_MEM_INFO.

efi_mem_attributes() is used only on IA-64 arch. So, that is why
I completely removed relevant Xen code.

Daniel
