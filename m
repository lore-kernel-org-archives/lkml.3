Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758281Ab3EWL6G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 07:58:06 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:54403 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757843Ab3EWL6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 07:58:05 -0400
Date: Thu, 23 May 2013 12:58:01 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Russ Anderson <rja@sgi.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>, matt.fleming@intel.com,
        linux-efi@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [regression, bisected] x86: efi: Pass boot services variable
 info to runtime code
Message-ID: <20130523115801.GJ14575@console-pimps.org>
References: <20130522162747.GA20816@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130522162747.GA20816@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 May, at 11:27:47AM, Russ Anderson wrote:
> [    6.062157] EFI Variables Facility v0.08 2004-May-17
> [    6.067731] BUG: unable to handle kernel paging request at 000000007ca95b10
> [    6.075519] IP: [<ffff88007dbf2140>] 0xffff88007dbf213f

This is a bit of a head scratcher. Could you paste the EFI memmap
entries in your dmesg for the regions that cover 0x7ca95b10 and
0x7dbf2140?  My guess would be that they're EFI runtime code regions,
which would at least explain why we seem to be executing code in the
direct mapping region (0xffff8800xxxxxxxx).

Are you booting via the EFI boot stub?

-- 
Matt Fleming, Intel Open Source Technology Center
