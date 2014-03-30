Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157AbaC3I4U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 04:56:20 -0400
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:17518 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbaC3I4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 04:56:18 -0400
X-IronPort-AV: E=Sophos;i="4.97,759,1389772800"; 
   d="scan'208";a="21764857"
Message-ID: <5337DC2E.5040000@broadcom.com>
Date: Sun, 30 Mar 2014 10:56:14 +0200
From: Arend van Spriel <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.24) Gecko/20111103 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: Chen-Yu Tsai <wens@csie.org>
CC: Tomasz Figa <tomasz.figa@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>
Subject: Re: [RFC] dt: bindings: add bindings for Broadcom bcm43xx sdio devices
References: <1392059868-8782-1-git-send-email-arend@broadcom.com> <52FC8CB3.4090305@gmail.com> <CAGb2v67za+5yW3RE0pwBWk-NdTUSm-JkKE+j9NLjbBkE_Fc1hQ@mail.gmail.com>
In-Reply-To: <CAGb2v67za+5yW3RE0pwBWk-NdTUSm-JkKE+j9NLjbBkE_Fc1hQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/14 10:28, Chen-Yu Tsai wrote:
> Hi,
>
> On Thu, Feb 13, 2014 at 5:13 PM, Tomasz Figa<tomasz.figa@gmail.com>  wrote:
>> Hi Arend,
>>
>>
>> On 10.02.2014 20:17, Arend van Spriel wrote:

[...]

>>> +
>>> +Example:
>>> +
>>> +mmc3: mmc@01c20000 {
>>> +       pinctrl-0 =<&mmc3_pins>;
>>> +       pinctrl-1 =<&wifi_host_wake>;
>>
>>
>> WLAN_HOST_WAKE pin (aka the OOB interrupt) is specific to the WLAN chip, so
>> this should be rather configured in a pinctrl state of the WLAN chip itself.

Hi Chen-Yu,

picking up this thread.

> AFAIK, the pinctrl in tied to the device node, and is selected when the device
> is registered. The MMC subsystem currently does not register child nodes, so
> this would be useless.

So if MMC does not register child nodes, brcmfmac will not be probed 
with of_node set? Have there been patches submitted for this in mmc 
subsystem recently.

> brcmfmac actually has to walk the whole DT to find the node with the right
> compatible.

Is it just me or should this be avoided? What if there are multiple entries?

Regards,
Arend
