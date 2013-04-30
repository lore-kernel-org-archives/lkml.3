Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760446Ab3D3Lyf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 07:54:35 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:35209 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759863Ab3D3Lyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 07:54:33 -0400
Message-ID: <517FB0F6.9030103@console-pimps.org>
Date: Tue, 30 Apr 2013 12:54:30 +0100
From: Matt Fleming <matt@console-pimps.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] EFI merge botch fix
References: <20130429181819.GA2254@console-pimps.org> <20130430084731.GB21473@gmail.com>
In-Reply-To: <20130430084731.GB21473@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/04/13 09:47, Ingo Molnar wrote:
> The other problem is that tip:x86/efi also conflicts with current -git, as 
> of v3.9 - due to interaction with an EFI fix tree ...
> 
> This is getting ugly pretty fast, so I'd suggest to re-do the merges 
> cleanly, not by rebasing the tree, but by redoing the first merge in 
> essence:
> 
>   e29c2de5f591 Merge tag 'v3.9-rc8' into efi-for-tip
> 
> By correctly merging v3.9-final into f53f292 - making sure the changes to 
> drivers/firmware/efivars.c correctly merge over, and making sure the ia64 
> select does not get lost.
> 
> Something like this would do:
> 
>   git checkout -b x86-new-efi-branch f53f292
>   git merge v3.9
>   < ... resolve all the conflicts ...>
>   git commit
> 
> I can then (non-fast-forward) fetch this new EFI branch as the new 
> tip:x86/efi.

OK, I re-did the merge against v3.9 as requested and published it as
'efi-for-tip2'. Would you like me to send a proper pull request if
that's easier to pull into the tip machinery?

I have also started accumulating fixes against the EFI changes in
tip/x86/efi. Would you like those as a separate pull request? The fixes
branch is 'efi-for-tip-fixes' and is based on the above merge branch,
'efi-for-tip2'. It mainly includes fixes for bugs in the pstore paths
which Seiji Aguchi found.

-- 
Matt Fleming, Intel Open Source Technology Center
