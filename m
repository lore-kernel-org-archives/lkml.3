Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751296Ab3G0KDN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 06:03:13 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:5707 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab3G0KDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 06:03:10 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sat, 27 Jul 2013 03:03:09 -0700
Message-ID: <51F39D98.1090008@nvidia.com>
Date: Sat, 27 Jul 2013 15:44:48 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "kishon@ti.com" <kishon@ti.com>, Stephen Warren <swarren@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 1/2] pinctrl: pinconf_generic: add utility functions for
 add map/configs
References: <1374833754-19659-1-git-send-email-ldewangan@nvidia.com> <1374833754-19659-2-git-send-email-ldewangan@nvidia.com> <51F2B384.9050706@wwwdotorg.org>
In-Reply-To: <51F2B384.9050706@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 July 2013 11:06 PM, Stephen Warren wrote:
> On 07/26/2013 04:15 AM, Laxman Dewangan wrote:
>> Some of pincontrol driver needs the utility function to create map
>> list. The utility function needed for adding mux, configs etc.
> Which other drivers already contain this code? Are you planning on
> converting them over to use these new functions? The code looks
> familiar, so I assume it's just cut/paste from Tegra with some renames,
> so I didn't read it through in detail.

Yes, these functions are taken from the pinctrl-tegra driver. Other 
drivers which have similar implementation are nomadik, tegra, abx500, 
tz1090, tz1090-pdc.
So All can use these utility function to avoid duplication and reduce 
code size.
Yes, I have plan to use this in Tegra atleast but once this patch get 
accepted.


>
>>   drivers/pinctrl/pinconf-generic.c       |  105 +++++++++++++++++++++++++++++++
>>   include/linux/pinctrl/pinconf-generic.h |   52 +++++++++++++++
> I don't think those are the correct files for this code. Presumably
> there's no reason at all why a pinctrl driver that doesn't require
> CONFIG_GENERIC_PINCONF can't use these basic utility functions. Perhaps
> add a new pinctrl-utils file?

I thought generic implementation of parsing of dt is pinctrl-generic 
file and as these newly added APIs are require for the parsing the DT 
node, I added here.
I can move this to pinctrl-util.c/h also.



