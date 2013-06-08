Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648Ab3FHTjj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 15:39:39 -0400
Received: from mail-vb0-f52.google.com ([209.85.212.52]:56278 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481Ab3FHTji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 15:39:38 -0400
MIME-Version: 1.0
X-Originating-IP: [84.115.78.137]
Date: Sat, 8 Jun 2013 21:39:37 +0200
Message-ID: <CALG0vJu9-640D=Q-2RoSOnWtR=sERwj0fSCibK+ijprcf-T6Ag@mail.gmail.com>
Subject: Re: [BUG] PCI related panic on powerpc based board with 3.10-rcX
From: Michael Guntsche <michael.guntsche@it-loops.com>
To: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org, Rojhalat Ibrahim <imr@rtschenk.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After bisecting I found the responsible commit.

50d8f87d2b3: powerpc/fsl-pci Make PCIe hotplug work with Freescale
PCIe controllers

Reverting this commit allowed my board to boot again.

@Rojhalat: Please have a look at
http://marc.info/?l=linux-kernel&m=137071294204858&w=2
for my initial bugreport.

What I do not understand at all is why this is affecting my platform.
AFAIK there is no PCIe hardware on it AND I completely disabled PCIe
support in config.

Kind regards,
Mike
