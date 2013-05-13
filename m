Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078Ab3EMIXD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 04:23:03 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:53150 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120Ab3EMIXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 04:23:01 -0400
MIME-Version: 1.0
Date: Mon, 13 May 2013 16:23:00 +0800
Message-ID: <CAGALBbBJuVRcG9zcqcTSNHJ4FsyE9DuHhvzRZQdEePEq=GXMFg@mail.gmail.com>
Subject: usb: why we need a msleep(5) in ehci_bus_suspend/resume
From: linux fddl <fddllinux@gmail.com>
To: stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

  From the ehci-hub.c, I find that ehci_bus_suspend/resume have some
code like this:

if (time_before(jiffies, ehci->netx_statechange))
    msleep(5);
...
ehci->next_statechange = jiffies + msec_to_jiffies(10);

and

if (time_before(jiffies, ehci->netx_statechange))
    msleep(5);
...
ehci->next_statechange = jiffies + msec_to_jiffies(5);

but I don't know why such a short sleep is needed, and why one is
[ehci->next_statechange = jiffies + msec_to_jiffies(10)] and the other is
[ehci->next_statechange = jiffies + msec_to_jiffies(5)],
I googled for a long time, but it seems that there is no explanation.

  Anyone knows why and can give any explanation?

  Thanks very much!

Best Regards!
ShiJinghui
