Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278AbaH2Ilj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 04:41:39 -0400
Received: from ozlabs.org ([103.22.144.67]:41191 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752288AbaH2Ile (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 04:41:34 -0400
Message-ID: <1409301692.30345.1.camel@concordia>
Subject: Re: [PATCH 1/2] PCI/MSI/PPC: Remove arch_msi_check_device()
From: Michael Ellerman <mpe@ellerman.id.au>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-pci@vger.kernel.org
Date: Fri, 29 Aug 2014 18:41:32 +1000
In-Reply-To: <18276ae8c0b212b8d40dfd186e1c84b8ae949525.1405160163.git.agordeev@redhat.com>
References: <cover.1405160163.git.agordeev@redhat.com>
	 <18276ae8c0b212b8d40dfd186e1c84b8ae949525.1405160163.git.agordeev@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-07-12 at 13:21 +0200, Alexander Gordeev wrote:
> PowerPC is the only architecture that makes use of hook
> arch_msi_check_device() and does perform some checks to
> figure out if MSI/MSI-X could be enabled for a device.
> However, there are no reasons why those checks could not
> be done within arch_setup_msi_irqs() hook.
> 
> Moving MSI checks into arch_setup_msi_irqs() makes code
> more readable and allows getting rid of unnecessary hook
> arch_msi_check_device().

The intention was that this hook allowed a platform to reject the request
early, ie. before all the setup had been done. But if no one except us is using
it then fine, get rid of it.

Acked-by: Michael Ellerman <mpe@ellerman.id.au>

cheers



