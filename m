Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965052AbbA2Cgq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:36:46 -0500
Received: from bitmer.com ([213.157.87.50]:51872 "EHLO bitmer.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965031AbbA2Cgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:36:43 -0500
X-Greylist: delayed 21599 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Jan 2015 21:36:43 EST
Message-ID: <54C92752.9000004@bitmer.com>
Date: Wed, 28 Jan 2015 20:15:46 +0200
From: Jarkko Nikula <jarkko.nikula@bitmer.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@ti.com>, Pavel Machek <pavel@ucw.cz>,
        pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com
Subject: Re: 3.19 on Nokia n900: audio quality awful
References: <20150106170433.GA5408@amd> <20150118120139.GA1509@amd> <54C63F1C.6010703@ti.com>
In-Reply-To: <54C63F1C.6010703@ti.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2015 03:20 PM, Peter Ujfalusi wrote:
> On 01/18/2015 02:01 PM, Pavel Machek wrote:
>> In 2.6.28-nokia, it is neccessary to set "Input select" na "digital
>> mic", then it works. Input select being in "playback" option makes it
>> easy to miss.
>>
>> In 3.18 and 3.19-rc3, all I can record are zeros.
>>
>> Does playback/recording work for you on OMAP 3430-based machines?
> 
> Same codec (tlv320aic3106) works fine on my am335x and omap-l138 boards.
> BeagleBoard-xM also fine with twl4030 codec.
> 
> I don't have my n900 in hacking mode (it is still in use time-to-time) but
> looking at the dts file: you might want to add ai3x-micbias-vg property to the
> aic3x nodes to select the correct mic bias voltage. I can't recall what is
> appropriate for n900, but 2.6.28-nokia sources might give you the answer.
> 
No need to go that far. N900 has been supported in mainline since 2.6.39
or so. Part A of AIC34 (which is basically dual AIC33 in a same package)
drives 2 V for the digital microphone bias and part B 2.5 V for the headset.

Unfortunately I haven't had time recently to try what might have caused
that regression after 3.18.

-- 
Jarkko
