Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab3DVMsj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 08:48:39 -0400
Received: from smtp-out-212.synserver.de ([212.40.185.212]:1074 "EHLO
	smtp-out-210.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753308Ab3DVMsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 08:48:38 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 30541
Message-ID: <51753170.2050902@metafoo.de>
Date: Mon, 22 Apr 2013 14:47:44 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Vinod Koul <vinod.koul@intel.com>, Jon Hunter <jon-hunter@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] dma: of: Remove restriction that #dma-cells can't
 be 0
References: <1366619613-30639-1-git-send-email-lars@metafoo.de> <201304221438.15945.arnd@arndb.de>
In-Reply-To: <201304221438.15945.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2013 02:38 PM, Arnd Bergmann wrote:
> On Monday 22 April 2013, Lars-Peter Clausen wrote:
>>
>> There is no sensible reason why #dma-cells shouldn't be allowed to be 0. It is
>> completely up to the DMA controller how many additional parameters, besides the
>> phandle, it needs to identify a channel. E.g. for DMA controller with only one
>> channel or for DMA controllers which don't have a restriction on which channel
>> can be used for which peripheral it completely legitimate to not require any
>> additional parameters.
>>
>> Also fixes the following warning:
>>         drivers/dma/of-dma.c: In function 'of_dma_controller_register':
>>         drivers/dma/of-dma.c:67:7: warning: 'nbcells' may be used uninitialized in this function
>>
>> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> 
> Do you have an example for this? If a dma engine has only one request line,
> why would you even use the dmaengine subsystem for it, rather than including
> the code to program it in the slave driver?

Why wouldn't I use the dmaengine subsystem for a DMA controller? In my
particular case different instances of the same DMA core will be used with
different DMA slaves. And the DMA slaves can also have different DMA master
cores, depending on the system.

- Lars
