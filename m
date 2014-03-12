Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460AbaCLQo3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 12:44:29 -0400
Received: from exprod5og110.obsmtp.com ([64.18.0.20]:36428 "HELO
	exprod5og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755143AbaCLQo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 12:44:28 -0400
MIME-Version: 1.0
In-Reply-To: <000001cf3dcd$751a4680$5f4ed380$%han@samsung.com>
References: <1394085963-27553-1-git-send-email-tinamdar@apm.com>
	<1394085963-27553-3-git-send-email-tinamdar@apm.com>
	<000001cf3dcd$751a4680$5f4ed380$%han@samsung.com>
Date: Wed, 12 Mar 2014 09:44:20 -0700
Message-ID: <CACoXjckTMbt2GgLFgh39CRNGydZ4u4-L2J1PQfFi8fR7A=LUGQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/4] arm64: dts: APM X-Gene PCIe device tree nodes
From: Tanmay Inamdar <tinamdar@apm.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rob Landley <rob@landley.net>, Liviu Dudau <liviu.dudau@arm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches <patches@apm.com>,
        Jon Masters <jcm@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jingoo Han,

On Wed, Mar 12, 2014 at 1:31 AM, Jingoo Han <jg1.han@samsung.com> wrote:
> On Thursday, March 06, 2014 3:06 PM, Tanmay Inamdar wrote:
>>
>> This patch adds the device tree nodes for APM X-Gene PCIe controller and
>> PCIe clock interface. Since X-Gene SOC supports maximum 5 ports, 5 dts
>> nodes are added.
>>
>> Signed-off-by: Tanmay Inamdar <tinamdar@apm.com>
>> ---
>>  arch/arm64/boot/dts/apm-mustang.dts |    8 ++
>>  arch/arm64/boot/dts/apm-storm.dtsi  |  155 +++++++++++++++++++++++++++++++++++
>>  2 files changed, 163 insertions(+)
>
> [.....]
>
>> --- a/arch/arm64/boot/dts/apm-storm.dtsi
>> +++ b/arch/arm64/boot/dts/apm-storm.dtsi
>
> [.....]
>
>> +
>> +             pcie0: pcie@1f2b0000 {
>> +                     status = "disabled";
>> +                     device_type = "pci";
>> +                     compatible = "apm,xgene-storm-pcie", "apm,xgene-pcie";
>> +                     #interrupt-cells = <1>;
>> +                     #size-cells = <2>;
>> +                     #address-cells = <3>;
>> +                     reg = < 0x00 0x1f2b0000 0x0 0x00010000   /* Controller registers */
>> +                             0xe0 0xd0000000 0x0 0x00200000>; /* PCI config space */
>> +                     reg-names = "csr", "cfg";
>> +                     ranges = <0x01000000 0x00 0x00000000 0xe0 0x00000000 0x00 0x00010000   /* io */
>> +                               0x02000000 0x00 0x10000000 0xe0 0x10000000 0x00 0x80000000>; /* mem */
>                                                                           ^^^
>
> I have a question about the fourth number '0xe0' of 'ranges' property.
> Would you let me know what the '0xe0' means?
>

In X-Gene address map, the physical address range starting from
0xe0_00000000 is reserved for PCIe Port 0 outbound memory mappings.

> Best regards,
> Jingoo Han
>
>> +                     dma-ranges = <0x42000000 0x40 0x00000000 0x40 0x00000000 0x40 0x00000000>;
>> +                     interrupt-map-mask = <0x0 0x0 0x0 0x7>;
>> +                     interrupt-map = <0x0 0x0 0x0 0x1 &gic 0x0 0xc2 0x1
>> +                                      0x0 0x0 0x0 0x2 &gic 0x0 0xc3 0x1
>> +                                      0x0 0x0 0x0 0x3 &gic 0x0 0xc4 0x1
>> +                                      0x0 0x0 0x0 0x4 &gic 0x0 0xc5 0x1>;
>> +                     clocks = <&pcie0clk 0>;
>> +             };
>
