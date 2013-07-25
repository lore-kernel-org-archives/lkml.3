Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670Ab3GYMRP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 08:17:15 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:48750 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751680Ab3GYMRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 08:17:12 -0400
Message-ID: <51F1174D.2010105@ti.com>
Date: Thu, 25 Jul 2013 08:17:17 -0400
From: Tom Rini <trini@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Jianpeng Ma <majianpeng@gmail.com>, Rusty Russell <rusty@rustcorp.com.au>,
        <tglx@linutronix.de>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: compile x86_64 waring
References: <201307051956052638321@gmail.com>  <1374699912.29835.8.camel@x61.thuisdomein> <51F061CC.9080704@ti.com>  <1374742433.29835.31.camel@x61.thuisdomein> <1374745288.29835.41.camel@x61.thuisdomein>
In-Reply-To: <1374745288.29835.41.camel@x61.thuisdomein>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2013 05:41 AM, Paul Bolle wrote:
> Tom,
> 
> On Thu, 2013-07-25 at 10:53 +0200, Paul Bolle wrote:
>> But I've just pulled top-of-tree Linus, ie commit 07bc9dc1b0
>> ("git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc'"). I'll
>> try to build that and I 'll send you my .config if this all is still
>> triggered.
> 
> It is still seen with "make bzImage" at v3.11-rc2-185-g07bc9dc (current
> Linus' tip-of-tree). I get, in summary:
>     WARNING: arch/x86/mm/built-in.o(.text.unlikely+0xbf2): Section mismatch in reference from the function __node_set.constprop.0() to the variable .init.data:numa_nodes_parsed
>     WARNING: arch/x86/built-in.o(.text.unlikely+0x140e): Section mismatch in reference from the function __node_set.constprop.0() to the variable .init.data:numa_nodes_parsed
>     WARNING: vmlinux.o(.text.unlikely+0x1444): Section mismatch in reference from the function __node_set.constprop.0() to the variable .init.data:numa_nodes_parsed
> 
> But it is all the same thing (the issue apparently just repeat itself
> when arch/x86/mm/built-in.o is merged into arch/x86/built-in.o, and
> again when arch/x86/built-in.o is merged into vmlinux.o).

OK, thanks.  I just posted a patch that fixes the warning here.  The
problem is that __node_set wasn't being inlined by the compiler, so you
have the section mis-match above.

-- 
Tom
