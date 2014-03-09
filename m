Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594AbaCIPBq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 11:01:46 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:58564 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbaCIPBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 11:01:45 -0400
Message-ID: <531C8269.4010105@gmail.com>
Date: Sun, 09 Mar 2014 23:02:01 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Suggestion] Makefile: about allmodconfig issue.
References: <531B1603.6080106@gmail.com> <531B3178.8000804@infradead.org> <531B8F2C.8080302@gmail.com> <531B9281.1080500@infradead.org>
In-Reply-To: <531B9281.1080500@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/2014 05:58 AM, Randy Dunlap wrote:
> On 03/08/2014 01:44 PM, Chen Gang wrote:
>> On 03/08/2014 11:04 PM, Randy Dunlap wrote:
>>> On 03/08/2014 05:07 AM, Chen Gang wrote:
>> [...]
>>>> Welcome any suggestions, discussions and completions.
>>>>
>>>> Thanks.
>>>>
>>>
>>> A patch has already been submitted and applied by the subsystem maintainer.
>>>
>>> http://marc.info/?l=linux-gpio&m=139413626320431&w=2
>>>
>>>
>>
>> OK, Thanks.  And excuse me, I can not connect to this web site in China.
>>
>> Could you please past the patch contents in the reply mail? (or just let
>> me know whether it is "make allmodconfig" issue, or only gpio driver's
>> issue)
>>
>>
>> Thanks.
> 
> It's a gpio driver Kconfig patch -- not an allmodconfig issue.
> 

Can we say that the 'select' priority is higher or equal than 'depends
on'?  If we really can say so, we need change our gpio driver.

Else ('depends on' priority is higher than 'select')

 - some architectures can choose whether support IRQ_DOMAIN.

 - if IRQ_DOMAIN enabled, our gpio driver can be used, and then select
   GENERIC_IRQ_CHIP (need not consider about it selects IRQ_DOMAIN).

 - else (IRQ_DOMAIN_disabled), we can not use our gpio driver, and also
   can not select GENERIC_IRQ_CHIP (need not consider about it selects
   IRQ_DOMAIN, either).

Excuse me, I am not quite familiar with Kconfig grammar, can any members
give a confirmation for it (whether 'select' priority is higher or equal
than 'depends on').


Thanks.

> Here is the patch:
> 
> From: Alan Tull <atull@altera.com>
> 
> fix build error with this message:
> kernel/irq/Kconfig:41:error: recursive dependency detected!
> kernel/irq/Kconfig:41:  symbol GENERIC_IRQ_CHIP is selected by GPIO_DWAPB
> drivers/gpio/Kconfig:131:       symbol GPIO_DWAPB depends on IRQ_DOMAIN
> kernel/irq/Kconfig:46:  symbol IRQ_DOMAIN is selected by GENERIC_IRQ_CHIP
> 
> Signed-off-by: Alan Tull <atull@altera.com>
> ---
>  drivers/gpio/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
> index 9979017..0e524d7 100644
> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -132,7 +132,7 @@ config GPIO_DWAPB
>  	tristate "Synopsys DesignWare APB GPIO driver"
>  	select GPIO_GENERIC
>  	select GENERIC_IRQ_CHIP
> -	depends on OF_GPIO && IRQ_DOMAIN
> +	depends on OF_GPIO
>  	help
>  	  Say Y or M here to build support for the Synopsys DesignWare APB
>  	  GPIO block.
> 


-- 
Chen Gang

Open, share and attitude like air, water and life which God blessed
