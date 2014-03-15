Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827AbaCOD1S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 23:27:18 -0400
Received: from exprod5og106.obsmtp.com ([64.18.0.182]:33524 "HELO
	exprod5og106.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754667AbaCOD1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 23:27:14 -0400
MIME-Version: 1.0
In-Reply-To: <201403141307.23286.arnd@arndb.de>
References: <1394085963-27553-1-git-send-email-tinamdar@apm.com>
	<1394085963-27553-3-git-send-email-tinamdar@apm.com>
	<201403141307.23286.arnd@arndb.de>
Date: Fri, 14 Mar 2014 20:27:12 -0700
Message-ID: <CACoXjc=t1SuyE5jzHjGk7eNUjVCNW9_iqOTru8PQ191h=pP1sw@mail.gmail.com>
Subject: Re: [PATCH v4 2/4] arm64: dts: APM X-Gene PCIe device tree nodes
From: Tanmay Inamdar <tinamdar@apm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
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

On Fri, Mar 14, 2014 at 5:07 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 06 March 2014, Tanmay Inamdar wrote:
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
>> +                     dma-ranges = <0x42000000 0x40 0x00000000 0x40 0x00000000 0x40 0x00000000>;
>> +                     interrupt-map-mask = <0x0 0x0 0x0 0x7>;
>> +                     interrupt-map = <0x0 0x0 0x0 0x1 &gic 0x0 0xc2 0x1
>> +                                      0x0 0x0 0x0 0x2 &gic 0x0 0xc3 0x1
>> +                                      0x0 0x0 0x0 0x3 &gic 0x0 0xc4 0x1
>> +                                      0x0 0x0 0x0 0x4 &gic 0x0 0xc5 0x1>;
>> +                     clocks = <&pcie0clk 0>;
>> +             };
>
> Is 0x40.0x00000000 the start of your RAM? I had expected RAM to start at 0.0,
> and in that case the dma-ranges property would be wrong.

RAM starting address is 0x40_00000000.

>
>         Arnd
> CONFIDENTIALITY NOTICE: This e-mail message, including any attachments,
> is for the sole use of the intended recipient(s) and contains information
> that is confidential and proprietary to Applied Micro Circuits Corporation or its subsidiaries.
> It is to be used solely for the purpose of furthering the parties' business relationship.
> All unauthorized review, use, disclosure or distribution is prohibited.
> If you are not the intended recipient, please contact the sender by reply e-mail
> and destroy all copies of the original message.
>
