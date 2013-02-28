Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295Ab3B1A1i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 19:27:38 -0500
Received: from mga03.intel.com ([143.182.124.21]:55797 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813Ab3B1A1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 19:27:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,752,1355126400"; 
   d="scan'208";a="262369471"
Message-ID: <512EA39A.7080205@intel.com>
Date: Thu, 28 Feb 2013 08:23:54 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-usb@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org,
        Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [Resend][PATCH] ACPI / glue: Drop .find_bridge() callback from
 struct acpi_bus_type
References: <2612891.I2roH54cPk@vostro.rjw.lan> <20130227222032.GA28616@kroah.com> <CAE9FiQVEBZy+HP+tthD_C_gJ_6v2be-pGCD0A4TE0z+c8MHXtA@mail.gmail.com>
In-Reply-To: <CAE9FiQVEBZy+HP+tthD_C_gJ_6v2be-pGCD0A4TE0z+c8MHXtA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年02月28日 07:31, Yinghai Lu wrote:
> On Wed, Feb 27, 2013 at 2:20 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>> On Wed, Feb 27, 2013 at 11:06:52PM +0100, Rafael J. Wysocki wrote:
>>> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>>
>>> After PCI has stopped using the .find_bridge() callback in
>>> struct acpi_bus_type, the only remaining users of it are SATA and
>>> USB.  However, SATA only pretends to be a user, because it points
>>> that callback to a stub always returning -ENODEV, and USB uses it
>>> incorrectly, because as a result of the way it is used by USB every
>>> device in the system that doesn't have a bus type or parent is
>>> passed to usb_acpi_find_device() for inspection.
>>>
>>> What USB actually needs, though, is to call usb_acpi_find_device()
>>> for USB ports that don't have a bus type defined, but have
>>> usb_port_device_type as their device type.
>>
>> Ick, that's not good.  Can you have the original creator of that code
>> (someone else from Intel, I can't remember at the moment), fix that up
>> properly and send me patches?
> 
> [Add To: Lan Tianyu <tianyu.lan@intel.com>]
Ok. I will fix it later.
> 
>>
>>> Please let me know if there are any objections.
> 
> I still prefer to ask USB to add bus_type instead at first.
> 
> Thanks
> 
> Yinghai
> 


-- 
Best regards
Tianyu Lan
