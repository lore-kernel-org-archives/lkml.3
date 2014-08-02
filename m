Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821AbaHBNIR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 09:08:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38093 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751534AbaHBNIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 09:08:15 -0400
Message-ID: <53DCE2BA.7010803@suse.de>
Date: Sat, 02 Aug 2014 15:08:10 +0200
From: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>, linux-samsung-soc@vger.kernel.org
CC: Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        open list <linux-kernel@vger.kernel.org>,
        Tomasz Figa <t.figa@samsung.com>, Kumar Gala <galak@codeaurora.org>,
        Stephan van Schaik <stephan@synkhronix.com>,
        Doug Anderson <dianders@chromium.org>,
        Rob Herring <robh+dt@kernel.org>, Ben Dooks <ben-linux@fluff.org>,
        Russell King <linux@arm.linux.org.uk>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v6 04/10] ARM: dts: Clean up exynos5250-snow
References: <1406940750-15880-1-git-send-email-afaerber@suse.de> <1406940750-15880-5-git-send-email-afaerber@suse.de> <53DCD7D7.2070208@gmail.com> <53DCDFF3.7030909@gmail.com>
In-Reply-To: <53DCDFF3.7030909@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 02.08.2014 14:56, schrieb Tomasz Figa:
> On 02.08.2014 14:21, Tomasz Figa wrote:
>> On 02.08.2014 02:52, Andreas Färber wrote:
>>> Use the new style of referencing inherited nodes and use symbolic names.
>>> Reorder one pinctrl node in GPIO order.
>>>
>>> Goal is the alignment of all exynos5250 based device trees for comparison.
>>>
>>> Suggested-by: Doug Anderson <dianders@chromium.org>
>>> Reviewed-by: Doug Anderson <dianders@chromium.org>
>>> Signed-off-by: Andreas Färber <afaerber@suse.de>
>>> ---
>>>  v5 -> v6:
>>>  * Split off label additions (Doug Anderson)
>>>  * Fixed alphabetical order of sd3_* nodes (Doug Anderson)
>>>  
>>>  v4 -> v5:
>>>  * Introduced labels to consistently use new referencing style (Tomasz Figa)
>>>  * Use IRQ_TYPE_* constants
>>>  * Use some more GPIO_ACTIVE_*
>>>
>>>  v3 -> v4: Unchanged
>>>  
>>>  v3: New (Doug Anderson)
>>>
>>>  arch/arm/boot/dts/exynos5250-snow.dts | 291 +++++++++++++++++-----------------
>>>  1 file changed, 145 insertions(+), 146 deletions(-)
>>
>> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> 
> Just for convenience of other reviewers, here are actual changes done do
> the device tree after compiling into dtb and then back into dts:

Erm, to not confuse reviewers, this must be over the whole series:

>> --- exynos5250-snow.dtb.dts	2014-08-02 14:54:15.145905921 +0200
>> +++ ../dtbs.post/exynos5250-snow.dtb.dts	2014-08-02 14:54:15.146905921 +0200
>> @@ -8,6 +8,7 @@
>>  	model = "Google Snow";
>>  
>>  	chosen {
>> +		bootargs = "console=tty1";
>>  	};
>>  
>>  	aliases {

This is optional follow-on patch 05/10.

>> @@ -829,15 +830,6 @@
>>  			phandle = <0x44>;
>>  		};
>>  
>> -		hdmi-hpd-irq {
>> -			samsung,pins = "gpx3-7";
>> -			samsung,pin-function = <0x0>;
>> -			samsung,pin-pud = <0x1>;
>> -			samsung,pin-drv = <0x0>;
>> -			linux,phandle = <0x33>;
>> -			phandle = <0x33>;
>> -		};
>> -
>>  		max77686-irq {
>>  			samsung,pins = "gpx3-2";
>>  			samsung,pin-function = <0x0>;
>> @@ -846,6 +838,15 @@
>>  			linux,phandle = <0xe>;
>>  			phandle = <0xe>;
>>  		};
>> +
>> +		hdmi-hpd-irq {
>> +			samsung,pins = "gpx3-7";
>> +			samsung,pin-function = <0x0>;
>> +			samsung,pin-pud = <0x1>;
>> +			samsung,pin-drv = <0x0>;
>> +			linux,phandle = <0x33>;
>> +			phandle = <0x33>;
>> +		};
>>  	};
>>  
>>  	pinctrl@13400000 {

This is this patch 04/10. Just a movement.

>> @@ -1703,12 +1704,12 @@
>>  		samsung,dw-mshc-ciu-div = <0x3>;
>>  		samsung,dw-mshc-sdr-timing = <0x2 0x3>;
>>  		samsung,dw-mshc-ddr-timing = <0x1 0x2>;
>> +		pinctrl-names = "default";
>> +		pinctrl-0 = <0x27 0x28 0x29>;
>>  
>>  		slot@0 {
>>  			reg = <0x0>;
>>  			bus-width = <0x4>;
>> -			pinctrl-names = "default";
>> -			pinctrl-0 = <0x27 0x28 0x29>;
>>  		};
>>  	};
>>  

This is preceding patch 01/10.

Regards,
Andreas

-- 
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 16746 AG Nürnberg
