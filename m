Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517AbaFWLAM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 07:00:12 -0400
Received: from mail.emea.novell.com ([130.57.118.101]:39272 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbaFWLAK convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:12:2>);
	Mon, 23 Jun 2014 07:00:10 -0400
Message-Id: <53A824D1020000780001C630@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.0 
Date: Mon, 23 Jun 2014 12:00:01 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "David Vrabel" <david.vrabel@citrix.com>, <x86@kernel.org>,
        <xen-devel@lists.xenproject.org>,
        "Daniel Kiper" <daniel.kiper@oracle.com>, <linux-efi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Cc: <andrew.cooper3@citrix.com>, <ian.campbell@citrix.com>,
        <stefano.stabellini@eu.citrix.com>, <jeremy@goop.org>,
        <matt.fleming@intel.com>, <tglx@linutronix.de>,
        <boris.ostrovsky@oracle.com>, <konrad.wilk@oracle.com>,
        <eshelton@pobox.com>, <mingo@redhat.com>, <mjg59@srcf.ucam.org>,
        <hpa@zytor.com>
Subject: Re: [PATCH v6 2/9] arch/x86: Do not access EFI memory map if
 it is not available
References: <1403299768-9955-1-git-send-email-daniel.kiper@oracle.com>
 <1403299768-9955-3-git-send-email-daniel.kiper@oracle.com>
 <53A7F8FF.2050309@citrix.com>
In-Reply-To: <53A7F8FF.2050309@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 23.06.14 at 11:53, <david.vrabel@citrix.com> wrote:
> On 20/06/14 22:29, Daniel Kiper wrote:
>> Do not access EFI memory map if it is not available. At least
>> Xen dom0 EFI implementation does not have an access to it.
> 
> Could it make one based on the XENMEM_memory_map or
> XENMEM_machine_memory_map hypercall?

No, the correct operation to implement this and efi_mem_type()
similar function is XEN_FW_EFI_INFO, index XEN_FW_EFI_MEM_INFO.

Jan

