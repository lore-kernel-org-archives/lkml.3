Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751540AbaJIRVf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 13:21:35 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:64830 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135AbaJIRV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 13:21:26 -0400
Date: Thu, 9 Oct 2014 10:21:20 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Hauke Mehrtens <hauke@hauke-m.de>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] bcma: Add dependency on OF_ADDRESS
Message-ID: <20141009172120.GB2410@roeck-us.net>
References: <1412872877-1771-1-git-send-email-linux@roeck-us.net>
 <CACna6rzOeGcKrrftLx_3uWe_bAXQaQMmWb3wWHP0CjtdO8D0eg@mail.gmail.com>
 <5436C2B4.6030801@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5436C2B4.6030801@broadcom.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2014 at 07:15:32PM +0200, Arend van Spriel wrote:
> On 10/09/14 18:54, Rafał Miłecki wrote:
> >On 9 October 2014 18:41, Guenter Roeck<linux@roeck-us.net>  wrote:
> >>Commit 2101e533f41a ("bcma: register bcma as device tree driver")
> >>introduces a hard dependency on OF_ADDRESS into the bcma driver.
> >>OF_ADDRESS is specifically disabled for the sparc architecture.
> >>This results in the following error when building sparc64:allmodconfig.
> 
> Does this mean on sparc (using allmodconfig) you will get CONFIG_OF
> and !CONFIG_OF_ADDRESS? Does that makes sense?
> 

You tell me. From drivers/of/Kconfig:

config OF_ADDRESS
        def_bool y
	depends on !SPARC
	select OF_ADDRESS_PCI if PCI

Presumably there is a reason to disable OF_ADDRESS for sparc.

> btw. the OF_ADDRESS dependency was introduced by commit "bcma: get
> IRQ numbers from dt".
> 
Ah, sorry. Ok, I'll send v3 after taking a break (and waiting
for additional comments).

Guenter
