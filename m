Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995AbbAMRKd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 12:10:33 -0500
Received: from mga09.intel.com ([134.134.136.24]:61844 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253AbbAMRKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 12:10:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="511644709"
Message-ID: <1421169028.6941.0.camel@linux.intel.com>
Subject: Re: [PATCH] pcmcia: add missing include for new pci resource handler
From: Alan Cox <alan@linux.intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Date: Tue, 13 Jan 2015 17:10:28 +0000
In-Reply-To: <5425521.E2szj8uYq0@wuerfel>
References: <5425521.E2szj8uYq0@wuerfel>
Organization: Intel Corporation
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9 (3.12.9-1.fc21) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2015-01-13 at 15:11 +0100, Arnd Bergmann wrote:
> The recently added rsrc_pci.c file calls pci_bus_alloc_resource without
> including the header file that declares it, and that sometimes causes
> a build warning on ARM:
> 
> drivers/pcmcia/rsrc_pci.c: In function 'find_io_region':
> drivers/pcmcia/rsrc_pci.c:40:2: error: implicit declaration of function 'pci_bus_alloc_resource' [-Werror=implicit-function-declaration]
> 
> This adds the missing include statement.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Alan Cox <alan@linux.intel.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Fixes: 02b03846bb2be ("pcmcia: add a new resource manager for non ISA systems"

Acked-by: Alan Cox <alan@linux.intel.com>

I hadn't intended it to be sucked on ARM although I guess it ought to
work there just fine.

Alan


