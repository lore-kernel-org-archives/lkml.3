Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560Ab3LRXtB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 18:49:01 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:52517 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335Ab3LRXs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 18:48:59 -0500
Date: Wed, 18 Dec 2013 15:48:57 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.12 000/118] 3.12.6-stable review
Message-ID: <20131218234857.GA23500@roeck-us.net>
References: <20131218211219.461663463@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131218211219.461663463@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 01:10:37PM -0800, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.12.6 release.
> There are 118 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri Dec 20 21:12:03 UTC 2013.
> Anything received after that time might be too late.
> 

Hi greg,

I see a couple of failed builds.

m68k:allmodconfig ... failed
mips:allmodconfig ... failed
sparc64:allmodconfig ... failed
x86_64:allyesconfig ... failed
x86_64:allmodconfig ... failed

Build is still going on, so there may be more.

Error log:

drivers/staging/comedi/drivers/ssv_dnp.c: In function 'dnp_dio_insn_bits':
drivers/staging/comedi/drivers/ssv_dnp.c:63:2: error: implicit declaration of function 'comedi_dio_update_state' [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors
make[4]: *** [drivers/staging/comedi/drivers/ssv_dnp.o] Error 1

Function comedi_dio_update_state() is not defined anywhere in 3.12,
so patches
	 staging: comedi: ssv_dnp: use comedi_dio_update_state()
	 staging: comedi: drivers: use comedi_dio_update_state() for simple cases

won't apply without additional changes.

Guenter
