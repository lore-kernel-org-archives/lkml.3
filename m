Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679AbaKRCRJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 21:17:09 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:21711 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbaKRCRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 21:17:06 -0500
Message-ID: <546AAC70.4070905@oracle.com>
Date: Mon, 17 Nov 2014 18:18:24 -0800
From: "santosh.shilimkar@oracle.com" <santosh.shilimkar@oracle.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Kevin Hilman <khilman@kernel.org>
CC: Grygorii Strashko <grygorii.strashko@ti.com>, ssantosh@kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, grant.likely@secretlab.ca,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH v4 1/2] ARM: keystone: pm: switch to use generic pm domains
References: <1415631557-22897-1-git-send-email-grygorii.strashko@ti.com> <1600093.60yAP0Qpua@wuerfel> <7h389h3aif.fsf@deeprootsystems.com> <1618855.DXsjWXLqau@wuerfel>
In-Reply-To: <1618855.DXsjWXLqau@wuerfel>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/14 12:37 PM, Arnd Bergmann wrote:
> On Monday 17 November 2014 11:14:16 Kevin Hilman wrote:
>>>>
>>>> So, The Keystone 2 Generic PM Controller is just a proxy PM layer here between
>>>> device and Generic clock manipulation PM callbacks.
>>>> It fills per-device clock list when device is attached to GPD and
>>>> ensures that all clocks from that list enabled/disabled when device is
>>>> started/stopped.
>>>
>>> The idea of such a generic power domain implementation sounds useful, but
>>> it has absolutely no business in platform specific code.
>>
>> Yes it does.  This isn't a generic power domain implementation, but
>> rather just the platform-specific glue that hooks up the clocks to the
>> right devices and power-domains so that the generic power-domain and
>> generic pm_clocks code does the right thing.
>
> How would you do this on an arm64 version of keystone then? With
> the current approach, you'd need to add a machine specific directory,
> and that seems completely pointless since this is not even about
> a hardware requirement.
>
The Keystone PM domain code actually doesn't have to be under machine
code. Infact my first patch I added that under drivers/bus/ and later
based on Kevin's suggestion moved under machine. That time the Keystone
64 bit arch point I couldn't bring up for other reasons.

But the code itself can be easily moved to drivers/power/ without
any issue if thats what is the concern here.

Regards,
Santosh
