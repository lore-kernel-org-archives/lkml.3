Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594AbaLNDJW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 22:09:22 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:57104 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbaLNDJU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 22:09:20 -0500
MIME-Version: 1.0
In-Reply-To: <A2CA0424C0A6F04399FB9E1CD98E03048450126C@US01WEMBX2.internal.synopsys.com>
References: <CALHRZuotPpSoX9bnQin=93k0Hr7tEp_HZDaaBvfKaPfmoi_EBQ@mail.gmail.com>
	<A2CA0424C0A6F04399FB9E1CD98E03048450126C@US01WEMBX2.internal.synopsys.com>
Date: Sun, 14 Dec 2014 08:39:18 +0530
Message-ID: <CALHRZupFbTxTn9KiUCmvcmgYxUUcNfvAoMqOq=Drq0gZ+H246w@mail.gmail.com>
Subject: Re: query on DWC3
From: sundeep subbaraya <sundeep.lkml@gmail.com>
To: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
Cc: "balbi@ti.com" <balbi@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

As per my understanding, for BULK OUT we do queue a request with 512
bytes length since we do not
know the length of the transfer Host is going to send. For Control OUT
we know the length in wLength of
Setup packet, hence I assumed there is no difference in programming
model of Control IN and OUT.
Now it is clear for me. Thanks for the clarification :)

Sundeep

On Sun, Dec 14, 2014 at 5:21 AM, Paul Zimmerman
<Paul.Zimmerman@synopsys.com> wrote:
>> From: linux-usb-owner@vger.kernel.org [mailto:linux-usb-owner@vger.kernel.org] On Behalf Of sundeep subbaraya
>> Sent: Friday, December 12, 2014 9:13 PM
>>
>> Hi Felipe,
>>
>> In DWC3 driver, for three stage Control OUT transfer there is a check:
>>
>>    else if (!IS_ALIGNED(req->request.length, dep->endpoint.maxpacket)
>>
>>              && (dep->number == 0)) {.
>>     }
>>
>> I understand that we check for alignment of sizes and if not we
>> prepare trb with maxpacket and enable interrupt on short packet. In
>> databook I could not find anything related to this, it talks only
>> about addresses should be aligned. In Control transfer programming
>> model there is no difference between Control OUT or IN transfer, if
>> three stage transfer - prepare trb with length wLength. Initially I
>> followed this and not able to receive data on EP0 OUT.:( .After adding
>> the above check it is working. Please help me to understand why we do
>> this?
>
> Hi Sundeep,
>
> Please see section 8.2.3.3 "Buffer Size Rules and Zero-Length Packets"
> in the databook:
>
>         For OUT endpoints, the following rules apply:
>
>         - The total size of a Buffer Descriptor must be a multiple of
>           MaxPacketSize
>
> The wording may be a little confusing, it actually means that the size
> of the data buffer for OUT endpoints must be a multiple of MaxPacketSize.
> Section 8.2.5 states it more clearly:
>
>         - An OUT transfer’s transfer size (Total TRB buffer allocation)
>           must be a multiple of MaxPacketSize even if software is expecting
>         a fixed non-multiple of MaxPacketSize transfer from the Host.
>
> This rule applies to all OUT endpoint types, including Control endpoints.
>
> --
> Paul
>
