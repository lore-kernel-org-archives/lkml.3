Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbaBNOAS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 09:00:18 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:46329 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752418AbaBNOAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 09:00:17 -0500
Message-ID: <52FE216C.8050403@hurleysoftware.com>
Date: Fri, 14 Feb 2014 09:00:12 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Jeff Chua <jeff.chua.linux@gmail.com>
CC: Takashi Iwai <tiwai@suse.de>, lkml <linux-kernel@vger.kernel.org>,
        Dave Airlie <airlied@redhat.com>
Subject: Re: Lenovo X240 (haswell) suspend-to-ram hangs on 3-14.0-rc2
References: <CAAJw_ZvX2AfS8COiNdN9gi_1xJ4L_vL=ROCzcLL3u0h51kuX3Q@mail.gmail.com>	<52FCFD92.7040109@hurleysoftware.com>	<s5hiosi3osp.wl%tiwai@suse.de>	<CAAJw_ZsoO=kd6cVM3HYrkim5K0RKrnDXYGgodNNQmHVYs19a8A@mail.gmail.com> <s5hha8123vu.wl%tiwai@suse.de>
In-Reply-To: <s5hha8123vu.wl%tiwai@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2014 08:57 AM, Takashi Iwai wrote:
> At Fri, 14 Feb 2014 21:46:25 +0800,
> Jeff Chua wrote:
>>
>> On Fri, Feb 14, 2014 at 1:28 AM, Takashi Iwai <tiwai@suse.de> wrote:
>>> At Thu, 13 Feb 2014 12:14:58 -0500,  Peter Hurley wrote:
>>> Apparently there's no maintainer but I've cc'ed people who might
>>> have a clue about this.
>>
>> Peter ... thanks for pointer.
>>
>>> On Fri, Feb 14, 2014 at 1:28 AM, Takashi Iwai <tiwai@suse.de> wrote:
>>> Is it a Intel+Nvidia hybrid?  If so, does it happen even with
>>> CONFIG_VGA_SWITCHEROO=n?
>>
>> It's not Intel+Nvidia. It's Intel Core i7-4600U 2.1 GHz, Intel HD Graphics 4400.
>
> OK.  Then it's a different thing as I expected.
>
> The other possible change in hda_intel.c is the enablement of runtime
> PM for Panther Point.  But it's been working for other chips, so
> wondering why it hits anything.  In anyway, please give the full
> Oops messages not only the stack trace.

Also, please attach your config and dmesg.

>> I checked my config. CONFIG_VGA_SWITCHEROO is not set.
>>
>> On Fri, Feb 14, 2014 at 5:21 AM, Theodore Ts'o <tytso@mit.edu> wrote:
>>> For what it's worth, I have a the X240's bigger brother --- a T540p
>>> (with intel graphics and the 3k panel) running 3.14-rc2, and
>>> suspend-to-ram is working without any problems on my laptop.
>>
>> Interesting. Perhaps it's the USB options. I had these set to "y"
>>
>> CONFIG_USB_XHCI_HCD=y
>> CONFIG_USB_EHCI_HCD=y
>> CONFIG_USB_EHCI_ROOT_HUB_TT=y
>> CONFIG_USB_EHCI_TT_NEWSCHED=y
>> CONFIG_USB_EHCI_PCI=y
>>
>> Again, These same config works find on X230. It's very strange. The
>> same hard disk (SSD) can suspend-to-ram on the X230 but not on the
>> X240. The X230 has i7-3520M vs X240 i7-4600U.
>
> Any difference in the sound hardware, i.e. PCI controller and codec
> chips?
>
>> I've even tried with all the USB set to "n" and still couldn't S2D.
>
> Do you mean S2R?  I thought the bug is about S3?


