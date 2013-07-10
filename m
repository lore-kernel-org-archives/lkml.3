Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651Ab3GJHly (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 03:41:54 -0400
Received: from vserver.eikelenboom.it ([84.200.39.61]:58816 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab3GJHlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 03:41:53 -0400
Date: Wed, 10 Jul 2013 09:41:34 +0200
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <1619064548.20130710094134@eikelenboom.it>
To: Matt Wilson <msw@amazon.com>
CC: Borislav Petkov <bp@alien8.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, <jeremy@goop.org>,
        <xen-devel@lists.xensource.com>, Jan Beulich <JBeulich@suse.com>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        <x86@kernel.org>, Paul Bolle <pebolle@tiscali.nl>,
        <virtualization@lists.linux-foundation.org>, <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <tglx@linutronix.de>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] xen: remove unused Kconfig parameter
In-Reply-To: <20130710061932.GB13671@u109add4315675089e695.ant.amazon.com>
References: <20130708192854.GF4927@phenom.dumpdata.com> <20130708193457.GA6926@u109add4315675089e695.ant.amazon.com> <51DB2134.9040909@zytor.com> <20130708205834.GA481@pd.tnic> <1373326534.1438.10.camel@x61.thuisdomein> <f5d6bd67-7464-4932-a7ca-6026fe534fc7@email.android.com> <51DBDAB802000078000E37C1@nat28.tlf.novell.com> <20130709144840.GF24897@phenom.dumpdata.com> <20130709150554.GA27579@pd.tnic> <1382658288.20130710003458@eikelenboom.it> <20130710061932.GB13671@u109add4315675089e695.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Wednesday, July 10, 2013, 8:19:34 AM, you wrote:

> On Wed, Jul 10, 2013 at 12:34:58AM +0200, Sander Eikelenboom wrote:
>> 
>> Tuesday, July 9, 2013, 5:05:54 PM, you wrote:
>> 
>> > On Tue, Jul 09, 2013 at 10:48:40AM -0400, Konrad Rzeszutek Wilk wrote:
>> >> Then that should be discussed on grub2 to remove said check and modify
>> >> the code so that it can properly work without regression.
>> 
>> > Actually, the kernel patch removing that symbol should be applied so
>> > that grub2 breaks faster. One can't possibly rely on kernel internals
>> > for anything, as it is insanely insane (yep, the tautology is on purpose
>> > :-)).
>>
>> How insanely insane is it to be able to determine whether a certain
>> compiled kernel binary supports a certain function ?
>> 
>> Grub does this in it's update script to prevent adding a xen +
>> kernel combination that has no chance of booting when dom0 support
>> has not been configured in the kernel.  That doesn't seem to be a
>> unreasonable thought.
>> 
>> Grepping the accompanied config file in /boot for the xen dom0
>> Kconfig parameter seems the best possible effort grub can do at the
>> moment.

> I think this can be improved, even with the situation today.

>> Especially since the Kconfig parameter naming doesn't change that
>> often.
>> 
>> If you know a better way for grub to determine if a certain function
>> for a kernel binary is supported then please elaborate ..

> Certainly. Parse the ELF notes that are present in a dom0-capable
> Linux kernel binary itself.

> $ readelf -n vmlinux

> Notes at offset 0x0069be88 with length 0x0000017c:
>   Owner         Data size       Description
>   Xen           0x00000006      Unknown note type: (0x00000006)
>   Xen           0x00000004      Unknown note type: (0x00000007)
>   Xen           0x00000008      Unknown note type: (0x00000005)
>   Xen           0x00000008      Unknown note type: (0x00000003)
>   Xen           0x00000008      NT_VERSION (version)
>   Xen           0x00000008      NT_ARCH (architecture)
>   Xen           0x0000002a      Unknown note type: (0x0000000a)
>   Xen           0x00000004      Unknown note type: (0x00000009)
>   Xen           0x00000008      Unknown note type: (0x00000008)
>   Xen           0x00000010      Unknown note type: (0x0000000d)
>   Xen           0x00000004      Unknown note type: (0x0000000e)
>   Xen           0x00000008      Unknown note type: (0x0000000c)
>   Xen           0x00000008      Unknown note type: (0x00000004)
>   GNU           0x00000014      NT_GNU_BUILD_ID (unique build ID bitstring)

> See arch/x86/xen/xen-head.S.

> There's a new note type (XEN_ELFNOTE_SUPPORTED_FEATURES) that we can
> use to make dom0 support explicit.

> http://xenbits.xen.org/gitweb/?p=xen.git;a=blob;f=xen/arch/x86/domain_build.c;hb=HEAD#l415

Seems like a better option, although completely dropping the check could be a option too.
Since dom0 support is in mainline distributions (at least Debian, haven't checked the other main yet) don't supply a seperate xen enabled kernel anymore,
so any distro supplied kernel has xen support. For the self-building case Borislav is probably right in that you have to watchout yourself.

So it would be nice to have at least some time to address this with upstream grub and the main distributions to patch their grub.

--
Sander


> --msw


