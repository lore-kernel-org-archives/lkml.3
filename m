Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758950AbaGXNhz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 09:37:55 -0400
Received: from mail-bn1blp0182.outbound.protection.outlook.com ([207.46.163.182]:1905
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756834AbaGXNhx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 09:37:53 -0400
X-WSS-ID: 0N97XUV-08-RQ7-02
X-M-MSG: 
Message-ID: <53D10C20.3020101@amd.com>
Date: Thu, 24 Jul 2014 08:37:36 -0500
From: Tom Lendacky <thomas.lendacky@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the crypto tree
References: <20140724130801.3dce9bb7@canb.auug.org.au>
 <53D0B005.8050400@infradead.org>
In-Reply-To: <53D0B005.8050400@infradead.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(24454002)(189002)(199002)(479174003)(51704005)(164054003)(377454003)(21056001)(77982001)(97736001)(65806001)(36756003)(47776003)(65956001)(92726001)(83322001)(87936001)(59896001)(80316001)(74502001)(50986999)(54356999)(86362001)(64706001)(64126003)(33656002)(44976005)(85852003)(81542001)(106466001)(107046002)(80022001)(76482001)(4396001)(68736004)(101416001)(87266999)(102836001)(95666004)(20776003)(83072002)(31966008)(92566001)(76176999)(85306003)(79102001)(81342001)(99396002)(23676002)(105586002)(65816999)(83506001)(46102001)(84676001)(74662001)(50466002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR02MB041;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 028256169F
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2014 02:04 AM, Randy Dunlap wrote:
> On 07/23/2014 08:08 PM, Stephen Rothwell wrote:
>> Hi Herbert,
>>
>> After merging the crypto tree, today's linux-next build (powerpc
>> ppc64_defconfig) produced these messages:
>>
>> fs/sysfs/Kconfig:1:error: recursive dependency detected!
>> fs/sysfs/Kconfig:1:	symbol SYSFS is selected by AT91_ADC
>> drivers/iio/adc/Kconfig:110:	symbol AT91_ADC depends on IIO
>> drivers/iio/Kconfig:5:	symbol IIO is selected by RTC_DRV_HID_SENSOR_TIME
>> drivers/rtc/Kconfig:1370:	symbol RTC_DRV_HID_SENSOR_TIME depends on USB_HID
>> drivers/hid/usbhid/Kconfig:4:	symbol USB_HID depends on USB
>> drivers/usb/Kconfig:41:	symbol USB is selected by MOUSE_APPLETOUCH
>
> Don't know if it will help, but we
> aren't supposed to use 'select' for subsystems, like USB above.
>
>> drivers/input/mouse/Kconfig:162:	symbol MOUSE_APPLETOUCH depends on INPUT
>> drivers/input/Kconfig:8:	symbol INPUT is selected by VT
>
> That one ^^^ is also questionable.
>
>> drivers/tty/Kconfig:12:	symbol VT is selected by FB_STI
>> drivers/video/fbdev/Kconfig:652:	symbol FB_STI depends on FB
>> drivers/video/fbdev/Kconfig:5:	symbol FB is selected by DRM_KMS_FB_HELPER
>> drivers/gpu/drm/Kconfig:39:	symbol DRM_KMS_FB_HELPER is selected by DRM_KMS_CMA_HELPER
>> drivers/gpu/drm/Kconfig:74:	symbol DRM_KMS_CMA_HELPER is selected by DRM_TILCDC
>> drivers/gpu/drm/tilcdc/Kconfig:1:	symbol DRM_TILCDC depends on OF
>> drivers/of/Kconfig:4:	symbol OF is selected by CRYPTO_DEV_CCP_DD
>> drivers/crypto/ccp/Kconfig:1:	symbol CRYPTO_DEV_CCP_DD depends on CRYPTO
>> crypto/Kconfig:15:	symbol CRYPTO is selected by IP_SCTP
>
> That one ^^^ could be questionable...
>
>> net/sctp/Kconfig:5:	symbol IP_SCTP is selected by DLM
>> fs/dlm/Kconfig:1:	symbol DLM depends on SYSFS
>>
>> The x86_64 allmodconfig build produced these:
>>
>> scripts/kconfig/conf --allmodconfig Kconfig
>> drivers/usb/Kconfig:41:error: recursive dependency detected!
>> drivers/usb/Kconfig:41:	symbol USB is selected by MOUSE_APPLETOUCH
>> drivers/input/mouse/Kconfig:162:	symbol MOUSE_APPLETOUCH depends on INPUT
>> drivers/input/Kconfig:8:	symbol INPUT is selected by VT
>> drivers/tty/Kconfig:12:	symbol VT is selected by FB_STI
>> drivers/video/fbdev/Kconfig:652:	symbol FB_STI depends on FB
>> drivers/video/fbdev/Kconfig:5:	symbol FB is selected by DRM_KMS_FB_HELPER
>> drivers/gpu/drm/Kconfig:39:	symbol DRM_KMS_FB_HELPER is selected by DRM_KMS_CMA_HELPER
>> drivers/gpu/drm/Kconfig:74:	symbol DRM_KMS_CMA_HELPER is selected by DRM_TILCDC
>> drivers/gpu/drm/tilcdc/Kconfig:1:	symbol DRM_TILCDC depends on OF
>> drivers/of/Kconfig:4:	symbol OF is selected by CRYPTO_DEV_CCP_DD
>> drivers/crypto/ccp/Kconfig:1:	symbol CRYPTO_DEV_CCP_DD depends on CRYPTO

I submitted a patch to Herbert to remove the "select OF if ARM64" that
caused this.  He applied it early this morning.  OF is selected by
ARM64 so it wasn't really needed. I'm surprised that this error occurs
when the select is protected by an "if ARM64" and none of these builds
is ARCH=arm64.

Thanks,
Tom

>> crypto/Kconfig:15:	symbol CRYPTO is selected by IP_SCTP
>> net/sctp/Kconfig:5:	symbol IP_SCTP is selected by DLM
>> fs/dlm/Kconfig:1:	symbol DLM depends on SYSFS
>> fs/sysfs/Kconfig:1:	symbol SYSFS is selected by AT91_ADC
>> drivers/iio/adc/Kconfig:110:	symbol AT91_ADC depends on IIO
>> drivers/iio/Kconfig:5:	symbol IIO is selected by RTC_DRV_HID_SENSOR_TIME
>> drivers/rtc/Kconfig:1370:	symbol RTC_DRV_HID_SENSOR_TIME depends on USB_HID
>> drivers/hid/usbhid/Kconfig:4:	symbol USB_HID depends on USB
>>
>> And then the arm multi_v7_defconfig build produced these:
>>
>> drivers/usb/Kconfig:41:error: recursive dependency detected!
>> drivers/usb/Kconfig:41:	symbol USB is selected by MOUSE_APPLETOUCH
>> drivers/input/mouse/Kconfig:162:	symbol MOUSE_APPLETOUCH depends on INPUT
>> drivers/input/Kconfig:8:	symbol INPUT is selected by VT
>> drivers/tty/Kconfig:12:	symbol VT is selected by FB_STI
>> drivers/video/fbdev/Kconfig:652:	symbol FB_STI depends on FB
>> drivers/video/fbdev/Kconfig:5:	symbol FB is selected by DRM_KMS_FB_HELPER
>> drivers/gpu/drm/Kconfig:39:	symbol DRM_KMS_FB_HELPER is selected by DRM_KMS_CMA_HELPER
>> drivers/gpu/drm/Kconfig:74:	symbol DRM_KMS_CMA_HELPER is selected by DRM_TILCDC
>> drivers/gpu/drm/tilcdc/Kconfig:1:	symbol DRM_TILCDC depends on OF
>> drivers/of/Kconfig:4:	symbol OF is selected by CRYPTO_DEV_CCP_DD
>> drivers/crypto/ccp/Kconfig:1:	symbol CRYPTO_DEV_CCP_DD depends on CRYPTO
>> crypto/Kconfig:15:	symbol CRYPTO is selected by IP_SCTP
>> net/sctp/Kconfig:5:	symbol IP_SCTP is selected by DLM
>> fs/dlm/Kconfig:1:	symbol DLM depends on SYSFS
>> fs/sysfs/Kconfig:1:	symbol SYSFS is selected by AT91_ADC
>> drivers/iio/adc/Kconfig:110:	symbol AT91_ADC depends on IIO
>> drivers/iio/Kconfig:5:	symbol IIO is selected by RTC_DRV_HID_SENSOR_TIME
>> drivers/rtc/Kconfig:1370:	symbol RTC_DRV_HID_SENSOR_TIME depends on USB_HID
>> drivers/hid/usbhid/Kconfig:4:	symbol USB_HID depends on USB
>> #
>> # configuration written to .config
>> #
>> WITHOUT_CCACHE:
>> WITHOUT_DISTCC:
>> ARCH=arm
>> CCVER=4.9.0
>> drivers/usb/Kconfig:41:error: recursive dependency detected!
>> drivers/usb/Kconfig:41:	symbol USB is selected by MOUSE_APPLETOUCH
>> drivers/input/mouse/Kconfig:162:	symbol MOUSE_APPLETOUCH depends on INPUT
>> drivers/input/Kconfig:8:	symbol INPUT is selected by VT
>> drivers/tty/Kconfig:12:	symbol VT is selected by FB_STI
>> drivers/video/fbdev/Kconfig:652:	symbol FB_STI depends on FB
>> drivers/video/fbdev/Kconfig:5:	symbol FB is selected by DRM_KMS_FB_HELPER
>> drivers/gpu/drm/Kconfig:39:	symbol DRM_KMS_FB_HELPER is selected by DRM_KMS_CMA_HELPER
>> drivers/gpu/drm/Kconfig:74:	symbol DRM_KMS_CMA_HELPER is selected by DRM_TILCDC
>> drivers/gpu/drm/tilcdc/Kconfig:1:	symbol DRM_TILCDC depends on OF
>> drivers/of/Kconfig:4:	symbol OF is selected by CRYPTO_DEV_CCP_DD
>> drivers/crypto/ccp/Kconfig:1:	symbol CRYPTO_DEV_CCP_DD depends on CRYPTO
>> crypto/Kconfig:15:	symbol CRYPTO is selected by IP_SCTP
>> net/sctp/Kconfig:5:	symbol IP_SCTP is selected by DLM
>> fs/dlm/Kconfig:1:	symbol DLM depends on SYSFS
>> fs/sysfs/Kconfig:1:	symbol SYSFS is selected by AT91_ADC
>> drivers/iio/adc/Kconfig:110:	symbol AT91_ADC depends on IIO
>> drivers/iio/Kconfig:5:	symbol IIO is selected by RTC_DRV_HID_SENSOR_TIME
>> drivers/rtc/Kconfig:1370:	symbol RTC_DRV_HID_SENSOR_TIME depends on USB_HID
>> drivers/hid/usbhid/Kconfig:4:	symbol USB_HID depends on USB
>> *
>> * Restart config...
>> *
>> *
>> * USB HID Boot Protocol drivers
>> *
>> USB HIDBP Keyboard (simple Boot) support (USB_KBD) [N/m/y/?] (NEW) aborted!
>>
>> Console input/output is redirected. Run 'make oldconfig' to update configuration.
>>
>>
>> I am not sure exactly what caused all this, but it is probably commit
>> 126ae9adc1ec ("crypto: ccp - Base AXI DMA cache settings on device
>> tree").
>>
>> I have used the version of the crypto tree from next-20140723 for today.
>>
>
>
