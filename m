Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534Ab3DSF63 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 01:58:29 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:36300 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756478Ab3DSF61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 01:58:27 -0400
Date: Thu, 18 Apr 2013 22:58:13 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Bryan O'Donoghue" <bryan.odonoghue.lkml@nexus-software.ie>
Cc: matt@console-pimps.org, matthew.garrett@nebula.com,
        linux-efi@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, darren.hart@intel.com,
        josh@joshtriplett.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de
Subject: Re: [PATCH] Remove warning in efi_enter_virtual_mode V2
Message-ID: <20130419055813.GA16443@kroah.com>
References: <1366236341-22615-1-git-send-email-bryan.odonoghue.lkml@nexus-software.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366236341-22615-1-git-send-email-bryan.odonoghue.lkml@nexus-software.ie>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 17, 2013 at 11:05:41PM +0100, Bryan O'Donoghue wrote:
> Some EFI BIOS stores BGRT data in the wrong place and some EFI based
> BIOS also requires mapping of boot code/data when doing
> efi_enter_virtual_mode.
> 
> Current code in efi_enter_virtual_mode maps both EFI_RUNTIME_MEMORY and
> BIOS boot code/data.
> 
> This patch gives the option to switch off that behavior - if your BIOS
> has neither BGRT - nor bugs that require mapping of EFI boot code/data

No, never add new boot options, no users, or distros, know to set them.
Isn't there some way we can dynamically determine this instead?

thanks,

greg k-h
