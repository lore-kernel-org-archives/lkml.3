Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab3KKMH3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 07:07:29 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58680 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752890Ab3KKMH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 07:07:26 -0500
Message-ID: <5280C87A.5050606@suse.cz>
Date: Mon, 11 Nov 2013 13:07:22 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Joe Mario <jmario@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [kallsyms] general protection fault: 0000 [#1] PREEMPT DEBUG_PAGEALLOC
References: <20131110094005.GA21916@localhost> <20131110152338.GN29695@two.firstfloor.org>
In-Reply-To: <20131110152338.GN29695@two.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.11.2013 16:23, Andi Kleen wrote:
> On Sun, Nov 10, 2013 at 05:40:05PM +0800, Fengguang Wu wrote:
>> Hi Joe,
>>
>> FYI. Here is another bisect result.
> 
> I bet it's that strncpy() in kallsyms.c and someone passing in a too
> short buffer on a 32bit kernel.
> 
> We should really kill strncpy(), it's just evil.

I'm testing a patch for include/linux/pci.h to use line numbers instead
of the PCI ID macros to declare the __pci_fixup_* symbols. If that
works, we can revert the limit back to 128 and only keep the check in
kallsyms.c.

Michal
