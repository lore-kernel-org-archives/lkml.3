Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151Ab3FZVYX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 17:24:23 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:64916 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078Ab3FZVYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 17:24:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Leif Lindholm <leif.lindholm@linaro.org>
Subject: Re: [PATCH 0/2] arm: add early_ioremap() support
Date: Wed, 26 Jun 2013 23:23:50 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, nico@linaro.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>
References: <1372182401-11029-1-git-send-email-leif.lindholm@linaro.org> <201306262052.09640.arnd@arndb.de> <20130626192352.GE9078@rocoto.smurfnet.nu>
In-Reply-To: <20130626192352.GE9078@rocoto.smurfnet.nu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306262323.50691.arnd@arndb.de>
X-Provags-ID: V02:K0:aO4Xnile9hjm2CF9hak/gqpav7IH7OKZ7Zd+NxakcgM
 qlLk8+rRh6Q595yb8s7rkm8G+Yb3jWyHtz0E7J1WVHq+S2eYZ8
 jWiicEF+LF26BlbYM7GJELlxPsotk13gJYa+17/D05js3gDC35
 ayQ5zOCCZwKkVgI5Jq3IPlnpZrfe6xY73753zegFub01HjyQcg
 VUApdOEvRyUrnEBCLreO/cOcbSL+vp+W4JhillPqHzMn5qefN7
 M2nBwZ3dbehec+Zo4bvtCd04UXJ4tHHcIE7SJ5NsHIOMTgloce
 A64BTgfY8tIwrDio8zmOAUc9BnCqqGHgCmbQLEgMjJ8oJ4O/NP
 PB2GPwKvFmOVqdJeu/Lo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 June 2013, Leif Lindholm wrote:
> On Wed, Jun 26, 2013 at 08:52:09PM +0200, Arnd Bergmann wrote:
> > I made a similar suggestion to extending the use of fixmap recently, see
> > "Re: SCU registers mapping for CA9/CA5 cores". Russell pointed out that
> > fixmap is intentionally limited to just kmap_atomic uses at the moment
> > and changing that would potentially have a significant impact when we
> > run out of pages in the fixmap area.
>  
> Is this an issue here, since (unlike x86) this early_ioremap only works
> before paging_init()?

The main problem is that the total fixmap size is only around 900kb,
and we want to reserve at least 64kb per cpu for kmap_atomic.
If you want to fit multiple 128kb mappings in there, you run out of
space really fast.


> > Extending the iotable mechanism on ARM would be the convenient
> > solution for us I think.
> 
> Could that easily be extended to give similar semantics sufficiently
> that we can progress with merging more of the UEFI and ACPI support 
> together as common code with x86/ia64?

I don't know what the requirements are, but the idea with iotable
is that the mappings stay around at run time, while it seems you want
to discard them at some point.

	Arnd
