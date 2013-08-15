Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756959Ab3HONpA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 09:45:00 -0400
Received: from mail.skyhub.de ([78.46.96.112]:35991 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754821Ab3HONo5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 09:44:57 -0400
Date: Thu, 15 Aug 2013 15:44:54 +0200
From: Borislav Petkov <bp@alien8.de>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>, tony.luck@intel.com,
        bhelgaas@google.com, rostedt@goodmis.org, rjw@sisk.pl,
        lance.ortiz@hp.com, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mce: acpi/apei: trace: Enable ghes memory error
 trace event
Message-ID: <20130815134454.GF27616@pd.tnic>
References: <5208D80D.5030206@linux.vnet.ibm.com>
 <20130812125343.GE18018@pd.tnic>
 <520A16BD.30201@linux.vnet.ibm.com>
 <20130813124258.GC4077@pd.tnic>
 <520A6D98.9060204@linux.vnet.ibm.com>
 <20130813175809.GE4077@pd.tnic>
 <520B6282.6030906@linux.vnet.ibm.com>
 <20130814212211.544ee6a4@concha.lan>
 <20130815093831.GA27616@pd.tnic>
 <20130815102607.7168a930@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130815102607.7168a930@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 15, 2013 at 10:26:07AM -0300, Mauro Carvalho Chehab wrote:
> I mean that the edac core needs to know that, on a given system, the
> BIOS is accessing the hardware registers and sending the data via
> ghes_edac.

Right, that's the firmware-first thing which Naveen did - see
mce_disable_bank.

> No. As we want that fatal errors to also be properly reported, the
> kernel will still need to know the memory layout.

Read what I said: if you have the silkscreen label you don't need the
memory layout - you *already* *know* which DIMM is affected.

Also, fatal errors are a whole different beast where we run in NMI
context or we even don't get to run the #MC handler on some systems.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
