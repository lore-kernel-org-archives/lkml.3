Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437AbaJKLBM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 07:01:12 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:46000 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbaJKLBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 07:01:11 -0400
MIME-Version: 1.0
In-Reply-To: <20141010094046.GH26795@lee--X1>
References: <20141010094046.GH26795@lee--X1>
Date: Sat, 11 Oct 2014 07:01:09 -0400
X-Google-Sender-Auth: pgudXfrghg3p4BoA6UJtC_khwgY
Message-ID: <CA+55aFyH-E4BTk0EVLnyVDqxtTNxAMM8fnzeo5=sfFaEp8RYhw@mail.gmail.com>
Subject: Re: [GIT PULL] MFD for v3.18
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2014 at 5:40 AM, Lee Jones <lee.jones@linaro.org> wrote:
>  The following changes since commit 52addcf9d6669fa439387610bc65c92fa0980cef:
>
>   Linux 3.17-rc2 (2014-08-25 15:36:20 -0700)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/lee/mfd.git tags/mfd-for-linus-3.18

This causes Kconfig problems for me when doing "make allmodconfig":

  fs/sysfs/Kconfig:1: symbol SYSFS is selected by CHARGER_MAX14577
  drivers/power/Kconfig:327: symbol CHARGER_MAX14577 depends on POWER_SUPPLY
  drivers/power/Kconfig:1: symbol POWER_SUPPLY is selected by HID_SONY
  drivers/hid/Kconfig:649: symbol HID_SONY depends on NEW_LEDS
  drivers/leds/Kconfig:8: symbol NEW_LEDS is selected by SENSORS_APPLESMC
  drivers/hwmon/Kconfig:299: symbol SENSORS_APPLESMC depends on HWMON
  drivers/hwmon/Kconfig:5: symbol HWMON is selected by EEEPC_LAPTOP
  drivers/platform/x86/Kconfig:496: symbol EEEPC_LAPTOP depends on HOTPLUG_PCI
  drivers/pci/hotplug/Kconfig:5: symbol HOTPLUG_PCI depends on SYSFS

and the reason seems to be your changes to drivers/power/Kconfig for
the CHARGER_MAX14577 symbol.

So I pulled and then unpulled.  I realize you're not the only guilty
party in this chain, but your pull is the final drop, so.. I would
suggest making that MAX14577 charger interface _depend_ on SYSFS, not
try to select it.

                     Linus
