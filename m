Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943Ab3EMGRZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 02:17:25 -0400
Received: from mail-vb0-f50.google.com ([209.85.212.50]:54037 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147Ab3EMGRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 02:17:21 -0400
MIME-Version: 1.0
Date: Mon, 13 May 2013 14:17:20 +0800
Message-ID: <CAGALBbCEvz5-j6vs=y7AJHZB82HeG+VRbg++yL9xj2gpaW+2Lw@mail.gmail.com>
Subject: why we need a msleep(5) in ehci_bus_suspend/resume
From: linux fddl <fddllinux@gmail.com>
To: stern@rowland.harvard.edu, linux-usb@vger.kernel.org, gregkh@suse.de
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
