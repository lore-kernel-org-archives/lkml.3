Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336Ab3CSMWU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 08:22:20 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:36034 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060Ab3CSMWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 08:22:19 -0400
Message-ID: <5148589E.8030509@suse.cz>
Date: Tue, 19 Mar 2013 13:22:54 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
CC: Borislav Petkov <bp@alien8.de>, jeffrey.t.kirsher@intel.com,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Bjorn Helgaas <bhelgaas@google.com>,
        x86@kernel.org, lkml <linux-kernel@vger.kernel.org>,
        e1000-devel@lists.sourceforge.net,
        Bruce Allan <bruce.w.allan@intel.com>
Subject: Re: e1000e + suspend, 3.9-rc2
References: <20130311191936.GD5000@pd.tnic> <513E355C.4000204@gmail.com> <20130311202537.GF5000@pd.tnic> <20130312171745.GE5370@pd.tnic> <51483B1A.9090704@suse.cz> <51483DAA.7060806@openvz.org>
In-Reply-To: <51483DAA.7060806@openvz.org>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2013 11:27 AM, Konstantin Khlebnikov wrote:
> Jiri Slaby wrote:
>> On 03/12/2013 06:17 PM, Borislav Petkov wrote:
>>> On Mon, Mar 11, 2013 at 09:25:37PM +0100, Borislav Petkov wrote:
>>>> Yeah, it is already upstream. And yeah, it did trigger with it.
>>>>
>>>> $ git describe
>>>> v3.9-rc2-112-g7c6baa304b84
>>>>
>>>> But it somehow doesn't trigger with that same kernel anymore so I'll
>>>> consider it a glitch and watch it over the next days.
>>>
>>> Ok, I can still see the hardware error message when suspending:
>>
>> And with 3.8 plus these:
>>      PCI/PM: Clear state_saved during suspend
>>      e1000e: fix pci-device enable-counter balance
>>      e1000e: fix runtime power management transitions
>>      e1000e: fix accessing to suspended device
>>
>> I sometimes see this:
>> pci_pm_suspend():e1000_suspend +0x0/0x10 [e1000e] returns -2
>> dpm_run_callback(): pci_pm_suspend+0x0/0x140 returns -2
>> PM: Device 0000:00:19.0 failed to suspend async: error -2
>>
>> Any ideas? Am I missing some patch still?
> 
> Try this:
> "PCI: Don't try to disable Bus Master on disconnected PCI devices"
> https://patchwork.kernel.org/patch/2271641/
> 
> But I'm not sure, probably it is unrelated because this code works only (?)
> during shutdown/kexec sequences.

I don't think it will help either. -2 here is -E1000_ERR_PHY from
e1000e_write_phy_reg_mdic if I'm looking correctly. I.e. MDIC not ready
or unlike MDIC_ERROR.

I think this happened after I put the link down and tried to suspend.

-- 
js
suse labs
