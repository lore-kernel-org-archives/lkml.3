Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990Ab3CSK2B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 06:28:01 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:34185 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab3CSK2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 06:28:00 -0400
Message-ID: <51483DAA.7060806@openvz.org>
Date: Tue, 19 Mar 2013 14:27:54 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130119 Firefox/10.0.11esrpre Iceape/2.7.12
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: Borislav Petkov <bp@alien8.de>, jeffrey.t.kirsher@intel.com,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Bjorn Helgaas <bhelgaas@google.com>,
        x86@kernel.org, lkml <linux-kernel@vger.kernel.org>,
        e1000-devel@lists.sourceforge.net,
        Bruce Allan <bruce.w.allan@intel.com>
Subject: Re: e1000e + suspend, 3.9-rc2
References: <20130311191936.GD5000@pd.tnic> <513E355C.4000204@gmail.com> <20130311202537.GF5000@pd.tnic> <20130312171745.GE5370@pd.tnic> <51483B1A.9090704@suse.cz>
In-Reply-To: <51483B1A.9090704@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> On 03/12/2013 06:17 PM, Borislav Petkov wrote:
>> On Mon, Mar 11, 2013 at 09:25:37PM +0100, Borislav Petkov wrote:
>>> Yeah, it is already upstream. And yeah, it did trigger with it.
>>>
>>> $ git describe
>>> v3.9-rc2-112-g7c6baa304b84
>>>
>>> But it somehow doesn't trigger with that same kernel anymore so I'll
>>> consider it a glitch and watch it over the next days.
>>
>> Ok, I can still see the hardware error message when suspending:
>
> And with 3.8 plus these:
>      PCI/PM: Clear state_saved during suspend
>      e1000e: fix pci-device enable-counter balance
>      e1000e: fix runtime power management transitions
>      e1000e: fix accessing to suspended device
>
> I sometimes see this:
> pci_pm_suspend():e1000_suspend +0x0/0x10 [e1000e] returns -2
> dpm_run_callback(): pci_pm_suspend+0x0/0x140 returns -2
> PM: Device 0000:00:19.0 failed to suspend async: error -2
>
> Any ideas? Am I missing some patch still?

Try this:
"PCI: Don't try to disable Bus Master on disconnected PCI devices"
https://patchwork.kernel.org/patch/2271641/

But I'm not sure, probably it is unrelated because this code works only (?)
during shutdown/kexec sequences.


