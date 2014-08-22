Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932389AbaHVQGm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 12:06:42 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:36552 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932187AbaHVQGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 12:06:40 -0400
Date: Fri, 22 Aug 2014 10:06:26 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Scot Doyle <lkml14@scotdoyle.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tpm_tis: Verify ACPI-specified interrupt
Message-ID: <20140822160626.GA8477@obsidianresearch.com>
References: <alpine.LNX.2.11.1408220043560.1360@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.11.1408220043560.1360@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 12:58:41AM +0000, Scot Doyle wrote:
> Some machines, such as the Acer C720 and Toshiba CB35, have TPMs
> that do not use interrupts while also having an ACPI TPM entry

How do these machines work in Windows?

Why only resume? Shouldn't every TPM command (such as the 3 or 4 the
driver issues at startup) timeout too?

> indicating a specific interrupt to be used. Since this interrupt
> is invalid, these machines freeze on resume until the interrupt
> times out.

> Generate the ACPI-specified interrupt. If none is received, then
> fall back to polling mode.

So, this makes the IRQ detection code run unconditionally, but that
code was only ever really used in certain old non-probable case..

I wonder if it works reliably?

In any event, I think a FIRMWARE_BUG message should be printed if this
case is detected.

I'd be more comfortable with some kind of ACPI black list or patch or
something? What is normal for handling broken ACPI?

Jason
