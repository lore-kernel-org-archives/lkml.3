Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930AbaIWOZp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 10:25:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42563 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755823AbaIWOZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 10:25:44 -0400
Message-ID: <542182E0.6090101@canonical.com>
Date: Tue, 23 Sep 2014 16:25:36 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
CC: Matt Fleming <matt.fleming@intel.com>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Roy Franz <roy.franz@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Boyer <jwboyer@redhat.com>
Subject: Re: [GIT PULL] x86 fixes
References: <20140919104021.GA11552@gmail.com> <CA+55aFxW9PmtjOf9nUQwpU8swsFqJOz8whZXcONo+XFmkSwezg@mail.gmail.com> <20140923053510.GB27825@gmail.com> <20140923053711.GA28704@gmail.com> <20140923055802.GA29052@gmail.com> <1411456851.21380.355.camel@mfleming-mobl1.ger.corp.intel.com> <CAKv+Gu_xqnkVKuoWY=PRoAVYE_qOH8dwM+ZxG+ysC7Xvs82ZNw@mail.gmail.com> <20140923131805.GH18635@console-pimps.org>
In-Reply-To: <20140923131805.GH18635@console-pimps.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

Op 23-09-14 om 15:18 schreef Matt Fleming:
> On Tue, 23 Sep, at 10:18:07AM, Ard Biesheuvel wrote:
>> It will be difficult for me to keep up with this thread over the next
>> days, so I have added Leif and Roy on cc. If you need to make any
>> changes that affect arm64, they should be able to confirm whether it
>> causes any problems or not.
> OK, below is what I've got on top of commit f3670394c29f in Linus' tree.
> Please don't anyone pick this up yet, I'm still testing it on my
> machines and it desperately needs some Tested-by tags.
>
> Josh, your machines probably boot fine after the revert from Linus but
> it'd be good to verify that this patch doesn't make things any worse.
>
> Maarten, please verify that your Macbook pro boots with this patch. I
> very much want to be able to add a Tested-by from you.
>
> Ard, Leif, Roy, can you please validate this for arm64? The thing to
> look out for is whether the changes to drivers/firmware/efi/Makefile
> make sense, and in particular, whether it's ever possible to have
> CONFIG_EFI_STUB=y and CONFIG_EFI_ARM_STUB=n.
>
> If the answer is yes, then this patch might break your build and we
> probably want to do something like unconditionally select
> CONFIG_EFI_ARM_STUB when CONFIG_EFI_STUB=y.
>
It seems to boot for me with direct efi netboot. But when I'm doing a local boot through refind instead I also hit that setup_efi_pci() failed bug, it doesn't look like it's fixed by reverting all the efi stub patches though.
This might need more bisecting first...

~Maarten
