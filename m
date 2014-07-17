Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179AbaGQB60 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 21:58:26 -0400
Received: from mail.active-venture.com ([67.228.131.205]:58661 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbaGQB6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 21:58:23 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53C72DBC.5020900@roeck-us.net>
Date: Wed, 16 Jul 2014 18:58:20 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Chen Gang <gang.chen.5i5j@gmail.com>, Richard Weinberger <richard@nod.at>
CC: Lars-Peter Clausen <lars@metafoo.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        dmitry.torokhov@gmail.com, linux-iio@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>, teg@jklm.no,
        Thierry Reding <thierry.reding@gmail.com>,
        Lennox Wu <lennox.wu@gmail.com>, Marek Vasut <marex@denx.de>,
        Liqin Chen <liqin.linux@gmail.com>, msalter@redhat.com,
        linux-pwm@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-watchdog@vger.kernel.org, linux-input@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        knaack.h@gmx.de, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Mischa.Jonker@synopsys.com, jic23@kernel.org, arnd@arndb.de,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] drivers: Let several drivers depends on HAS_IOMEM for
 'devm_ioremap_resource'
References: <201407130545.23004.marex@denx.de> <CAF0htA60juBVkPo2HQKMDGcEr-wRzRVL_6JgHAa+7WVE_E8M0Q@mail.gmail.com> <53C25551.1050909@nod.at> <53C288F0.3070001@metafoo.de> <53C28C4A.70907@nod.at> <53C29015.5070607@metafoo.de> <53C291C8.6050303@nod.at> <53C296C2.30304@metafoo.de> <20140713192202.GA19090@kroah.com> <53C2DF12.6040507@nod.at> <20140713201753.GA29955@kroah.com> <53C39569.9020802@nod.at> <53C3994C.1010309@metafoo.de> <53C39B66.4060500@nod.at> <5A40E1FC-CA61-4AFF-B205-4BAC175AA7AC@gmail.com> <53C47725.8000005@gmail.com> <53C47B76.4080306@roeck-us.net> <53C47FB7.6080304@gmail.com> <53C53CE1.4090803@gmail.com> <53C7269E.4010702@gmail.com>
In-Reply-To: <53C7269E.4010702@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2014 06:27 PM, Chen Gang wrote:
>
>
> On 07/15/2014 10:38 PM, Chen Gang wrote:
>> On 07/15/2014 09:11 AM, Chen Gang wrote:
>>>
>>>
>>> On 07/15/2014 08:53 AM, Guenter Roeck wrote:
>>>> On 07/14/2014 05:34 PM, Chen Gang wrote:
>>>>> On 07/14/2014 05:22 PM, Chen Gang wrote:
>>>>>>
>>>>>> 在 2014年7月14日，下午4:57，Richard Weinberger <richard@nod.at> 写道：
>>>>>>
>>>>>>> Am 14.07.2014 10:48, schrieb Lars-Peter Clausen:
>>>>>>>> On 07/14/2014 10:31 AM, Richard Weinberger wrote:
>>>>>>>>> Am 13.07.2014 22:17, schrieb Greg Kroah-Hartman:
>>>>>>>>>> On Sun, Jul 13, 2014 at 09:33:38PM +0200, Richard Weinberger wrote:
>>>>>>>>>>> Maybe we could add COMPILE_TEST to the version string too?
>>>>>>>>>>> Just to detect such kernels fast in user bug reports...
>>>>>>>>>>
>>>>>>>>>> What kind of bug report are you going to get?
>>>>>>>>>
>>>>>>>>> User manages to enable CONFIG_FOO by selecting COMPILE_TEST and
>>>>>>>>> complains that it does not work. :)
>>>>>>>>
>>>>>>>> These drivers are typically drivers for some SoC peripheral and the
>>>>>>>> device will simply physically not exist on a platform that does not
>>>>>>>> provide HAS_IOMEM. This is not really any
>>>>>>>> different from making the driver selectable via COMPILE_TEST for
>>>>>>>> any other platform. To hit the issue you'd have to instantiate a
>>>>>>>> device driver instance for a device that
>>>>>>>> physically does not exist. This will always result in a failure.
>>>>>>>
>>>>>>> Okay, you have convinced me. :)
>>>>>>>
>>>>>
>>>>> After search the history patches, I found one related patch which made
>>>>> by myself (when I am in Asianux):
>>>>>
>>>>>     "https://lkml.org/lkml/2013/7/1/641"
>>>>>
>>>>> For me, it is a long discussion, and forced many members have to join
>>>>> in. Please help check again.
>>>>>
>>>>
>>>> One thing you could try would be to return NULL (or where appropriate
>>>> an error) in the #else case of CONFIG_HAS_IOMEM and CONFIG_HAS_IOPORT,
>>>> ie dont take COMPILE_TEST into account at all. Obviously that means
>>>> you won't be able to dump a warning message in the COMPILE_TEST
>>>> case, but at least the code would compile. The rejection of above patch
>>>> would make a good case for this approach.
>>>>
>
> For me, only let 'devm_io*map*' support COMPILE_TEST is OK, that can fix
> all related issues:
>
>
> [PATCH] lib: devres: Add dumy functions to support COMPILE_TEST when no IOMEM
>
> For some architectures which no IOMEM, 'devres' will be skipped. But
> many drivers may still want COMPILE_TEST, so let 'devres' support it.
>
> The related error (with allmodconfig under score):
>
>      MODPOST 1365 modules
>    ERROR: "devm_ioremap_resource" [drivers/watchdog/tegra_wdt.ko] undefined!
>    ERROR: "devm_ioremap_resource" [drivers/watchdog/of_xilinx_wdt.ko] undefined!
>    ERROR: "devm_ioremap_resource" [drivers/staging/iio/adc/mxs-lradc.ko] undefined!
>    ERROR: "devm_ioremap_resource" [drivers/pwm/pwm-clps711x.ko] undefined!
>    ERROR: "devm_ioremap_resource" [drivers/input/serio/olpc_apsp.ko] undefined!
>    ERROR: "devm_ioremap_resource" [drivers/input/serio/arc_ps2.ko] undefined!
>    ERROR: "devm_ioremap_resource" [drivers/rtc/rtc-xgene.ko] undefined!
>    ERROR: "devm_ioremap_resource" [drivers/rtc/rtc-stk17ta8.ko] undefined!
>    ERROR: "devm_ioremap_resource" [drivers/rtc/rtc-ds1742.ko] undefined!
>    ERROR: "devm_ioremap_resource" [drivers/rtc/rtc-ds1553.ko] undefined!
>    ERROR: "devm_ioremap_resource" [drivers/rtc/rtc-ds1511.ko] undefined!
>    ERROR: "devm_ioremap_resource" [drivers/rtc/rtc-ds1286.ko] undefined!
>    ERROR: "devm_ioremap" [drivers/rtc/rtc-rp5c01.ko] undefined!
>    ERROR: "devm_ioremap" [drivers/rtc/rtc-msm6242.ko] undefined!
>    ERROR: "devm_ioremap" [drivers/rtc/rtc-m48t59.ko] undefined!
>    ERROR: "devm_ioremap" [drivers/rtc/rtc-m48t35.ko] undefined!
>    ERROR: "devm_ioremap" [drivers/rtc/rtc-bq4802.ko] undefined!
>
>
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>   include/linux/device.h |  9 +++++++++
>   include/linux/io.h     | 30 +++++++++++++++++++++++++++++-
>   2 files changed, 38 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/device.h b/include/linux/device.h
> index c2421e0..a7500c3 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -630,7 +630,16 @@ extern unsigned long devm_get_free_pages(struct device *dev,
>   					 gfp_t gfp_mask, unsigned int order);
>   extern void devm_free_pages(struct device *dev, unsigned long addr);
>
> +#ifdef CONFIG_HAS_IOMEM
>   void __iomem *devm_ioremap_resource(struct device *dev, struct resource *res);
> +#elif defined(CONFIG_COMPILE_TEST)

