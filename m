Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417Ab3EQDmc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 23:42:32 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:65007 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754360Ab3EQDm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 23:42:29 -0400
Date: Thu, 16 May 2013 17:45:11 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Yuan-Hsin Chen <yuanlmm@gmail.com>
Cc: stern@rowland.harvard.edu, sarah.a.sharp@linux.intel.com, balbi@ti.com,
        Julia.Lawall@lip6.fr, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yuan-Hsin Chen <yhchen@faraday-tech.com>
Subject: Re: [PATCH v4] usb host: Faraday USB2.0 FUSBH200-HCD driver
Message-ID: <20130517004511.GA10492@kroah.com>
References: <1360149841-2392-1-git-send-email-yuanlmm@gmail.com>
 <1366969040-28892-1-git-send-email-yhchen@faraday-tech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1366969040-28892-1-git-send-email-yhchen@faraday-tech.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 26, 2013 at 09:37:20AM +0000, Yuan-Hsin Chen wrote:
> FUSBH200-HCD is an USB2.0 hcd for Faraday FUSBH200.
> FUSBH200 is an ehci-like controller with some differences.
> First, register layout of FUSBH200 is incompatible with EHCI.
> Furthermore, FUSBH200 is lack of siTDs which means iTDs
> are used for both HS and FS ISO transfer.
> 
> Signed-off-by: Yuan-Hsin Chen <yhchen@faraday-tech.com>

This patch breaks the build on my machine, so I can't accept it:
  CC [M]  drivers/usb/host/fusbh200-hcd.o
drivers/usb/host/fusbh200-hcd.c: In function ‘dbg_hcc_params’:
drivers/usb/host/fusbh200-hcd.c:149:2: error: implicit declaration of function ‘HCC_HW_PREFETCH’ [-Werror=implicit-function-declaration]
drivers/usb/host/fusbh200-hcd.c:149:2: error: implicit declaration of function ‘HCC_32FRAME_PERIODIC_LIST’ [-Werror=implicit-function-declaration]
drivers/usb/host/fusbh200-hcd.c:149:2: warning: format ‘%d’ expects argument of type ‘int’, but argument 6 has type ‘char *’ [-Wformat]
drivers/usb/host/fusbh200-hcd.c: At top level:
drivers/usb/host/fusbh200-hcd.c:906:12: warning: ‘debug_lpm_close’ defined but not used [-Wunused-function]
cc1: some warnings being treated as errors

Please be more careful.  Can you fix this up and resend it?

thanks,

greg k-h
