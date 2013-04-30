Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759829Ab3D3Irk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 04:47:40 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:41464 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759725Ab3D3Irf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 04:47:35 -0400
Date: Tue, 30 Apr 2013 10:47:31 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] EFI merge botch fix
Message-ID: <20130430084731.GB21473@gmail.com>
References: <20130429181819.GA2254@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130429181819.GA2254@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matt Fleming <matt@console-pimps.org> wrote:

> Hi folks,
> 
> This commit fixes the merge botch I created when merging -rc8 into
> tip/x86/efi, where I dropped the "select UCS2_STRING" string from
> drivers/firmware/Kconfig. The string actually needs to be moved to
> arch/ia64 because parts of the core EFI support in drivers/firmware/efi/
> require the ucs2 string functions.
> 
> The following changes since commit e29c2de5f591490fd51225081e5d7579c6699247:
> 
>   Merge tag 'v3.9-rc8' into efi-for-tip (2013-04-22 12:53:22 +0100)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git efi-for-tip
> 
> for you to fetch changes up to da74caa6cead3f6c55dabcaa7b397b2fddd655e3:
> 
>   ia64, efi: select UCS2_STRING when building EFI support (2013-04-29 14:46:15 +0100)
> 
> ----------------------------------------------------------------
> Matt Fleming (1):
>       ia64, efi: select UCS2_STRING when building EFI support
> 
>  arch/ia64/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> -- 
> Matt Fleming, Intel Open Source Technology Center

The other problem is that tip:x86/efi also conflicts with current -git, as 
of v3.9 - due to interaction with an EFI fix tree ...

This is getting ugly pretty fast, so I'd suggest to re-do the merges 
cleanly, not by rebasing the tree, but by redoing the first merge in 
essence:

  e29c2de5f591 Merge tag 'v3.9-rc8' into efi-for-tip

By correctly merging v3.9-final into f53f292 - making sure the changes to 
drivers/firmware/efivars.c correctly merge over, and making sure the ia64 
select does not get lost.

Something like this would do:

  git checkout -b x86-new-efi-branch f53f292
  git merge v3.9
  < ... resolve all the conflicts ...>
  git commit

I can then (non-fast-forward) fetch this new EFI branch as the new 
tip:x86/efi.

Thanks,

	Ingo
