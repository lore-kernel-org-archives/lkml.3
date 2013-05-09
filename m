Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015Ab3EIIKB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 04:10:01 -0400
Received: from gate.crashing.org ([63.228.1.57]:57289 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751194Ab3EIIJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 04:09:56 -0400
Message-ID: <1368086982.25488.165.camel@pasglop>
Subject: Masked MSIs expectations
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linux-pci@vger.kernel.org
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>
Date: Thu, 09 May 2013 18:09:42 +1000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks !

Do we provide drivers any guarantee to what happen if an MSI is shot
while masked with disable_irq() or while not yet request_irq()'ed ?

Do we guarantee delivery (latched while masked), non-delivery, or
undefined ?

I'm bringing up a piece of HW where if it happened, it won't be
automatically sent to the CPU and can block further MSIs unless I
explicitly either ditch it or force a resend when unmasking (at the PCI
Express controller PIC level).

I'm tempted to just ditch anything that happened while masked, it would
make everything easier on my side, but maybe drivers have different
expectations (and of course an LSI would still shoot, that's not an
issue, only MSIs are in question here).

I have cases of devices continuing to shoot one or two MSIs after kexec
and before the new kernel takes over, causing a "loss" of any subsequent
one unless I deal with that case one way or another.

Cheers,
Ben.



