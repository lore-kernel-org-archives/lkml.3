Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758429Ab3D2Nux (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 09:50:53 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:43374 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758406Ab3D2Nuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 09:50:51 -0400
Message-ID: <517E7AB7.6050101@intel.com>
Date: Mon, 29 Apr 2013 14:50:47 +0100
From: Matt Fleming <matt.fleming@intel.com>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Linux-Next <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-efi@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "Luck, Tony" <tony.luck@intel.com>
Subject: Re: linux-next: Tree for Apr 26
References: <20130426180357.7599d1b6b7965470905dcdf3@canb.auug.org.au> <CAMuHMdWQ0rMuoH+peGMZ3=AdsYrMPpeV4_vSsLD3kaJukx=83w@mail.gmail.com> <20130429093628.b739ef3b879b6f8759bd31af@canb.auug.org.au> <517E2B21.8070009@intel.com> <20130429185322.afaed9fd11269fba9bb09a54@canb.auug.org.au>
In-Reply-To: <20130429185322.afaed9fd11269fba9bb09a54@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/04/13 09:53, Stephen Rothwell wrote:
> On Mon, 29 Apr 2013 09:11:13 +0100 Matt Fleming <matt.fleming@intel.com> wrote:
>>
>> On 29/04/13 00:36, Stephen Rothwell wrote:
>>> Commit e29c2de5f591 ("Merge tag 'v3.9-rc8' into efi-for-tip") by Matt
>>> Fleming from the tip tree merged v3.9-rc8 (which has 0635eb8a54cf) with
>>> the branch that contains 048517722cde but lost the "select UCS2_STRING"
>>> which should be in drivers/firmware/efi/Kconfig.
>>
>> Eek, yes. Sorry about that. How should we resolve this?
> 
> You should probably add a commit that puts the line back in your tree and
> get that merged into the tip tree.

Tip folks,

I applied the following to the 'efi-for-tip' branch in the EFI
repository. Unless someone complains I'll send a pull request shortly.

commit da74caa6cead3f6c55dabcaa7b397b2fddd655e3
Author: Matt Fleming <matt.fleming@intel.com>
Date:   Mon Apr 29 14:30:28 2013 +0100

    ia64, efi: select UCS2_STRING when building EFI support
    
    The ucs2 string library functions are required by the core EFI code.
    Select UCS2_STRING from the EFI symbol entry in arch/ia64/Kconfig, just
    like we do for x86. This Kconfig bug was caused by a mis-merge in commit
    e29c2de5f591 ("Merge tag 'v3.9-rc8' into efi-for-tip").
    
    Cc: Ingo Molnar <mingo@kernel.org>
    CC: H. Peter Anvin <hpa@zytor.com>
    Cc: Tony Luck <tony.luck@intel.com>
    Cc: Matthew Garrett <matthew.garrett@nebula.com>
    Signed-off-by: Matt Fleming <matt.fleming@intel.com>

diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 9a02f71..da18c8e 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -110,6 +110,7 @@ config DMI
 
 config EFI
 	bool
+	select UCS2_STRING
 	default y
 
 config SCHED_OMIT_FRAME_POINTER

