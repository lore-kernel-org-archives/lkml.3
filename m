Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759022AbaLLAqm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 19:46:42 -0500
Received: from senator.holtmann.net ([87.106.208.187]:33972 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbaLLAql convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 19:46:41 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: [PATCH 2/3] TTY: add slave driver to power-on device via a regulator.
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20141211225847.GB11666@earth.universe>
Date: Fri, 12 Dec 2014 01:46:33 +0100
Cc: NeilBrown <neilb@suse.de>, Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Rutland <mark.rutland@arm.com>, Jiri Slaby <jslaby@suse.cz>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <3884A980-C9EE-42A2-8D23-DF65FEC61DD2@holtmann.org>
References: <20141211214801.4127.93914.stgit@notabene.brown> <20141211215944.4127.4186.stgit@notabene.brown> <20141211225847.GB11666@earth.universe>
To: Sebastian Reichel <sre@kernel.org>
X-Mailer: Apple Mail (2.1993)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian,

>> diff --git a/Documentation/devicetree/bindings/serial/slave-reg.txt b/Documentation/devicetree/bindings/serial/slave-reg.txt
>> new file mode 100644
>> index 000000000000..7896bce8dfe4
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/serial/slave-reg.txt
>> @@ -0,0 +1,18 @@
>> +Regulator powered UART-attached device
>> +
>> +Required properties:
>> +- compatible: "tty,regulator"
>> +- vdd-supply: regulator to power the device
>> +
>> +
>> +This is listed as a child node of a UART.  When the
>> +UART is opened, the device is powered.
>> +
>> +Example:
>> +
>> +&uart1 {
>> +	bluetooth {
>> +		compatible = "tty,regulator";
>> +		vdd-supply = <&vaux4>;
>> +	};
>> +};
> 
> NACK. The compatible value should describe the connected device. You
> did not connect a regulator, but a bluetooth chip! DT should look
> like this:
> 
> &uart1 {
>    bluetooth {
>        compatible = "vendor,bluetooth-chip";
>        vdd-supply = <&vaux4>;
>    };
> };
> 
> I think it would be ok to use your generic driver to handle the
> specific compatible value, though.
> 
> Having the proper compatible value means, that there can be a more
> specific driver later, that other operating systems can expose the
> device as some kind of /dev/bluetooth instead of /dev/ttyXY, that
> userspace is able to know there is a bluetooth device connected to
> /dev/ttyXY by parsing the DT and results in easier-to-understand
> DTS.

I think that is up to udev to be able to make this a nice device node. However the device node name is pretty much irrelevant. What you want is enough meta data to tell that there is Bluetooth chip behind this TTY. From a Bluetooth stack perspective only hciattach needs to be run to get the N_HCI line discipline up and running for that chip.

However what would be interesting for hciattach would be a possibility to expose the Bluetooth manufacturer. Since the init routine is different for each manufacturer. So if that could be encoded in the DT, then that would be certainly helpful.

Regards

Marcel

