Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005Ab3JWS11 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 14:27:27 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:39685 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412Ab3JWS10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 14:27:26 -0400
MIME-Version: 1.0
In-Reply-To: <1374740897-20304-2-git-send-email-haver@vnet.ibm.com>
References: <1374740897-20304-1-git-send-email-haver@vnet.ibm.com> <1374740897-20304-2-git-send-email-haver@vnet.ibm.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 23 Oct 2013 12:27:05 -0600
Message-ID: <CAErSpo7e0i=5Yi90rtwfR7MrOpUR3BVkb_neWfdtXJ4=rRyZ8w@mail.gmail.com>
Subject: Re: [PATCH] Generic WorkQueue Engine (GenWQE) device driver
To: Frank Haverkamp <haver@vnet.ibm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        cody@linux.vnet.ibm.com, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        utz.bacher@de.ibm.com, jsvogt@de.ibm.com, MIJUNG@de.ibm.com,
        Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>,
        michael@ibmra.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 2:28 AM, Frank Haverkamp <haver@vnet.ibm.com> wrote:
> The GenWQE card provides access to a generic work queue into which the
> work can be put, which should be executed, e.g. compression or
> decompression request, or whatever the card was configured to do.
>
> Each request comes with a set of input data (ASV) and will produce some
> output data (ASIV). The request will also contain a sequence number,
> some timestamps and a command code/subcode plus some fields for hardware-/
> software-interaction.
>
> A request can contain references to blocks of memory. Since the card
> requires DMA-addresses of that memory, the driver provides two ways to
> solve that task:
>   1) The drivers mmap() will allocate some DMAable memory for the user.
>      The driver has a lookup table such that the virtual userspace
>      address can properly be replaced and checked.
>   2) The user allocates memory and the driver will pin/unpin that
>      memory and setup a scatter gatherlist with matching DMA addresses.
>
> Currently work requests are synchronous.
>
> The genwqe driver has a user-space interface described in
> linux/include/genwqe/genwqe_card.h. There are several ioctls which can
> be used to talk to the driver. In addition there are some sysfs
> entries where information can be exchanged with user-space.
>
> Known Restrictions:
>
>  o On my PowerPC testsystem SRIOV did not work.

Does this restriction still apply?  Is there some PCI core issue here?
 We did fix an SR-IOV issue that was reported on PowerPC with
aa914f5ec25, so maybe that's related.  But if there's still a PCI core
issue here, let me know.

Bjorn
