Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751352AbaIAEDL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 00:03:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42548 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718AbaIAEDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 00:03:09 -0400
Message-ID: <5403EFFA.50701@suse.com>
Date: Mon, 01 Sep 2014 06:03:06 +0200
From: Juergen Gross <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jan Beulich <JBeulich@suse.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Kees Cook <keescook@chromium.org>,
        Stefan Bader <stefan.bader@canonical.com>,
        David Vrabel <david.vrabel@citrix.com>
Subject: Re: [Xen-devel] [PATCH] Solved the Xen PV/KASLR riddle
References: <20140827204940.GA10556@laptop.dumpdata.com>	<1409248903-19625-1-git-send-email-stefan.bader@canonical.com>	<20140829140823.GF3609@laptop.dumpdata.com>	<54008DDA.3040701@canonical.com>	<5400ADD6020000780002F159@mail.emea.novell.com> <20140829145558.GK3609@laptop.dumpdata.com>
In-Reply-To: <20140829145558.GK3609@laptop.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2014 04:55 PM, Konrad Rzeszutek Wilk wrote:
> On Fri, Aug 29, 2014 at 03:44:06PM +0100, Jan Beulich wrote:
>>>>> On 29.08.14 at 16:27, <stefan.bader@canonical.com> wrote:
>>> Sure. Btw, someone also contacted me saying they have the same problem
>>> without
>>> changing the layout but having really big initrd (500M). While that feels
>>> like
>>> it should be impossible (if the kernel+initrd+xen stuff has to fix the 512M
>>> kernel image size area then). But if it can happen, then surely it does
>>> cause
>>> mappings to be where the module space starts then.
>>
>> Since the initrd doesn't really need to be mapped into the (limited)
>> virtual address space a pv guest starts with, we specifically got
>>
>> /*
>>   * Whether or not the guest can deal with being passed an initrd not
>>   * mapped through its initial page tables.
>>   */
>> #define XEN_ELFNOTE_MOD_START_PFN 16
>>
>> to deal with that situation. The hypervisor side for Dom0 is in place,
>> and the kernel side works in our (classic) kernels. Whether it got
>> implemented for DomU meanwhile I don't know; I'm pretty certain
>> pv-ops kernels don't support it so far.
>
> Correct - Not implemented. Here is what I had mentioned in the past:
> (see http://lists.xen.org/archives/html/xen-devel/2014-03/msg00580.html)
>
>
> XEN_ELFNOTE_INIT_P2M, XEN_ELFNOTE_MOD_START_PFN - I had been looking
>      at that but I can't figure out a nice way of implementing this
>      without the usage of SPARSEMAP_VMAP virtual addresses - which is how
>      the classic Xen does it. But then - I don't know who is using huge PV
>      guests - as the PVHVM does a fine job? But then with PVH, now you can
>      boot with large amount of memory (1TB?) - so some of these issues
>      would go away? Except the 'large ramdisk' as that would eat in the
>      MODULES_VADDR I think? Needs more thinking.
>
> .. and then I left it and to my suprise saw on Luis's slides that
> Jurgen is going to take a look at that (500GB support).

I have a patch which should do the job. It is based on the classic
kernel patch Jan mentioned above. The system is coming up with it, I
haven't tested it with a huge initrd up to now. My plan was to post the
patch together with the rest of the >500GB support, but I can send it
on it's own if required.

Juergen

