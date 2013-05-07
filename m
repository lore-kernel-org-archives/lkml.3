Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236Ab3EGGzb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 02:55:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:29113 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753924Ab3EGGz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 02:55:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,627,1363158000"; 
   d="scan'208";a="333698604"
Message-ID: <5188A6A0.3040603@intel.com>
Date: Tue, 07 May 2013 10:00:48 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Ball <cjb@laptop.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "Westerberg, Mika" <mika.westerberg@intel.com>
Subject: Re: [PATCH 0/3] mmc: sdhci: support runtime PM for BYT SD cards
References: <1367831854-31952-1-git-send-email-adrian.hunter@intel.com> <CACRpkdYsMwAZSw9McHQE4VSsS7wUWLm+mtR1yLzdPCaQzDUo3A@mail.gmail.com>
In-Reply-To: <CACRpkdYsMwAZSw9McHQE4VSsS7wUWLm+mtR1yLzdPCaQzDUo3A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/13 22:27, Linus Walleij wrote:
> On Mon, May 6, 2013 at 11:17 AM, Adrian Hunter <adrian.hunter@intel.com> wrote:
> 
>> Here are 3 patches to support runtime PM for BYT SD cards
>>
>> Please note that these patches are dependent upon 2 gpio patches
>> that are in linux-next and linux-gpio but not the mmc tree.
>> Those patches are:
>>
>>         author  Mika Westerberg <mika.westerberg@linux.intel.com>       2013-04-03 10:56:54 (GMT)
>>         committer       Linus Walleij <linus.walleij@linaro.org>        2013-04-11 22:31:18 (GMT)
>>         commit  12028d2d216220618f76284af5f8ed510b11da55 (patch)
>>         gpiolib-acpi: introduce acpi_get_gpio_by_index() helper
>>
>>         author  Rafael J. Wysocki <rafael.j.wysocki@intel.com>  2013-04-09 13:57:25 (GMT)
>>         committer       Linus Walleij <linus.walleij@linaro.org>        2013-04-10 21:41:17 (GMT)
>>         commit  7fc7acb9a0b0ff3ffdf21818fe0735ebaf4fecb8 (patch)
>>         gpio / ACPI: Handle ACPI events in accordance with the spec
>>
>> I think those patches are queued for 3.10.
>>
>> cc: Linus Walleij <linus.walleij@linaro.org>
> 
> No they are currently not, and will as it looks right now *not* be in v3.10 due
> to a screwup from my side, and that screwup walking the ladder to
> Torvalds where it exploded. So he's not pulling the GPIO tree this merge
> window.
> 
> So just sit back and synchronize this for v3.11 (surely they can be taken
> through the GPIO tree if Chris gives his ACK on them).

3.11 is fine, but one of the patches:

	 [PATCH 1/3] mmc: sdhci: add ability to stay runtime-resumed if the card is powered up

really should be in the mmc tree.

It would be simpler if the above 2 ACPI GPIO patches made it to 3.10 or went via the mmc tree.
Adding Rafael in case he can still take them for 3.10.



