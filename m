Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606AbaDNWPZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 18:15:25 -0400
Received: from exprod5og110.obsmtp.com ([64.18.0.20]:51300 "HELO
	exprod5og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753164AbaDNWPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 18:15:22 -0400
MIME-Version: 1.0
In-Reply-To: <534BDD6F.2070903@codethink.co.uk>
References: <1397271984-23405-1-git-send-email-isubramanian@apm.com>
	<1397271984-23405-3-git-send-email-isubramanian@apm.com>
	<534BDD6F.2070903@codethink.co.uk>
Date: Mon, 14 Apr 2014 15:15:19 -0700
Message-ID: <CAKh23FkRJAqS7+5m+0k1E8gx3T23xsBfq8bw=847MR-uJxZvJQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] Documentation: dts: Add bindings for APM X-Gene
 SoC ethernet driver
From: Iyappan Subramanian <isubramanian@apm.com>
To: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "jcm@redhat.com" <jcm@redhat.com>, patches <patches@apm.com>,
        Ravi Patel <rapatel@apm.com>, Keyur Chudgar <kchudgar@apm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

Thanks for the review comments. Please find my responses inline.

Thanks,
Iyappan

On Mon, Apr 14, 2014 at 6:06 AM, Ben Dooks <ben.dooks@codethink.co.uk> wrote:
> On 12/04/14 04:06, Iyappan Subramanian wrote:
>>
>> This patch adds documentation for APM X-Gene SoC ethernet DTS binding.
>>
>> Signed-off-by: Iyappan Subramanian <isubramanian@apm.com>
>> Signed-off-by: Ravi Patel <rapatel@apm.com>
>> Signed-off-by: Keyur Chudgar <kchudgar@apm.com>
>> ---
>>   .../devicetree/bindings/net/apm-xgene-enet.txt     |   46
>> ++++++++++++++++++++
>>   1 file changed, 46 insertions(+)
>>   create mode 100644
>> Documentation/devicetree/bindings/net/apm-xgene-enet.txt
>>
>> diff --git a/Documentation/devicetree/bindings/net/apm-xgene-enet.txt
>> b/Documentation/devicetree/bindings/net/apm-xgene-enet.txt
>> new file mode 100644
>> index 0000000..0c983e8
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/net/apm-xgene-enet.txt
>> @@ -0,0 +1,46 @@
>> +APM X-Gene SoC Ethernet nodes
>> +
>> +Ethernet nodes are defined to describe on-chip ethernet interfaces in
>> +APM X-Gene SoC.
>> +
>> +Required properties:
>> +- compatible           : Should be "apm,xgene-enet"
>> +- reg                  : First resource is the ethernet base register set
>> +                         Second resource is the ring base register set
>> +                         Third resource is the ring command register set
>> +- interrupts           : Ethernet main interrupt
>> +- clocks               : Reference to the clock entry.
>> +- local-mac-address    : Ethernet MAC address.
>> +- phy-addr             : Ethernet MII phy address.
>> +- phy-mode             : Ethernet MII mode.
>> +
>> +Optional properties:
>> +- status               : Should be "ok" or "disabled" for
>> enabled/disabled.
>> +                         Default is "ok".
>> +
>> +Example:
>> +       menetclk: menetclk {
>> +               compatible = "apm,xgene-device-clock";
>> +               clock-output-names = "menetclk";
>> +               status = "ok";
>> +       };
>> +
>> +       menet: ethernet@17020000 {
>> +               compatible = "apm,xgene-enet";
>> +               status = "disabled";
>> +               reg = <0x0 0x17020000 0x0 0xd100>,
>> +                     <0x0 0X17030000 0x0 0X400>,
>> +                     <0x0 0X10000000 0x0 0X200>;
>> +               interrupts = <0x0 0x3c 0x4>;
>> +               clocks = <&menetclk 0>;
>> +               local-mac-address = [00 01 73 00 00 01];
>> +               phy-addr = <3>;
>> +               phy-mode = "rgmii";
>> +       };
>
>
> That doesn't look correct for a phy binding.
>

Okay.  I will change the dts to use phy-handle property and remove
phy-addr.  I will also rename phy-mode to phy-connection-type as per
Documentation/devicetree/bindings/net/ethernet.txt

>
> --
> Ben Dooks                               http://www.codethink.co.uk/
> Senior Engineer                         Codethink - Providing Genius
