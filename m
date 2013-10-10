Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599Ab3JJMIt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 08:08:49 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:52811 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753980Ab3JJMIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 08:08:47 -0400
Message-ID: <525698CC.3060406@ti.com>
Date: Thu, 10 Oct 2013 07:08:44 -0500
From: Dan Murphy <dmurphy@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Ming Lei <tom.leiming@gmail.com>
CC: Steve Glendinning <steve.glendinning@shawell.net>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>, <mugunthanvnm@ti.com>
Subject: Re: [PATCH] usbnet: smsc95xx: Add device tree input for MAC address
References: <1380911156-14112-1-git-send-email-dmurphy@ti.com>	<CACVXFVOVMvP=3y9h2Jrqn2sBQdKOZtrhQDAFYkdHKXFgQj=d0Q@mail.gmail.com>	<52519E7A.40804@ti.com> <CACVXFVNAB3VnmdoP_LGJsBjQ17j1aoqKMsBE7LRt65OqROeRUQ@mail.gmail.com>
In-Reply-To: <CACVXFVNAB3VnmdoP_LGJsBjQ17j1aoqKMsBE7LRt65OqROeRUQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ming

On 10/07/2013 06:42 AM, Ming Lei wrote:
> On Mon, Oct 7, 2013 at 1:31 AM, Dan Murphy <dmurphy@ti.com> wrote:
>> On 10/06/2013 10:05 AM, Ming Lei wrote:
>>> On Sat, Oct 5, 2013 at 2:25 AM, Dan Murphy <dmurphy@ti.com> wrote:
>>>> If the smsc95xx does not have a valid MAC address stored within
>>>> the eeprom then a random number is generated.  The MAC can also
>>>> be set by uBoot but the smsc95xx does not have a way to read this.
>>>>
>>>> Create the binding for the smsc95xx so that uBoot can set the MAC
>>>> and the code can retrieve the MAC from the modified DTB file.
>>> Suppose there are two smsc95xx usbnet devices connected to usb bus, and
>>> one is built-in, another is hotplug device, can your patch handle the situation
>>> correctly?
>> Look at this line in the patch below
>>
>> sprintf(of_name, "%s%i", SMSC95XX_OF_NAME, dev->udev->dev.id);
>>
>> I am appending the dev ID of the device to the of_name here.  As long as init_mac_address is called, the dev.id and the uBoot
>> entry match then yes.
> Currently, non-root-hub usb device is created and added into usb bus without
> any platform(device tree) knowledge, so you can't expect the match here.
>
> Also not mention the two smsc95xx devices may attach to two different
> usb host controllers(buses).
>
> Thanks,

You are correct I don't expect a match for PnP devices only devices that are hard wired.

After thinking of it I should move the OF code below the EEPROM code as the EEPROM should take preference over the DT code.

I will need to post V2 for that.

Dan

-- 
------------------
Dan Murphy

