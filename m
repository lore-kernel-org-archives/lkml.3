Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320AbaKPKUn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 05:20:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35111 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754676AbaKPKUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 05:20:39 -0500
Message-ID: <54687A72.6060208@suse.de>
Date: Sun, 16 Nov 2014 11:20:34 +0100
From: =?windows-1252?Q?Andreas_F=E4rber?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Ankit Jindal <ankit.jindal@linaro.org>,
        Tushar Jagad <tushar.jagad@linaro.org>
CC: Anup Patel <anup@brainfault.org>, devicetree@vger.kernel.org,
        Varka Bhadram <varkabhadram@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>, "Hans J. Koch" <hjk@hansjkoch.de>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        patches <patches@apm.com>, Rob Herring <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 5/6] Documentation: dt-bindings: Add binding info for
 X-Gene QMTM UIO driver
References: <1415864722-2800-1-git-send-email-ankit.jindal@linaro.org> <1415864722-2800-6-git-send-email-ankit.jindal@linaro.org> <CAAhSdy2L5fPdk97wTVy++B4LcJP_s-r-BF18hg6J9Shfg_t1XQ@mail.gmail.com>
In-Reply-To: <CAAhSdy2L5fPdk97wTVy++B4LcJP_s-r-BF18hg6J9Shfg_t1XQ@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 16.11.2014 um 05:26 schrieb Anup Patel:
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

Trailing semicolon is missing.

>> +       };
>> +
>> +       qmtm1clk: qmtmclk@1f20c000 {
>> +               compatible = "apm,xgene-device-clock";
>> +               clock-output-names = "qmtm1clk";
>> +               status = "ok"

"okay" and missing semicolon, but you could probably drop the status
property here.

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
> 
>> +               clocks = <&qmtm1clk 0>;
>> +               num-queues = <0x400>;
>> +               devid = <1>;
>> +       };
>> +
>> +       /* Board-specific peripheral configurations */
>> +       &qmtm1_uio {
>> +               status = "ok";

"okay" as canonical spelling.

>> +       };

Regards,
Andreas

-- 
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 21284 AG Nürnberg
