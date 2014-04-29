Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933659AbaD2Kq3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 06:46:29 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:45449 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932384AbaD2Kq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 06:46:27 -0400
Date: Tue, 29 Apr 2014 11:46:16 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Borislav Petkov <bp@suse.de>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, hpa@zytor.com,
        ricardo.neri-calderon@linux.intel.com, tglx@linutronix.de,
        matt.fleming@intel.com, linux-tip-commits@vger.kernel.org,
        Seiji Aguchi <seiji.aguchi@hds.com>
Subject: Re: [tip:x86/efi] x86/efi: Save and restore FPU context around
 efi_calls (x86_64)
Message-ID: <20140429104616.GF26088@console-pimps.org>
References: <tip-de05764e0b2a3d9559e099a2e134f8cef4500fdd@git.kernel.org>
 <20140420002811.GA18663@pd.tnic>
 <20140425110936.GB26088@console-pimps.org>
 <20140425114010.GA20275@nazgul.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140425114010.GA20275@nazgul.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Apr, at 01:40:10PM, Borislav Petkov wrote:
> 
> Well, the more I think about it, the more I'm persuaded that
> you actually do *really* need that WARN_ON_ONCE check there to
> make sure you're not fiddling with the FPU while in an interrupt
> context and in an unsafe way (see interrupted_kernel_fpu_idle() and
> interrupted_user_mode()). And so you do need the variants without the
> "__" which include the check.
> 
> Anyway, here it is, do give it a good run:

Thanks Borislav, I gave this a run on my machines and everything appears
to be fine. I'll probably send it to tip by the end of the week, I'm
just gonna let it stew on my 'next' branch for a while.

-- 
Matt Fleming, Intel Open Source Technology Center
