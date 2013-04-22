Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160Ab3DVOyt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 10:54:49 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:62064 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756144Ab3DVOyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 10:54:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Lars-Peter Clausen" <lars@metafoo.de>
Subject: Re: [PATCH 1/2] dma: of: Remove restriction that #dma-cells can't be 0
Date: Mon, 22 Apr 2013 16:54:37 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: Vinod Koul <vinod.koul@intel.com>, Jon Hunter <jon-hunter@ti.com>,
        linux-kernel@vger.kernel.org
References: <1366619613-30639-1-git-send-email-lars@metafoo.de> <201304221438.15945.arnd@arndb.de> <51753170.2050902@metafoo.de>
In-Reply-To: <51753170.2050902@metafoo.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304221654.38159.arnd@arndb.de>
X-Provags-ID: V02:K0:5w9BJeMiDpV6MZ2QSVCscXgWCwDlK3FjgYNPl0HEMOb
 LAGv8qbZWJp5+bPNBwmFPo2llRtQ0Y3mMRN2yuNe7LRgy7FQUc
 G63d9PxDHteFXSB8UGu3F0Rm6+BbL8en7DBHIQ2mfCQTW4GxsH
 jGmHEjSR9F8MaDGISpIBaHBjSlB1mg0jYO5L/uN4Csyxc2VzBt
 ZuJ6HUV/OWoYwzX7e90jSGQdD6LvKvdALNKMFUVGu+fSHHFy6n
 wrwm9CpIfl7qP2PWXeVO7MkqtKKAH1/L2gKXO6S8yfnN+t/MVS
 vQJDx7LGTgmtiSQeWEID3ixgPTHJKB7agDudqMmkce2bVBcpWO
 LO9kxyb2joAQeLnkA5dI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 April 2013, Lars-Peter Clausen wrote:
> 
> On 04/22/2013 02:38 PM, Arnd Bergmann wrote:
> > On Monday 22 April 2013, Lars-Peter Clausen wrote:
> >>
> >> There is no sensible reason why #dma-cells shouldn't be allowed to be 0. It is
> >> completely up to the DMA controller how many additional parameters, besides the
> >> phandle, it needs to identify a channel. E.g. for DMA controller with only one
> >> channel or for DMA controllers which don't have a restriction on which channel
> >> can be used for which peripheral it completely legitimate to not require any
> >> additional parameters.
> >>
> >> Also fixes the following warning:
> >>         drivers/dma/of-dma.c: In function 'of_dma_controller_register':
> >>         drivers/dma/of-dma.c:67:7: warning: 'nbcells' may be used uninitialized in this function
> >>
> >> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> > 
> > Do you have an example for this? If a dma engine has only one request line,
> > why would you even use the dmaengine subsystem for it, rather than including
> > the code to program it in the slave driver?
> 
> Why wouldn't I use the dmaengine subsystem for a DMA controller? In my
> particular case different instances of the same DMA core will be used with
> different DMA slaves. And the DMA slaves can also have different DMA master
> cores, depending on the system.

Right, that makes sense.

Acked-by: Arnd Bergmann <arnd@arndb.de>
