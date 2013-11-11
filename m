Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab3KKN1e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 08:27:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31168 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753376Ab3KKN10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 08:27:26 -0500
Message-ID: <5280DB2D.2080202@redhat.com>
Date: Mon, 11 Nov 2013 08:27:09 -0500
From: Joe Mario <jmario@redhat.com>
Reply-To: jmario@redhat.com
Organization: Red Hat
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130806 Thunderbird/17.0.8
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: Andi Kleen <andi@firstfloor.org>, Fengguang Wu <fengguang.wu@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [kallsyms] general protection fault: 0000 [#1] PREEMPT DEBUG_PAGEALLOC
References: <20131110094005.GA21916@localhost> <20131110152338.GN29695@two.firstfloor.org> <5280C87A.5050606@suse.cz>
In-Reply-To: <5280C87A.5050606@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2013 07:07 AM, Michal Marek wrote:
> On 10.11.2013 16:23, Andi Kleen wrote:
>> On Sun, Nov 10, 2013 at 05:40:05PM +0800, Fengguang Wu wrote:
>>> Hi Joe,
>>>
>>> FYI. Here is another bisect result.
>>
>> I bet it's that strncpy() in kallsyms.c and someone passing in a too
>> short buffer on a 32bit kernel.
>>
>> We should really kill strncpy(), it's just evil.
>
> I'm testing a patch for include/linux/pci.h to use line numbers instead
> of the PCI ID macros to declare the __pci_fixup_* symbols. If that
> works, we can revert the limit back to 128 and only keep the check in
> kallsyms.c.
>
> Michal

Michal:
  That would be great.

  I found six locations which were still using an array size hardwired to "128" instead of KSYM_NAME_LEN.  But none of them were related to the crash Fengguang Wu reported.  We built a 32-bit kernel from his config (with a few issues) but were unable to reproduce the crash.  Still trying.

  Whatever happens, I agree the check in kallsyms.c for kernel symbols whose length exceeds the buffer size, needs to be in place.

Joe

