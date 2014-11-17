Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319AbaKQKUY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 05:20:24 -0500
Received: from mail-ig0-f176.google.com ([209.85.213.176]:55515 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbaKQKUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 05:20:23 -0500
MIME-Version: 1.0
In-Reply-To: <CAAhSdy2L5fPdk97wTVy++B4LcJP_s-r-BF18hg6J9Shfg_t1XQ@mail.gmail.com>
References: <1415864722-2800-1-git-send-email-ankit.jindal@linaro.org>
 <1415864722-2800-6-git-send-email-ankit.jindal@linaro.org> <CAAhSdy2L5fPdk97wTVy++B4LcJP_s-r-BF18hg6J9Shfg_t1XQ@mail.gmail.com>
From: Ankit Jindal <ankit.jindal@linaro.org>
Date: Mon, 17 Nov 2014 15:50:02 +0530
Message-ID: <CAPTm99XRXW=eyoUQcjKuyOaUWzQaH0epGLTMn8MNgA-U4=2E7w@mail.gmail.com>
Subject: Re: [PATCH v4 5/6] Documentation: dt-bindings: Add binding info for
 X-Gene QMTM UIO driver
To: Anup Patel <anup@brainfault.org>
Cc: "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches <patches@apm.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Rob Herring <robh+dt@kernel.org>,
        Tushar Jagad <tushar.jagad@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Kumar Gala <galak@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 November 2014 09:56, Anup Patel <anup@brainfault.org> wrote:
> On Thu, Nov 13, 2014 at 1:15 PM, Ankit Jindal <ankit.jindal@linaro.org> wrote:
>> This patch adds device tree binding documentation for
>> X-Gene QMTM UIO driver.
>>
>> Signed-off-by: Ankit Jindal <ankit.jindal@linaro.org>
>> Signed-off-by: Tushar Jagad <tushar.jagad@linaro.org>
>> ---
>>  .../devicetree/bindings/uio/uio_xgene_qmtm.txt     |   51 ++++++++++++++++++++
>>  1 file changed, 51 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/uio/uio_xgene_qmtm.txt
>>
>> diff --git a/Documentation/devicetree/bindings/uio/uio_xgene_qmtm.txt b/Documentation/devicetree/bindings/uio/uio_xgene_qmtm.txt
>> new file mode 100644
>> index 0000000..ed85bc6
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/uio/uio_xgene_qmtm.txt
>> @@ -0,0 +1,51 @@
>> +APM X-Gene QMTM nodes
>> +
>> +The Applied Micro X-Gene SOC has on-chip QMTM (Queue manager
>> +and Traffic manager). It is a device for managing hardware queues.
>> +It also implements QoS among hardware queues hence term "traffic"
>> +manager is present in its name.
>> +
>> +Required properties:
>> +- compatible: Should be "apm,xgene-qmtm"
>> +- reg: Address and length of the register set for the device. It contains the
>> +  information of registers in the same order as described by reg-names.
>> +- reg-names: Should contain the register set names
>> +  - "csr": QMTM control and status register address space.
>> +  - "fabric": QMTM memory mapped access to queue states.
>> +- qpool-memory: Points to the phandle of the node defining memory location for
>> +        creating QMTM queues. This must point to the reserved-memory node
>> +        (as-per reserved memory bindings). It is expected that size and
>> +        location of qpool memory will be configurable via bootloader.
>> +- clocks: Reference to the clock entry.
>> +- num-queues: Number of queues under this QMTM device.
>> +- devid: QMTM identification number for the system having multiple QMTM devices.
>> +        This is used to form a unique id (a tuple of queue number and
>> +        device id) for the queues belonging to this device.
>> +
>> +Example:
>> +       qmtm1_uio_qpool: qmtm1_uio_qpool {
>> +               reg = <0x0 0x0 0x0 0x0>
>> +       };
>> +
>> +       qmtm1clk: qmtmclk@1f20c000 {
>> +               compatible = "apm,xgene-device-clock";
>> +               clock-output-names = "qmtm1clk";
>> +               status = "ok";
>> +       };
>> +
>> +       qmtm1_uio: qmtm_uio@1f200000 {
>> +               compatible = "apm,xgene-qmtm";
>> +               status = "disabled";
>> +               reg = <0x0 0x1f200000 0x0 0x10000>,
>> +                     <0x0 0x1b000000 0x0 0x400000>;
>> +               reg-names = "csr", "fabric";
>> +               qpool = <&qmtm1_uio_qpool>;
>
> Small typo, this should be qpool-memory = <...>;

Thanks, I will fix this in next revision.

-Ankit
>
>> +               clocks = <&qmtm1clk 0>;
>> +               num-queues = <0x400>;
>> +               devid = <1>;
>> +       };
>> +
>> +       /* Board-specific peripheral configurations */
>> +       &qmtm1_uio {
>> +               status = "ok";
>> +       };
>> --
>> 1.7.9.5
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
