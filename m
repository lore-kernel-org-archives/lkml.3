Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374Ab3FTI3U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 04:29:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:19455 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754548Ab3FTI3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 04:29:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,903,1363158000"; 
   d="scan'208";a="356630216"
Date: Thu, 20 Jun 2013 11:29:00 +0300
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: David Daney <ddaney.cavm@gmail.com>
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
        Jamie Iles <jamie@jamieiles.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 2/4] tty/8250_dw: Add support for OCTEON UARTS.
Message-ID: <20130620082900.GB32331@xps8300>
References: <1371677849-23912-1-git-send-email-ddaney.cavm@gmail.com>
 <1371677849-23912-3-git-send-email-ddaney.cavm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371677849-23912-3-git-send-email-ddaney.cavm@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 02:37:27PM -0700, David Daney wrote:
> From: David Daney <david.daney@cavium.com>
> 
> A few differences needed by OCTEON:
> 
> o These are DWC UARTS, but have USR at a different offset.
> 
> o Internal SoC buses require reading back from registers to maintain
>   write ordering.
> 
> o 8250 on OCTEON appears with 64-bit wide registers, so when using
>   readb/writeb in big endian mode we have to adjust the membase to hit
>   the proper part of the register.
> 
> o No UCV register, so we hard code some properties.
> 
> Because OCTEON doesn't have a UCV register, I change where
> dw8250_setup_port(), which reads the UCV, is called by pushing it in
> to the OF and ACPI probe functions, and move unchanged
> dw8250_setup_port() earlier in the file.
> 
> Signed-off-by: David Daney <david.daney@cavium.com>
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>

Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>

-- 
heikki
