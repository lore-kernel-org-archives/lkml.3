Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475AbaKHGRf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 01:17:35 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:47518 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125AbaKHGRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 01:17:33 -0500
Message-ID: <545DB57B.7040802@wwwdotorg.org>
Date: Fri, 07 Nov 2014 23:17:31 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Gordon Hollingworth <gordon@holliweb.co.uk>
CC: Noralf Tronnes <notro@tronnes.org>,
        Matthias Klein <matthias.klein@linux.com>,
        "linux-rpi-kernel@lists.infradead.org" 
	<linux-rpi-kernel@lists.infradead.org>,
        lee@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] ARM: bcm2835: add device tree for Raspberry Pi model
 B+
References: <1415231123-920-1-git-send-email-matthias.klein@linux.com>	<545BCDBE.9020200@tronnes.org>	<545C4904.1010402@wwwdotorg.org>	<545CF15A.1050601@tronnes.org>	<CAE8Q9tBDxq9W=Vh0LRCRNR+Dj+5PrWyzK+GBdMDM=1kq84mFTA@mail.gmail.com> <CAE8Q9tC7jowebEF3OgRu+qHemV7v_d3o6ZbCPQMbL8_7LR4Ewg@mail.gmail.com>
In-Reply-To: <CAE8Q9tC7jowebEF3OgRu+qHemV7v_d3o6ZbCPQMbL8_7LR4Ewg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2014 10:12 AM, Gordon Hollingworth wrote:
> Resend: HTML less...
> On 7 November 2014 17:07, Gordon Hollingworth <gordon@holliweb.co.uk> wrote:
>> On 7 November 2014 16:20, Noralf Tronnes <notro@tronnes.org> wrote:
...
>>> From the HAT specification:
>>> GPIO pins ID_SC and ID_SD (GPIO0 and GPIO1) are reserved for use solely
>>> for board detection / identification. The only allowed connections to
>>> the ID_ pins are an ID EEPROM plus 3.9K pull up resistors. Do not connect
>>> anything else to these pins!
>>>
>>> Ref:
>>> https://github.com/raspberrypi/hats/blob/master/designguide.md#gpio-requirements
>>>
>>> I asked in the forum if I could use an app for writing to the eeprom to
>>> change things like display rotation in the DT fragment, but was told that this
>>> was a no-no. i2c0 is also used together with the camera port, which is then
>>> controlled by the firmware.
>>
>> The idea with the HAT specification is to provide a mechanism for hardware
>> developers to add their drivers and configuration in such a way as to avoid
>> 'special' kernel builds for particular bits of hardware (this was a problem
>> with a number of DAC add on boards for the Pi)

Have you considered using the (recently merged upstream) DT overlay
mechanism instead? In this case, the board EEPROM would simply provide a
unique ID for the board. Linux would obtain this ID somehow (perhaps
directly reading the EEPROM on boot, or perhaps having some special DT
node indicating which device was present if only the VC firmware can
access the EEPROM). The ID then gets used to look up a DT overlay file
that the kernel loads and merges into its DT at run-time. The benefit
here is that the DT overlay is a file in the filesystem, and can be
easily modified or replaced to fix issues, especially when first
developing that DT for a new HAT. This is all based on the way the
BeagleBone Black handles its capes. Having RPi work in a standard way
that's also used on other boards leverages people's knowledge/experience
across different HW stacks. Standards are good!

If I want to use U-Boot as a bootloader on the Pi, is there a VC
firmware mailbox message that the firmware can use to read the content
of the EEPROM (or the VC firmware's cached copy of it?) Or, must U-Boot
be modified to accept a DT, extract information from it, and then modify
the DT it subsequently passes to the kernel based on the DT it was passed?
