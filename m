Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153Ab3AQM3s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 07:29:48 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:46963 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752064Ab3AQM3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 07:29:46 -0500
Message-ID: <1358425782.8203.413.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: [PATCH] fix setup_efi_pci()
From: Matt Fleming <matt@console-pimps.org>
To: Jan Beulich <JBeulich@suse.com>
Cc: Bjorn Helgaas <bjorn.helgaas@google.com>, linux-kernel@vger.kernel.org,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        linux-efi <linux-efi@vger.kernel.org>
Date: Thu, 17 Jan 2013 12:29:42 +0000
In-Reply-To: <50F3D70402000078000B530E@nat28.tlf.novell.com>
References: <50F3D70402000078000B530E@nat28.tlf.novell.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-01-14 at 08:59 +0000, Jan Beulich wrote:
> This fixes three issues:
> - missing parentheses around a flag test
> - wrong memory type used for allocation intended to persist post-boot
> - four similar build warnings on 32-bit (casts between different size
>   pointers and integers)
> 
> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> 
> ---
>  arch/x86/boot/compressed/eboot.c |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)

Jan, could you resubmit items 2 and 3 as separate patches please? Item 1
on your list has already been fixed in Linus' tree,

commit 886d751a2ea99a160f2d0a472231566d9cb0cf58
Author: Sasha Levin <sasha.levin@oracle.com>
Date:   Thu Dec 20 14:11:33 2012 -0500

    x86, efi: correct precedence of operators in setup_efi_pci
    
    With the current code, the condition in the if() doesn't make much sense due
    precedence of operators.
    
    Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
    Link: http://lkml.kernel.org/r/1356030701-16284-25-git-send-email-sasha.levi
    Cc: Matt Fleming <matt.fleming@intel.com>
    Cc: Matthew Garrett <mjg@redhat.com>
    Cc: Bjorn Helgaas <bhelgaas@google.com>
    Cc: Seth Forshee <seth.forshee@canonical.com>
    Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>

-- 
Matt Fleming, Intel Open Source Technology Center

