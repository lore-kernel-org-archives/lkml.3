Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934483AbaE2J0w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 05:26:52 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:56818 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932814AbaE2J0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 05:26:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: josh@joshtriplett.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH] drivers/char/mem.c: Add /dev/ioports, supporting 16-bit and 32-bit ports
Date: Thu, 29 May 2014 11:26:44 +0200
Message-ID: <16228376.RHijyT1ZPk@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53865820.7010309@zytor.com>
References: <20140509191914.GA7286@jtriplet-mobl1> <63645237.lSKEVJUKkQ@wuerfel> <53865820.7010309@zytor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:HkeJgauObBNDlU17qNp36+ZwWaiRGp15SmiJTyGBLpy
 qRueM6jPD5K/KCoec0Tb9S145gvQYiboRDNwKG+2pPDVjgNS29
 dXt35WP4OZf+FReD3XJqwWAGl/Mg0UyM1xsoc+IDROpGA7YvMF
 vRBsO0o8/PIZaoLdwAk2AFDiHS3fazAeNNqb5IZElFDvfIU9qX
 XCaq2vasULJ3ahTo8XZuo5iwNvxVSNpvBi4mZmUplurxEKYl9B
 KDkcbJMjaHjOkCOTfodfHKDLUqMGo7bS+V6eBKdzoEDphhZmS8
 MPEyXSm8XnbcDAcJb3bVypKn/9rj0O8p41cj1fqbMW8o8dYgXF
 PpyHwm3591gPcgxjzbdA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 May 2014 14:41:52 H. Peter Anvin wrote:
> On 05/19/2014 05:36 AM, Arnd Bergmann wrote:
> > 
> > My feeling is that all devices we can think of fall into at least one
> > of these categories:
> > 
> > * legacy PC stuff that needs only byte access
> > * PCI devices that can be accessed through sysfs
> > * devices on x86 that can be accessed using iopl
> > 
> 
> I don't believe PCI I/O space devices can be accessed through sysfs, but
> perhaps I'm wrong?  (mmapping I/O space is not portable.)

The interface is there, both a read/write and mmap on the resource
bin_attribute. But it seems you're right, neither of them is implemented
on all architectures.

Only powerpc, microblaze, alpha, sparc and xtensa allow users to mmap
I/O space, even though a lot of others could. The read-write interface
is only defined for alpha, ia64, microblaze and powerpc.

	Arnd
