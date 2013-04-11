Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311Ab3DKI7b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 04:59:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37861 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752239Ab3DKI73 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 04:59:29 -0400
From: Thomas Renninger <trenn@suse.de>
To: "Yu, Fenghua" <fenghua.yu@intel.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>, Yinghai Lu <yinghai@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Early microcode signing in secure boot environment -  Was: x86, microcode: Use common get_ramdisk_image()
Date: Thu, 11 Apr 2013 10:59:26 +0200
Message-ID: <195101369.cgl3lvkTHk@skinner.arch.suse.de>
Organization: SUSE Products GmbH
User-Agent: KMail/4.10 (Linux/3.7.10-1.1-desktop; KDE/4.10.0; x86_64; ; )
In-Reply-To: <3E5A0FA7E9CA944F9D5414FEC6C712205594C20D@ORSMSX105.amr.corp.intel.com>
References: <1365119186-23487-1-git-send-email-yinghai@kernel.org> <1478755.iNa1PauEka@skinner.arch.suse.de> <3E5A0FA7E9CA944F9D5414FEC6C712205594C20D@ORSMSX105.amr.corp.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 11, 2013 08:28:37 AM Yu, Fenghua wrote:
> > From: Thomas Renninger [mailto:trenn@suse.de]
...
> > Does this apply to secure boot specification?
> 
> Secure boot can add another level of security because the early loaded
> microcode is part of initrd and initrd is measured by secure boot.
Not sure what is ment with "initrd is measured by secure boot".

Afaik the initrd does not get signed and verified, I cannot imagine how
that could work as it needs to get regenerated on client systems.

I expect it works like this:
initrd does not need signing as it is not executed itself, it only gets 
extracted.
Everything inside the initrd is subject to the secure boot rules:
binaries or whatever data which gets executed with kernel
privileges (or updates firmware) needs verification through
secure boot keys.

> > Is this "cryptographically authenticated by the CPU itself" thing
> > documented
> > somewhere so that security people can double check that it is really
> > secure?
> 
> X86 SDM defines that the second part of microcode update is the encrypted
> data.

Again, I doubt it is allowed to bypass UEFI authentication with arbitrary, 
vendor specific authentication checks.

      Thomas
