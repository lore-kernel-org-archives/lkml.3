Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250AbaHLR2I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 13:28:08 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:34168 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbaHLR2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 13:28:06 -0400
MIME-Version: 1.0
In-Reply-To: <53E4E042.1070300@canonical.com>
References: <53E4B281.5050302@canonical.com>
	<53E4C5D5.2090103@citrix.com>
	<53E4E042.1070300@canonical.com>
Date: Tue, 12 Aug 2014 10:28:05 -0700
X-Google-Sender-Auth: 9QjQ2mVFHt-eRR4r9cKzZ2OEu0s
Message-ID: <CAGXu5jJ+FTqgYpLH5x0VBm9QMND-b0Sze6q6pc=tRe2oFMu5uA@mail.gmail.com>
Subject: Re: [Xen-devel] Xen PV domain regression with KASLR enabled (kernel 3.16)
From: Kees Cook <keescook@chromium.org>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: David Vrabel <david.vrabel@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 8, 2014 at 7:35 AM, Stefan Bader <stefan.bader@canonical.com> wrote:
> On 08.08.2014 14:43, David Vrabel wrote:
>> On 08/08/14 12:20, Stefan Bader wrote:
>>> Unfortunately I have not yet figured out why this happens, but can confirm by
>>> compiling with or without CONFIG_RANDOMIZE_BASE being set that without KASLR all
>>> is ok, but with it enabled there are issues (actually a dom0 does not even boot
>>> as a follow up error).
>>>
>>> Details can be seen in [1] but basically this is always some portion of a
>>> vmalloc allocation failing after hitting a freshly allocated PTE space not being
>>> PTE_NONE (usually from a module load triggered by systemd-udevd). In the
>>> non-dom0 case this repeats many times but ends in a guest that allows login. In
>>> the dom0 case there is a more fatal error at some point causing a crash.
>>>
>>> I have not tried this for a normal PV guest but for dom0 it also does not help
>>> to add "nokaslr" to the kernel command-line.
>>
>> Maybe it's overlapping with regions of the virtual address space
>> reserved for Xen?  What the the VA that fails?
>>
>> David
>>
> Yeah, there is some code to avoid some regions of memory (like initrd). Maybe
> missing p2m tables? I probably need to add debugging to find the failing VA (iow
> not sure whether it might be somewhere in the stacktraces in the report).
>
> The kernel-command line does not seem to be looked at. It should put something
> into dmesg and that never shows up. Also today's random feature is other PV
> guests crashing after a bit somewhere in the check_for_corruption area...

Right now, the kaslr code just deals with initrd, cmdline, etc. If
there are other reserved regions that aren't listed in the e820, it'll
need to locate and skip them.

-Kees

-- 
Kees Cook
Chrome OS Security