I would make it #else

> +static inline void __iomem *devm_ioremap_resource(struct device *dev,
> +						struct resource *res)
> +{
> +	pr_warn("no hardware io memory, only for COMPILE_TEST\n");

dev_warn

> +	return (__force void __iomem *)ERR_PTR(-ENXIO);
> +}
> +#endif /* CONFIG_HAS_IOMEM || CONFIG_COMPILE_TEST */
>
>   /* allows to add/remove a custom action to devres stack */
>   int devm_add_action(struct device *dev, void (*action)(void *), void *data);
> diff --git a/include/linux/io.h b/include/linux/io.h
> index b76e6e5..59128aa 100644
> --- a/include/linux/io.h
> +++ b/include/linux/io.h
> @@ -58,14 +58,42 @@ static inline void devm_ioport_unmap(struct device *dev, void __iomem *addr)
>   }
>   #endif
>
> +#ifdef CONFIG_HAS_IOMEM
> +
>   void __iomem *devm_ioremap(struct device *dev, resource_size_t offset,
>   			    unsigned long size);
>   void __iomem *devm_ioremap_nocache(struct device *dev, resource_size_t offset,
>   				    unsigned long size);
>   void devm_iounmap(struct device *dev, void __iomem *addr);
> +void devm_ioremap_release(struct device *dev, void *res);
> +
> +#elif defined(CONFIG_COMPILE_TEST)
> +

Same as above - I would suggest to use #else.

> +static inline void __iomem *devm_ioremap(struct device *dev,
> +				resource_size_t offset, unsigned long size)
> +{
> +	pr_warn("no hardware io memory, only for COMPILE_TEST\n");
> +	return NULL;
> +}
> +static inline void __iomem *devm_ioremap_nocache(struct device *dev,
> +				resource_size_t offset, unsigned long size)
> +{
> +	pr_warn("no hardware io memory, only for COMPILE_TEST\n");

dev_warn

Guenter

> +	return NULL;
> +}
> +
> +static inline void devm_iounmap(struct device *dev, void __iomem *addr)
> +{
> +}
> +
> +static inline void devm_ioremap_release(struct device *dev, void *res)
> +{
> +}
> +
> +#endif /* CONFIG_HAS_IOMEM || CONFIG_COMPILE_TEST */
> +
>   int check_signature(const volatile void __iomem *io_addr,
>   			const unsigned char *signature, int length);
> -void devm_ioremap_release(struct device *dev, void *res);
>
>   /*
>    * Some systems do not have legacy ISA devices.
>

