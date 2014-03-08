Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938AbaCHV62 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 16:58:28 -0500
Received: from merlin.infradead.org ([205.233.59.134]:52624 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbaCHV61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 16:58:27 -0500
Message-ID: <531B9281.1080500@infradead.org>
Date: Sat, 08 Mar 2014 13:58:25 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Chen Gang <gang.chen.5i5j@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Suggestion] Makefile: about allmodconfig issue.
References: <531B1603.6080106@gmail.com> <531B3178.8000804@infradead.org> <531B8F2C.8080302@gmail.com>
In-Reply-To: <531B8F2C.8080302@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2014 01:44 PM, Chen Gang wrote:
> On 03/08/2014 11:04 PM, Randy Dunlap wrote:
>> On 03/08/2014 05:07 AM, Chen Gang wrote:
> [...]
>>> Welcome any suggestions, discussions and completions.
>>>
>>> Thanks.
>>>
>>
>> A patch has already been submitted and applied by the subsystem maintainer.
>>
>> http://marc.info/?l=linux-gpio&m=139413626320431&w=2
>>
>>
> 
> OK, Thanks.  And excuse me, I can not connect to this web site in China.
> 
> Could you please past the patch contents in the reply mail? (or just let
> me know whether it is "make allmodconfig" issue, or only gpio driver's
> issue)
> 
> 
> Thanks.

It's a gpio driver Kconfig patch -- not an allmodconfig issue.

Here is the patch:

From: Alan Tull <atull@altera.com>

fix build error with this message:
kernel/irq/Kconfig:41:error: recursive dependency detected!
kernel/irq/Kconfig:41:  symbol GENERIC_IRQ_CHIP is selected by GPIO_DWAPB
drivers/gpio/Kconfig:131:       symbol GPIO_DWAPB depends on IRQ_DOMAIN
kernel/irq/Kconfig:46:  symbol IRQ_DOMAIN is selected by GENERIC_IRQ_CHIP

Signed-off-by: Alan Tull <atull@altera.com>
---
 drivers/gpio/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 9979017..0e524d7 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -132,7 +132,7 @@ config GPIO_DWAPB
 	tristate "Synopsys DesignWare APB GPIO driver"
 	select GPIO_GENERIC
 	select GENERIC_IRQ_CHIP
-	depends on OF_GPIO && IRQ_DOMAIN
+	depends on OF_GPIO
 	help
 	  Say Y or M here to build support for the Synopsys DesignWare APB
 	  GPIO block.
-- 



-- 
~Randy
