Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526AbaANPPW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 10:15:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50927 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318AbaANPPU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 10:15:20 -0500
Message-ID: <52D55468.6000000@zytor.com>
Date: Tue, 14 Jan 2014 07:14:48 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: AMD errata 793 (CVE-2013-6885) needs a workaround in Linux?
References: <20140114114133.GA31473@khazad-dum.debian.net> <20140114115547.GA29887@pd.tnic>
In-Reply-To: <20140114115547.GA29887@pd.tnic>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2014 03:55 AM, Borislav Petkov wrote:
> On Tue, Jan 14, 2014 at 09:41:33AM -0200, Henrique de Moraes Holschuh wrote:
>> I just got this assigned to amd64-microcode in Debian, but it is something
>> that needs to be worked around by the EFI/BIOS and/or the kernel.
>>
>> Since we all know just how well it pans out to depend on BIOS/EFI updates
>> for *anything*, I'm raising the issue here.  IMHO looks like it would be
>> worthwhile to either set the relevant MSR in the kernel if the BIOS didn't
>> do it, or at least warn the user of the need for a BIOS/EFI update...
>>
>> It is the usual hangs-core type of CPU errata (therefore, the best type
>> since it won't cause silent data corruption).  gcc-produced code managed to
>> trigger it (in DragonFly BSD).
> 
> I think this is a different issue than the dragonfly issue. In any case,
> if AMD delivers all BIOS with this workaround enabled, we don't need to
> do anything. And I asked them about it so we'll have an answer soon, I
> hope.
> 
> In any case, I'm on it.
> 

Seriously, though, if this MSR can be set at runtime without problems
(which covers 98% of all workarounds, but not 100%) then it seems like a
no-brainer to just do it as long as the offending CPUs can be identified
by the kernel.

	-hpa

