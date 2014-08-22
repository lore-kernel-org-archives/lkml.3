Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698AbaHVPZx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 11:25:53 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:44315 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756527AbaHVPZw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 11:25:52 -0400
Message-ID: <53F760F8.1050904@iki.fi>
Date: Fri, 22 Aug 2014 18:25:44 +0300
From: Antti Palosaari <crope@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Jeff Mahoney <jeffm@suse.com>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        LMML <linux-media@vger.kernel.org>
Subject: Re: Autoselecting SPI for MEDIA_SUBDRV_AUTOSELECT?
References: <53F75B26.2020101@suse.com> <53F75F02.2030300@iki.fi> <53F76097.8020800@suse.com>
In-Reply-To: <53F76097.8020800@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 82.128.191.73
X-SA-Exim-Mail-From: crope@iki.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2014 06:24 PM, Jeff Mahoney wrote:
> On Fri Aug 22 11:17:22 2014, Antti Palosaari wrote:
>> Moikka!
>>
>> On 08/22/2014 06:00 PM, Jeff Mahoney wrote:
>>> -----BEGIN PGP SIGNED MESSAGE-----
>>> Hash: SHA1
>>>
>>> Hi Antti -
>>>
>>> Commit e4462ffc160 ([media] Kconfig: sub-driver auto-select SPI bus)
>>> enables CONFIG_SPI globally for a driver that won't even be enabled in
>>> many cases.
>>>
>>> Is there a reason USB_MSI2500 doesn't select SPI instead of
>>> MEDIA_SUBDRV_AUTOSELECT?
>>
>> Nothing but I decided to set it similarly as I2C, another more common
>> bus. IIRC same was for I2C_MUX too.
>>
>> You could still disable media subdriver autoselect and then disable
>> SPI and select all the media drivers (excluding MSSi2500) manually.
>>
>> I have feeling that media auto-select was added to select everything
>> needed for media.
>
> Ok, that makes sense. I suppose I'll still need to enable SPI just for
> this device and disable every other SPI device anyway. I'll live.

See drivers/media/Kconfig :

config MEDIA_SUBDRV_AUTOSELECT
	bool "Autoselect ancillary drivers (tuners, sensors, i2c, frontends)"
	depends on MEDIA_ANALOG_TV_SUPPORT || MEDIA_DIGITAL_TV_SUPPORT || 
MEDIA_CAMERA_SUPPORT || MEDIA_SDR_SUPPORT
	depends on HAS_IOMEM
	select I2C
	select I2C_MUX
	select SPI
	default y
	help
	  By default, a media driver auto-selects all possible ancillary
	  devices such as tuners, sensors, video encoders/decoders and
	  frontends, that are used by any of the supported devices.

	  This is generally the right thing to do, except when there
	  are strict constraints with regards to the kernel size,
	  like on embedded systems.

	  Use this option with care, as deselecting ancillary drivers which
	  are, in fact, necessary will result in the lack of the needed
	  functionality for your device (it may not tune or may not have
	  the needed demodulators).

	  If unsure say Y.


regards
Antti

-- 
http://palosaari.fi/
