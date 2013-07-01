Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134Ab3GAStH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 14:49:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60054 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089Ab3GAStF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 14:49:05 -0400
Message-ID: <51D1CF18.80201@canonical.com>
Date: Mon, 01 Jul 2013 14:48:56 -0400
From: Joseph Salisbury <joseph.salisbury@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: udknight@gmail.com, jslaby@suse.cz, alan@linux.intel.com,
        matts@commtech-fastcom.com, wfp5p@virginia.edu, tklauser@distanz.ch,
        linux-serial@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [v3.9] [v3.10] [Regression]  serial: 8250_pci: add support for
 another kind of NetMos Technology PCI 9835 Multi-I/O Controller
References: <51D1AAF5.5050004@canonical.com> <20130701162751.GA18834@kroah.com>
In-Reply-To: <20130701162751.GA18834@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2013 12:27 PM, Greg KH wrote:
> On Mon, Jul 01, 2013 at 12:14:45PM -0400, Joseph Salisbury wrote:
>> Hi Wang,
>>
>> A bug was opened against the Ubuntu kernel[0].  After a kernel bisect,
>> it was found that reverting the following commit resolved this bug:
>>
>> commit 8d2f8cd424ca0b99001f3ff4f5db87c4e525f366
>> Author: Wang YanQing <udknight@gmail.com>
>> Date:   Fri Mar 1 11:47:20 2013 +0800
>>
>>     serial: 8250_pci: add support for another kind of NetMos Technology
>> PCI 9835 Multi-I/O Controller
>>
>>
>> The regression was introduced as of v3.9-rc3 and still exists in the
>> current Mainline tree.  It was also propagated to the stable trees.
>>
>> The patch causes the device to use the serial module instead of
>> parport_serial.  Maybe the the quirk in ~drivers/pci/quirks.c
>> quirk_netmos() needs to be modified?
>>
>> I see that you are the author of this patch, so I wanted to run this by
>> you.  I was thinking of requesting a revert, but I wanted to get your
>> feedback first.
> You missed the conversation we had about this already this weekend :)
>
> The offending patch has already been reverted and will propagate to the
> stable trees soon.
>
> thanks,
>
> greg k-h
Good news.  Thanks for the help, Greg!
