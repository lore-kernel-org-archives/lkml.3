Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287Ab3AVWuA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 17:50:00 -0500
Received: from mail1.bemta8.messagelabs.com ([216.82.243.50]:28322 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752888Ab3AVWt6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 17:49:58 -0500
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-5.tower-131.messagelabs.com!1358894994!22185746!2
X-Originating-IP: [216.166.12.97]
X-StarScan-Received: 
X-StarScan-Version: 6.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Peter Huewe <peterhuewe@gmx.de>, Ian Abbott <abbotti@mev.co.uk>
CC: Mori Hess <fmhess@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 22 Jan 2013 16:49:53 -0600
Subject: RE: [PATCH] staging/comedi: Use comedi_pci_auto_unconfig directly
 for pci_driver.remove
Thread-Topic: [PATCH] staging/comedi: Use comedi_pci_auto_unconfig directly
 for pci_driver.remove
Thread-Index: Ac348P/ct/oeSCysRVagRa5nArZ60wAAWRfQ
Message-ID: <ADE657CA350FB648AAC2C43247A983F00207A6F697BB@AUSP01VMBX24.collaborationhost.net>
References: <1358894403-26181-1-git-send-email-peterhuewe@gmx.de>
In-Reply-To: <1358894403-26181-1-git-send-email-peterhuewe@gmx.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 22, 2013 3:40 PM, Peter Huewe wrote:
>  (Almost) all comedi pci drivers have some wrapper for their
> pci_driver.remove function which simply calls comedi_pci_auto_unconfig
> which has the same function prototype as the wrapper.
>
> -> we can remove these wrappers and call comedi_pci_auto_unconfig
> directly. This removes a lot some boilerplate code and saves some bytes.
>
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> ---
> Maybe we should move the implementation now to drivers.c,
> because now it cannot be inlined anymore. 
> This would save some more bytes in the .kos but comedi_pci_auto_unconfig
> then has to become an exported symbol.

Did you build this?

As you mention above, the inlined comedi_pci_auto_unconfig() will not
work as a function pointer in the pci_driver structs.

This cannot work until/if comedi_pci_auto_unconfig() is made an exported
symbol. I'll leave that decision up to Ian.

Regards,
Hartley

