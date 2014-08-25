Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933408AbaHYTGg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 15:06:36 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:47625 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932253AbaHYTGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 15:06:34 -0400
Message-ID: <53FB8952.9080404@wwwdotorg.org>
Date: Mon, 25 Aug 2014 13:06:58 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Andrew Bresticker <abrestic@chromium.org>,
        Thierry Reding <thierry.reding@gmail.com>, linux-tegra@vger.kernel.org
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, Arnd Bergmann <arnd@arndb.de>,
        Kishon Vijay Abraham I <kishon@ti.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH v2 1/9] of: Add NVIDIA Tegra XUSB mailbox binding
References: <1408381705-3623-1-git-send-email-abrestic@chromium.org> <1408381705-3623-2-git-send-email-abrestic@chromium.org> <53FB84F7.8030509@wwwdotorg.org>
In-Reply-To: <53FB84F7.8030509@wwwdotorg.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/2014 12:48 PM, Stephen Warren wrote:
> On 08/18/2014 11:08 AM, Andrew Bresticker wrote:
>> Add device-tree bindings for the Tegra XUSB mailbox which will be used
>> for communication between the Tegra xHCI controller's firmware and the
>> host processor.
>
>> diff --git
>> a/Documentation/devicetree/bindings/mailbox/nvidia,tegra124-xusb-mbox.txt
>> b/Documentation/devicetree/bindings/mailbox/nvidia,tegra124-xusb-mbox.txt
>
>> +NVIDIA Tegra XUSB mailbox
>> +=========================
>> +
>> +The Tegra XUSB mailbox is used by the Tegra xHCI controller's
>> firmware to
>> +communicate requests to the host and PHY drivers.
>> +
>> +Required properties:
>> +--------------------
>> + - compatible: Should be "nvidia,tegra124-xusb-mbox".
>> + - reg: Address and length of the XUSB FPCI registers.
>> + - interrupts: XUSB mailbox interrupt.
>> + - #mbox-cells: Should be 1.  The specifier is the index of the
>> mailbox to
>> +   reference.  See <dt-bindings/mailbox/tegra-xusb-mailbox.h> for the
>> list
>> +   of valid values.
>
> Is there a common mailbox binding somewhere? I couldn't find one. While
> the text above specifies the value for #mbox-cells, it doesn't specify
> the details of what the property is used for (i.e. there's no
> documentation of the consumer-side of this property, for parsing the
> mboxes property). Typically, that would be part of a subsystem's common
> binding document, and that document would be referenced here.

Ah, I see it's still being developed. I found it at:
http://lkml.iu.edu/hypermail/linux/kernel/1408.0/00201.html

It would be good to mention that the semantics of this property are 
defined by ../mailbox/mailbox.txt.
