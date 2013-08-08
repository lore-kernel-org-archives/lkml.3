Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758165Ab3HHVqE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 17:46:04 -0400
Received: from relay2.sgi.com ([192.48.179.30]:55572 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758094Ab3HHVqC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 17:46:02 -0400
Message-ID: <52041189.9060807@sgi.com>
Date: Thu, 08 Aug 2013 16:45:45 -0500
From: "Brian J. Johnson" <bjohnson@sgi.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: edk2-devel@lists.sourceforge.net
Cc: Borislav Petkov <bp@alien8.de>, linux-efi@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>, gleb@redhat.com,
        lersek@redhat.com
Subject: Re: [edk2] Corrupted EFI region
References: <51FFC19A.1020204@redhat.com> <20130805161247.GF31845@pd.tnic> <51FFD5B0.9080000@redhat.com> <20130805164731.GG31845@pd.tnic> <52001896.1030509@redhat.com> <20130805220808.GC14067@pd.tnic> <20130806141036.GD14891@pd.tnic> <520116D1.2010000@redhat.com> <20130807151935.GJ17920@pd.tnic> <5202889C.2080608@redhat.com> <20130808150249.GB27974@pd.tnic>
In-Reply-To: <20130808150249.GB27974@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2013 10:02 AM, Borislav Petkov wrote:
> On Wed, Aug 07, 2013 at 07:49:16PM +0200, Laszlo Ersek wrote:
>>> Now, lines 01 to 05*do not happen*.
>>>
>>> More precisely, they don't happen in the kernel. They happen in the
>>> firmware. Specifically, "OvmfPkg/Library/LoadLinuxLib/Linux.c".
>>>
>>> You're booting the kernel from the qemu command line. The kernel you
>>> run is also an "[o]ld kernel[] without EFI handover protocol". So what
>>> happens is, OVMF downloads the kernel image from qemu over fw_cfg,
>>> figures it's an old kernel...
>
> Right, I think this is easier than having to go into the EFI shell each
> time and run bzImage.efi. Unless there's a faster way to do that along
> with passing it kernel command line parameters...

You can use mtools or some other utility to update the kernel image and 
bootloader configuration files on the disk image, so it boots the way 
you want.

Or you could set OVMF to boot to the shell, and put a startup.nsh file 
on the boot partition which invokes the loader with the options you 
want.  That may be a bit simpler than rewriting a grub config.  We use 
this technique on our internal simulator.
-- 

                                                 Brian Johnson

--------------------------------------------------------------------

    "The lack of explanation demands an explanation."
                                            -- Schaffer
