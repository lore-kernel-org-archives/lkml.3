Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab3KKOMZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 09:12:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35862 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753281Ab3KKOMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 09:12:17 -0500
Message-ID: <5280E5BC.10209@suse.cz>
Date: Mon, 11 Nov 2013 15:12:12 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: jmario@redhat.com
Cc: Andi Kleen <andi@firstfloor.org>, Fengguang Wu <fengguang.wu@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [kallsyms] general protection fault: 0000 [#1] PREEMPT DEBUG_PAGEALLOC
References: <20131110094005.GA21916@localhost> <20131110152338.GN29695@two.firstfloor.org> <5280C87A.5050606@suse.cz> <5280DB2D.2080202@redhat.com>
In-Reply-To: <5280DB2D.2080202@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.11.2013 14:27, Joe Mario wrote:
> On 11/11/2013 07:07 AM, Michal Marek wrote:
>> I'm testing a patch for include/linux/pci.h to use line numbers
>> instead of the PCI ID macros to declare the __pci_fixup_* symbols.
>> If that works, we can revert the limit back to 128 and only keep
>> the check in kallsyms.c.
>> 
>> Michal
> 
> Michal: That would be great.

I just posted the patches.


> I found six locations which were still using an array size hardwired
> to "128" instead of KSYM_NAME_LEN.  But none of them were related to
> the crash Fengguang Wu reported.  We built a 32-bit kernel from his
> config (with a few issues) but were unable to reproduce the crash.
> Still trying.

I also did not manage to reproduce it, but then I didn't try too hard.


> Whatever happens, I agree the check in kallsyms.c for kernel symbols
> whose length exceeds the buffer size, needs to be in place.

I plan to merge "[PATCH 2/2] kallsyms: Revert back to 128 max symbol
length" to kbuild.git ASAP, even if "[PATCH 1/2] PCI: Do not use PCI ID
macros in quirk names" is merged later.

Michal
