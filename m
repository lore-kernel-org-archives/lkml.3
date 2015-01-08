Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932177AbbAIAA5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 19:00:57 -0500
Received: from us-mx2.synaptics.com ([192.147.44.131]:21119 "EHLO
	us-mx1.synaptics.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755956AbbAIAA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 19:00:56 -0500
X-PGP-Universal: processed;
	by securemail.synaptics.com on Thu, 08 Jan 2015 16:28:22 -0800
Message-ID: <54AF19BE.9010506@synaptics.com>
Date: Thu, 8 Jan 2015 15:58:54 -0800
From: Andrew Duggan <aduggan@synaptics.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Gabriele Mazzotta <gabriele.mzt@gmail.com>
CC: Mika Westerberg <mika.westerberg@linux.intel.com>,
        <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <benjamin.tissoires@redhat.com>, <jkosina@suse.cz>
Subject: Re: NULL pointer dereference in i2c-hid
References: <31518562.V5Oyo0POsI@xps13> <2094646.ov2KaAkedO@xps13> <548B3E32.2050503@synaptics.com> <1877487.FqOELR9dBu@xps13>
In-Reply-To: <1877487.FqOELR9dBu@xps13>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.4.10.98]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/24/2014 03:53 PM, Gabriele Mazzotta wrote:
[...snip...]
>>>> Also, if you can get the firmware id from your touchpad that would also
>>>> be useful.
>>>>
>>>> $ sudo ./rmihidtool -f /dev/hidraw0
>>> firmware id: 1522295
>> Thanks, I will see if I can get any additional information on this.
>>
>> Andrew
> Hi,
>
> I think I found the source of the problem.
>
> $ ./rmihidtool /dev/hidraw1 -r 0x50 1
> 0x01  #PalmDetect Interrupt Enable, right?
Yes, 0x50 does appear to be the address of the palm detect interrupt 
enable register.
> $ ./rmihidtool /dev/hidraw1 -w 0x50 0  #Disable PalmDetect Interrupt
>
> It makes more sense now that widths greater than 12 trigger the bug.
That is weird behavior and I haven't seen anything like that before. I 
will file a bug to see if firmware has any idea why this is happening.
>
> Gabriele
>
Andrew
