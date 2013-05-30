Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932238Ab3E3SpG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 14:45:06 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:65249 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756817Ab3E3So5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 14:44:57 -0400
Message-ID: <51A79EE3.4040403@metafoo.de>
Date: Thu, 30 May 2013 20:48:03 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: Ralf Baechle <ralf@linux-mips.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Maarten ter Huurne <maarten@treewalker.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH v2 6/6] MIPS: jz4740: Remove custom DMA API
References: <1369931105-28065-1-git-send-email-lars@metafoo.de> <1369931105-28065-7-git-send-email-lars@metafoo.de> <20130530172050.GB3767@intel.com>
In-Reply-To: <20130530172050.GB3767@intel.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2013 07:20 PM, Vinod Koul wrote:
> On Thu, May 30, 2013 at 06:25:05PM +0200, Lars-Peter Clausen wrote:
>> Now that all users of the custom jz4740 DMA API have been converted to use
>> the dmaengine API instead we can remove the custom API and move all the code
>> talking to the hardware to the dmaengine driver.
>>
>> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
>> Acked-by: Ralf Baechle <ralf@linux-mips.org>
>> ---
>> No changes since v1
>> ---
>>  arch/mips/include/asm/mach-jz4740/dma.h |  56 ------
>>  arch/mips/jz4740/Makefile               |   2 +-
>>  arch/mips/jz4740/dma.c                  | 307 --------------------------------
>>  drivers/dma/dma-jz4740.c                | 258 +++++++++++++++++++++++----
>>  4 files changed, 222 insertions(+), 401 deletions(-)
>>  delete mode 100644 arch/mips/jz4740/dma.c
> only dma.c, you should remove the dma.h or relocate it to linux/

As I said the header only contains the slave ids at this point and the
dmaengine driver doesn't need it anymore. So I should remove the #include from
the driver as well.

> 
> 
> rest of the series looks fine, and once we have acks from repsective subsystem
> mainatiners, we should be good to merge

We already have acks from the maintainers.

- Lars

