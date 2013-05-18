Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174Ab3ERFfq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 May 2013 01:35:46 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:57231 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752Ab3ERFfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 May 2013 01:35:44 -0400
Message-ID: <5197132A.5030308@openvz.org>
Date: Sat, 18 May 2013 09:35:38 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130119 Firefox/10.0.11esrpre Iceape/2.7.12
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Bruce Allan <bruce.w.allan@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Borislav Petkov <bp@suse.de>, Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: Re: [ 094/136 ] e1000e: fix runtime power management transitions
References: <20130518021557.139113314@goodmis.org> <20130518021656.829696669@goodmis.org>
In-Reply-To: <20130518021656.829696669@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> 3.6.11.4 stable review patch.
> If anyone has any objections, please let me know.

I don't think that 3.6.y needs this. That was fix for problem which appeared
in 3.8 after some changes in PCI power management code. Probably it depends
on these changes. If no one complains about problems we should leave it as is.

>
> ------------------
>
> From: Konstantin Khlebnikov<khlebnikov@openvz.org>
>
> [ Upstream commit 66148babe728f3e00e13c56f6b0ecf325abd80da ]
>
> This patch removes redundant actions from driver and fixes its interaction
> with actions in pci-bus runtime power management code.
>
> It removes pci_save_state() from __e1000_shutdown() for normal adapters,
> PCI bus callbacks pci_pm_*() will do all this for us. Now __e1000_shutdown()
> switches to D3-state only quad-port adapters, because they needs quirk for
> clearing false-positive error from downsteam pci-e port.
>
> pci_save_state() now called after clearing bus-master bit, thus __e1000_resume()
> and e1000_io_slot_reset() must set it back after restoring configuration space.
>
> This patch set get_link_status before calling pm_runtime_put() in e1000_open()
> to allow e1000_idle() get real link status and schedule first runtime suspend.
>
> This patch also enables wakeup for device if management mode is enabled
> (like for WoL) as result pci_prepare_to_sleep() would setup wakeup without
> special actions like custom 'enable_wakeup' sign.
>
> Cc: Bruce Allan<bruce.w.allan@intel.com>
> Signed-off-by: Konstantin Khlebnikov<khlebnikov@openvz.org>
> Acked-by: Rafael J. Wysocki<rafael.j.wysocki@intel.com>
> Tested-by: Borislav Petkov<bp@suse.de>
> Tested-by: Aaron Brown<aaron.f.brown@intel.com>
> Signed-off-by: Jeff Kirsher<jeffrey.t.kirsher@intel.com>
> Signed-off-by: Steven Rostedt<rostedt@goodmis.org>

