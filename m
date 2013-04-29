Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757941Ab3D2MPW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 08:15:22 -0400
Received: from mxout1.idt.com ([157.165.5.25]:56180 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753731Ab3D2MPV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 08:15:21 -0400
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>, Kumar Gala <galak@kernel.crashing.org>,
        Andre van Herk <andre.van.herk@Prodrive.nl>,
        Micha Nelissen <micha.nelissen@Prodrive.nl>
Subject: RE: [PATCH 1/3] rapidio: make enumeration/discovery configurable
Thread-Topic: [PATCH 1/3] rapidio: make enumeration/discovery configurable
Thread-Index: AQHOQPjCcpzLq65DOUWivk5TNMYZf5jplR6AgAOLuQA=
Date: Mon, 29 Apr 2013 12:08:49 +0000
Message-ID: <8D983423E7EDF846BB3056827B8CC5D14BC271B9@corpmail1.na.ads.idt.com>
References: <1366813919-13766-1-git-send-email-alexandre.bounine@idt.com>
	<1366813919-13766-2-git-send-email-alexandre.bounine@idt.com>
 <20130426155325.09fbad8c382dc8c549d503d0@linux-foundation.org>
In-Reply-To: <20130426155325.09fbad8c382dc8c549d503d0@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.165.140.50]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Apr 2013 6:53 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> Subject: Re: [PATCH 1/3] rapidio: make enumeration/discovery
> configurable
> 
> This Kconfig change makes my kbuild do Weird Things.
> 
> make mrproper ; yes "" | make allmodconfig ; make 2>/tmp/x
... skip ... 
> :   DMA Engine support for RapidIO (RAPIDIO_DMA_ENGINE) [Y/n/?] y
> :   RapidIO subsystem debug messages (RAPIDIO_DEBUG) [Y/n/?] y
> :   Enumeration method [M/y/?] (NEW) aborted!
> :
> : Console input/output is redirected. Run 'make oldconfig' to update configuration.
> :
> :   SYSHDR  arch/x86/syscalls/../include/generated/uapi/asm/unistd_32.h
> :   SYSHDR  arch/x86/syscalls/../include/generated/uapi/asm/unistd_64.h
> :   SYSHDR
> arch/x86/syscalls/../include/generated/uapi/asm/unistd_x32.h
> 
> 
> See the "Enumeration method [M/y/?] (NEW) aborted!"
> 
> Note that this only happens when make's stderr is redirected.
> 
> I've no idea what's going on here.  This appears to fix things:
> 
> --- a/drivers/rapidio/Kconfig~rapidio-make-enumeration-discovery-
> configurable-fix
> +++ a/drivers/rapidio/Kconfig
> @@ -59,7 +59,7 @@ choice
>  	  If unsure, select Basic built-in.
> 
>  config RAPIDIO_ENUM_BASIC
> -	tristate "Basic"
> +	bool "Basic"
>  	help
>  	  This option includes basic RapidIO fabric enumeration and
> discovery
>  	  mechanism similar to one described in RapidIO specification
> Annex 1.
> 
> but doesn't appear to be what you intended.

Goal is to build enumerator as a module or built-in.
I will retest v2 of patches for this issue.
There are some changes to Kconfig (removed AUTO_ENUM option).

