Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570AbaK2AbR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 19:31:17 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:61939 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751366AbaK2AbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 19:31:15 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linux PM list <linux-pm@vger.kernel.org>
Cc: Linux PCI <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Bjorn Helgaas <bhelgaas@google.com>, Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [Replacement][PATCH 1/4] PM: Merge the SET*_RUNTIME_PM_OPS() macros
Date: Sat, 29 Nov 2014 01:52:32 +0100
Message-ID: <1551552.1uQKV96bxc@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1740704.VN27cDdEAu@vostro.rjw.lan>
References: <37310416.jZXoh5nfSC@vostro.rjw.lan> <3484329.phAPviVnbd@vostro.rjw.lan> <1740704.VN27cDdEAu@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 27, 2014 11:05:41 PM Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> The SET_PM_RUNTIME_PM_OPS() and SET_RUNTIME_PM_OPS() macros are
> identical except that one of them is not empty for CONFIG_PM set,
> while the other one is not empty for CONFIG_PM_RUNTIME set,
> respectively.
> 
> However, after commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if
> PM_SLEEP is selected) PM_RUNTIME is always set if PM is set, so one
> of these macros is now redundant.
> 
> For this reason, replace SET_PM_RUNTIME_PM_OPS() with
> SET_RUNTIME_PM_OPS() everywhere and redefine the SET_PM_RUNTIME_PM_OPS
> symbol as SET_RUNTIME_PM_OPS in case new code is starting to use the
> macro being removed here.

It turns out that I need to defer this one, because it breaks builds for
CONFIG_PM selected without CONFIG_PM_SLEEP or CONFIG_PM_RUNTIME (which is
arguably invalid, but some defconfigs evidently do that).

I need to fix those defconfigs first.


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
