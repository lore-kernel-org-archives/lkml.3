Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382Ab3A2VdU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 16:33:20 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:50476 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab3A2VdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 16:33:17 -0500
MIME-Version: 1.0
In-Reply-To: <20130129202848.GE25415@pd.tnic>
References: <20130129202848.GE25415@pd.tnic>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 29 Jan 2013 14:32:56 -0700
Message-ID: <CAErSpo4v473sXvmv3gqkftkiFZtz+gYgd1yzWae=nLJjwJPBug@mail.gmail.com>
Subject: Re: Uhhuh. NMI received for unknown reason 2c on CPU 0.
To: Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2013 at 1:28 PM, Borislav Petkov <bp@alien8.de> wrote:
> Hi,
>
> this is rc5 + tip/master from 2 days ago, when resuming I get this fun
> message:
>
> ...
> [15117.684975] Restarting tasks ... done.
> [15117.687201] video LNXVIDEO:00: Restoring backlight state
> [15117.720469] ehci-pci 0000:00:1d.0: power state changed by ACPI to D3cold
> [15117.721414] ehci-pci 0000:00:1a.0: power state changed by ACPI to D3cold
> [15117.949185] [drm] Enabling RC6 states: RC6 on, RC6p on, RC6pp off
> [15118.617192] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: Rx/Tx
> [15118.617198] e1000e 0000:00:19.0 eth0: 10/100 speed: disabling TSO
> [15123.971346] Uhhuh. NMI received for unknown reason 2c on CPU 0.
> [15123.971353] Do you have a strange power saving mode enabled?
> [15123.971356] Dazed and confused, but trying to continue
>
> Machine is thinkpad x230. Any and all sensible suggestions are welcome.

Konstantin has some fixes for an e1000e power management issue related
to suspend/resume that he observed on an x220.  He didn't see an NMI,
and apparently his problem has been around for a long time, so no idea
whether it could be related.  I just noticed the conjunction of
thinkpad/e1000e/resume/power saving in both reports.

https://lkml.org/lkml/2013/1/18/147
