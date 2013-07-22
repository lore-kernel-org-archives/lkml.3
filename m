Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638Ab3GVOD4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 10:03:56 -0400
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:47767 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753868Ab3GVODy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 10:03:54 -0400
Message-ID: <51ED3BC3.40300@hurleysoftware.com>
Date: Mon, 22 Jul 2013 10:03:47 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        benjamin.tissoires@gmail.com, adlr@chromium.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 1/2] Revert "Revert "HID: Fix logitech-dj: missing Unifying
 device issue""
References: <1374153691-25100-1-git-send-email-nlopezcasad@logitech.com> <51E84FD1.4050400@hurleysoftware.com> <20130718220936.GA8025@xanatos> <51E87C1F.1090301@hurleysoftware.com> <51E94F7C.9090302@canonical.com> <51E9B025.8010803@hurleysoftware.com> <alpine.LNX.2.00.1307221342410.23128@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1307221342410.23128@pobox.suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2013 07:44 AM, Jiri Kosina wrote:
> On Fri, 19 Jul 2013, Peter Hurley wrote:
>
>>>> As far as getting printk output from a custom kernel, I think that may
>>>> be beyond the reporter's capability. Perhaps one of the Ubuntu devs
>>>> triaging this bug could provide a test kernel for the OP with those
>>>> options on.
>>>>
>>>> Joseph, would you be willing to do that?
>>>
>>> Sure thing.  I'll build a kernel and request that the bug reporter
>>> collect usbmon data.
>>
>> Thanks Joseph for building the test kernel and getting it to the reporter!
>>
>> Sarah,
>>
>> I've attached the dmesg capture supplied by the original reporter on
>> a 3.10 custom kernel w/ the kbuild options you requested.
>>
>> It seems as if your initial suspicion is correct:
>>
>> [   46.785490] xhci_hcd 0000:00:14.0: Endpoint 0x81 not halted, refusing to
>> reset.
>> [   46.785493] xhci_hcd 0000:00:14.0: Endpoint 0x82 not halted, refusing to
>> reset.
>> [   46.785496] xhci_hcd 0000:00:14.0: Endpoint 0x83 not halted, refusing to
>> reset.
>> [   46.785952] xhci_hcd 0000:00:14.0: Waiting for status stage event
>>
>> At this point, would you recommend proceeding with the workaround or
>> waiting for an xHCI bug fix?
>
> Thanks for your efforts.
>
> Seems like this might be a part of the picture, but not a complete one.
> Linus claims to have similar problem, but his receiver is not connected
> through xHCI (I got this as an off-list report, so can't really provide a
> pointer to ML archives).

Ah, ok. I wasn't aware of that. I'll assume then that the necessary
people have the complete picture.

Regards,
Peter Hurley


