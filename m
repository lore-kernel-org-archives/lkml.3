Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbbAVLMK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 06:12:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45490 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752086AbbAVLLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 06:11:55 -0500
Message-ID: <54C0DAF7.5040406@suse.com>
Date: Thu, 22 Jan 2015 12:11:51 +0100
From: Juergen Gross <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Steven Noonan <steven@uplinklabs.net>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux-X86 <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        stefan.bader@canonical.com,
        Linux Kernel mailing List <linux-kernel@vger.kernel.org>,
        xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        ville.syrjala@linux.intel.com, David Vrabel <david.vrabel@citrix.com>,
        Jan Beulich <jbeulich@suse.com>, toshi.kani@hp.com,
        plagnioj@jcrosoft.com, tomi.valkeinen@ti.com, bhelgaas@google.com
Subject: Re: [PATCH V6 01/18] x86: Make page cache mode a real type
References: <1415019724-4317-1-git-send-email-jgross@suse.com> <1415019724-4317-2-git-send-email-jgross@suse.com> <CAKbGBLhzOPXqWuDwEoqnvC05c1cFgXrJMHFmeCjwUYcff==F3A@mail.gmail.com> <54C0CDD8.2010205@suse.com> <alpine.DEB.2.11.1501221202300.5526@nanos>
In-Reply-To: <alpine.DEB.2.11.1501221202300.5526@nanos>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2015 12:06 PM, Thomas Gleixner wrote:
> On Thu, 22 Jan 2015, Juergen Gross wrote:
>> On 01/22/2015 08:11 AM, Steven Noonan wrote:
>>> I notice these two symbols are exported GPL-only. This breaks builds
>>> of several out-of-tree non-GPL modules such as the NVIDIA driver, and
>>> VMware modules, etc. What is the appropriate code path for proprietary
>>> modules to use when setting page cache mode flags? Alternatively, is
>>> it possible for these EXPORT_SYMBOL_GPLs to be changed to
>>> EXPORT_SYMBOL?
>>
>> I don't mind you sending a patch to change this. I won't object such a
>> patch. OTOH this is more kind of a political question and I don't want
>> to spend my time on arguing.
>
> It's rather simple. If the new cache stuff replaces code which was
> available under EXPORT_SYMBOL, we either need a compat export or make
> the new exports non GPL.
>
> Not that I like it, but that has been the policy so far. We only break
> out of tree stuff if the export is broken or security relevant, like
> we did with the init_mm export a few years ago.

Okay, in this case I'll write patch.

Thanks for clarifying this.


Juergen

