Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161245Ab3BOIyS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 03:54:18 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:54352 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161225Ab3BOIyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 03:54:17 -0500
Message-ID: <511DF7B4.8060504@openvz.org>
Date: Fri, 15 Feb 2013 12:54:12 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130119 Firefox/10.0.11esrpre Iceape/2.7.12
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Jiri Slaby <jslaby@suse.cz>,
        x86@kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: Uhhuh. NMI received for unknown reason 2c on CPU 0.
References: <20130129202848.GE25415@pd.tnic> <3066730.6MVSAfNyye@vostro.rjw.lan> <20130131131034.GF4926@pd.tnic> <2293454.v8QRHr8txR@vostro.rjw.lan> <20130203144656.GB5844@pd.tnic> <20130214143905.GC5700@pd.tnic> <CAErSpo6Mi31O1YA5PKnRjQMinB284Ag6PY8LuZpD0NwuZ6QZuw@mail.gmail.com> <20130214191234.GH5700@pd.tnic>
In-Reply-To: <20130214191234.GH5700@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov wrote:
> On Thu, Feb 14, 2013 at 10:17:46AM -0700, Bjorn Helgaas wrote:
>> On Thu, Feb 14, 2013 at 7:39 AM, Borislav Petkov<bp@suse.de>  wrote:
>>> On Sun, Feb 03, 2013 at 03:46:56PM +0100, Borislav Petkov wrote:
>>>> On Sun, Feb 03, 2013 at 12:04:46AM +0100, Rafael J. Wysocki wrote:
>>>>> The [2/5] is at: https://patchwork.kernel.org/patch/2001211/
>>>>>
>>>>> The other two are attached.  I suppose the ordering doesn't matter.
>>>>
>>>> Ok, the eth link cable hotplugging issue seems fixed, plugging and
>>>> unplugging the cable works as expected.
>>>
>>> Q: what happened to those, are they going upstream for 3.9 or are you
>>> sending them now for 3.8?
>>>
>>> They fix at least the cable hotplugging issue so at least one thing is
>>> covered.
>>
>> I haven't done anything with the e1000e patches; I assume the e1000e
>> maintainers will take care of those.
>>
>> I merged the following patches for v3.9:
>>
>>      * pci/konstantin-runtime-pm:
>>        PCI/PM: Clear state_saved during suspend
>>        PCI: Use atomic_inc_return() rather than atomic_add_return()
>>        PCI: Catch attempts to disable already-disabled devices
>>        PCI: Disable Bus Master unconditionally in pci_device_shutdown()
>>
>> You can see the actual patches I merged at:
>> http://git.kernel.org/?p=linux/kernel/git/helgaas/pci.git;a=shortlog;h=refs/heads/next
>>
>> It's pretty late for v3.8, but let me know if you think they're critical.
>
> Ok, I meant those:
>
> http://marc.info/?l=linux-kernel&m=135984592927219
>
> They fix the link detection issue on my x230. So let's see. The first one is:
>
> * https://patchwork.kernel.org/patch/2001211/ (e1000e: fix pci device enable
> counter balance)

please use this instead:

[PATCH v2 1/7] e1000e: fix pci-device enable-counter balance
https://lkml.org/lkml/2013/2/4/190

from v2 patchset: https://lkml.org/lkml/2013/2/4/185

>
> Rafael said this one is a real bugfix. Looks like e1000e maintainers are
> picking that one?
>
> * pci-pm-fix-e1000e-runtime-suspend.patch
>
> I don't see that one in your tree.
>
> * pci-pm-clear-state_saved-during-suspend.patch
>
> I can see this one in your tree: http://git.kernel.org/?p=linux/kernel/git/helgaas/pci.git;a=commitdiff;h=82fee4d67ab86d6fe5eb0f9a9e988ca9d654d765
>
> With the imminence of the 3.8 release, we probably want to wait for
> after the merge window and retest again, then apply and packport stuff,
> if needed.
>
> And the NMI issue is still unfixed so this needs more work, AFAICT. Oh
> well, after the merge window.
>

