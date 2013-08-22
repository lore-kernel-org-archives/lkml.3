Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab3HVVdK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 17:33:10 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:63719 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985Ab3HVVdH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 17:33:07 -0400
Date: Thu, 22 Aug 2013 16:32:55 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [RFC] Get rid of SUBARCH
To: David Daney <ddaney.cavm@gmail.com>
Cc: Richard Weinberger <richard@nod.at>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sam Ravnborg <sam@ravnborg.org>,
        Linux-Arch <linux-arch@vger.kernel.org>, Michal Marek <mmarek@suse.cz>,
        Ralf Baechle <ralf@linux-mips.org>, Paul Mundt <lethal@linux-sh.org>,
        Jeff Dike <jdike@addtoit.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-m68k <linux-m68k@vger.kernel.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        uml-devel <user-mode-linux-devel@lists.sourceforge.net>
In-Reply-To: <52167AB8.4060206@gmail.com> (from ddaney.cavm@gmail.com on Thu
	Aug 22 15:55:20 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1377207175.2737.113@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2013 03:55:20 PM, David Daney wrote:
> On 08/22/2013 01:41 PM, Rob Landley wrote:
>> On 08/22/2013 07:58:26 AM, Geert Uytterhoeven wrote:
>>> On Wed, Aug 21, 2013 at 9:51 PM, Sam Ravnborg <sam@ravnborg.org>  
>>> wrote:
>>> >> > The series touches also m68k, sh, mips and unicore32.
>>> >> > These architectures magically select a cross compiler if ARCH  
>>> !=
>>> SUBARCH.
>>> >> > Do really need that behavior?
>>> >>
>>> >> This does remove functionality.
>>> >> It allows to build a kernel using e.g. "make ARCH=m68k".
>>> >>
>>> >> Perhaps this can be moved to generic code? Most (not all!)
>>> cross-toolchains
>>> >> are called $ARCH-{unknown-,}linux{,-gnu}.
>>> >> Exceptions are e.g. am33_2.0-linux and bfin-uclinux.
>>> >
>>> > Today you can specify CROSS_COMPILE in Kconfig.
>>> > With this we should be able to remove these hacks.
>>> 
>>> The correct CROSS_COMPILE value depends on the host environment, not
>>> on the target configuration.
>> 
>> Actually it depends on _both_.
>> 
> 
> I think the important issue is not the exact dependencies of the  
> value of CROSS_COMPILE, but rather that it varies enough that  
> automatically choosing a value based on SUBARCH often gives the wrong  
> result.
> 
> Removing SUBARCH and setting CROSS_COMPILE either from the make  
> command line (or environment) or the config file, is a good idea  
> because it simplifies the build system, makes things clearer, and  
> yields more predictable results.
> 
> David Daney

Agreed. Expecting the build to guess the right $CROSS_COMPILE is like  
expecting it to guess the right $PATH. It should be specified, not  
heuristically probed.

Rob