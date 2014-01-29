Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011AbaA2TD6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 14:03:58 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:47782 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624AbaA2TD5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 14:03:57 -0500
Message-ID: <52E95098.4060809@ti.com>
Date: Wed, 29 Jan 2014 13:03:52 -0600
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Christoph Fritz <chf.fritz@googlemail.com>, Tero Kristo <t-kristo@ti.com>
CC: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <pali.rohar@gmail.com>, <pavel@ucw.cz>
Subject: Re: OMAP: clock DT conversion issues with omap36xx
References: <52E697C0.6000202@gmail.com> <1390848104.4936.62.camel@mars>	 <52E772A3.4090401@ti.com> <1390901735.2963.8.camel@lovely>	 <52E77D03.8090001@ti.com>  <52E7B361.2030601@ti.com>	 <1390928565.4904.88.camel@mars> <1390994505.5023.32.camel@mars>
In-Reply-To: <1390994505.5023.32.camel@mars>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2014 05:21 AM, Christoph Fritz wrote:
> On Tue, 2014-01-28 at 18:02 +0100, Christoph Fritz wrote:
>> On Tue, 2014-01-28 at 15:40 +0200, Tero Kristo wrote:
>>>
>>>>> Due to a regression since next-20140122 the following errors are present:
>>>>>
>>>>>   - pin sys_clkout2, which gets configured to 24 Mhz by the fourth patch
>>>>>     in this set, erroneously outputs only 12 Mhz.
>>>>>     Just out of curiosity, configuring it to 48 Mhz puts out desired 24 Mhz.
>>>>>
>>>>>   - omap_dss, which gets configured by the third patch in this set, fails
>>>>>     to do 'dss_set_fck_rate(fck);' in
>>>>>     drivers/video/omap2/dss/dss.c:dss_setup_default_clock() which leads to:
>>>>>
>>>>>      | omapdss_dss: probe of omapdss_dss failed with error -22
>>>>>      | omapdss CORE error: Failed to initialize DSS platform driver
>>>>>      | panel-dpi panel-dpi.0: failed to find video source 'dpi.0
>>>>>
>>>>>    Both regressions seem to have something to do with the clock framework.
>>>>>    Could this be related to the DT clock conversion patches?
>>>>
>>>
>>> Yea its definitely possible, as the clock DT conversion touches pretty 
>>> much everything. Have you tried whether this works properly with legacy 
>>> boot? Personally I don't have access to any omap3 devices that would 
>>> have display and have no possibility to check this out myself. Anyway, 
>>> my initial guess is that some clock divider setup might be wrong with 
>>> omap3, or we are missing some ti,set-rate-parent flag for some clock 
>>> node which prevents escalating clk_set_rate properly. However, it should 
>>> be easy to debug this by looking at the clock node in question, and its 
>>> parent nodes to see if there are any problems.
>>
>> Currently I only analyzed sys_clkout2 (see attachments for full
>> clk_summary files):

To help us debug similar problems, I wrote a tool today:
https://github.com/nmenon/ctt-dump - it is a simple memory read utility,

Input file is CTT dump-out
For example: 3630 CTT is here:
http://www.ti.com/pdfs/wtbu/CTT-OMAP3630ES1.x-v1.6.0.4.zip

to give an idea - i posted a screen shot here:
https://plus.google.com/112464029509057661457/posts/hNdee4gNfob

After generating the the rd1 file from CTT,
we pick up the registers using ctt-dump -> any tool which can do
register reads could do, but it might be handy having this.
Example output on beagle-xm: http://slexy.org/view/s2YWmM1ium
importing it back into CTT and after setting up the correct sysclk, we
can compare clock frequencies Vs debugfs output - example:
http://slexy.org/view/s21iQyDTct


I mean, it is awesome having to debugfs data, but with nascent
systems, it is always good to compare to what the hardware is really
configured to - and CTT is the easy way to deal with it.

-- 
Regards,
Nishanth Menon
