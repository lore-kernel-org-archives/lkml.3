Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121AbaKKVwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 16:52:19 -0500
Received: from mail-oi0-f52.google.com ([209.85.218.52]:42430 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbaKKVwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 16:52:18 -0500
MIME-Version: 1.0
In-Reply-To: <CAL_JsqLXTx9jWT3sm3wnu1oWCk_VH_CUjfVX7t1HEA_9BfSeAg@mail.gmail.com>
References: <1415727960-29524-1-git-send-email-mathieu.poirier@linaro.org>
	<CAL_JsqLXTx9jWT3sm3wnu1oWCk_VH_CUjfVX7t1HEA_9BfSeAg@mail.gmail.com>
Date: Tue, 11 Nov 2014 14:52:17 -0700
Message-ID: <CANLsYkxok7LVGey6tPqmt42GEAs8R7SYAG_cs4VRjYeqkwKEKw@mail.gmail.com>
Subject: Re: [PATCH] coresight: bindings for coresight drivers
From: Mathieu Poirier <mathieu.poirier@linaro.org>
To: Rob Herring <robherring2@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 November 2014 11:04, Rob Herring <robherring2@gmail.com> wrote:
> On Tue, Nov 11, 2014 at 11:46 AM,  <mathieu.poirier@linaro.org> wrote:
>> Greg,
>>
>> Please consider this as a supplement to the coresight patchset.  It should have
>> been sent with the rest of the patches but I missed the original ack from Rob
>> Herring.
>
> Ummm...
>
>>
>> Thanks,
>> Mathieu
>>
>> From 69cae46640b8cdc836bf7b86211d5f2adf3d0270 Mon Sep 17 00:00:00 2001
>> From: Mathieu Poirier <mathieu.poirier@linaro.org>
>> Date: Thu, 7 Aug 2014 12:34:06 -0600
>> Subject: [PATCH] coresight: bindings for coresight drivers
>>
>> Coresight IP blocks allow for the support of HW assisted tracing
>> on ARM SoCs.  Bindings for the currently available blocks are
>> presented herein.
>>
>> Signed-off-by: Pratik Patel <pratikp@codeaurora.org>
>> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
>
> And you still did.

https://patchwork.ozlabs.org/patch/388318/

>
>
>> ---
>>  .../devicetree/bindings/arm/coresight.txt          | 204 +++++++++++++++++++++
>>  1 file changed, 204 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/arm/coresight.txt
>>
>> diff --git a/Documentation/devicetree/bindings/arm/coresight.txt b/Documentation/devicetree/bindings/arm/coresight.txt
>> new file mode 100644
>> index 0000000..d790f49
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/arm/coresight.txt
>> @@ -0,0 +1,204 @@
>> +* CoreSight Components:
>> +
>> +CoreSight components are compliant with the ARM CoreSight architecture
>> +specification and can be connected in various topologies to suit a particular
>> +SoCs tracing needs. These trace components can generally be classified as
>> +sinks, links and sources. Trace data produced by one or more sources flows
>> +through the intermediate links connecting the source to the currently selected
>> +sink. Each CoreSight component device should use these properties to describe
>> +its hardware characteristcs.
>> +
>> +* Required properties for all components *except* non-configurable replicators:
>> +
>> +       * compatible: These have to be supplemented with "arm,primecell" as
>> +         drivers are using the AMBA bus interface.  Possible values include:
>> +               - "arm,coresight-etb10", "arm,primecell";
>> +               - "arm,coresight-tpiu", "arm,primecell";
>> +               - "arm,coresight-tmc", "arm,primecell";
>> +               - "arm,coresight-funnel", "arm,primecell";
>> +               - "arm,coresight-etm3x", "arm,primecell";
>> +
>> +       * reg: physical base address and length of the register
>> +         set(s) of the component.
>> +
>> +       * clocks: the clock associated to this component.
>> +
>> +       * clock-names: the name of the clock as referenced by the code.
>> +         Since we are using the AMBA framework, the name should be
>> +         "apb_pclk".
>> +
>> +       * port or ports: The representation of the component's port
>> +         layout using the generic DT graph presentation found in
>> +         "bindings/graph.txt".
>> +
>> +* Required properties for devices that don't show up on the AMBA bus, such as
>> +  non-configurable replicators:
>> +
>> +       * compatible: Currently supported value is (note the absence of the
>> +         AMBA markee):
>> +               - "arm,coresight-replicator"
>> +
>> +       * id: a unique number that will identify this replicator.
>> +
>> +       * port or ports: same as above.
>> +
>> +* Optional properties for ETM/PTMs:
>> +
>> +       * arm,cp14: must be present if the system accesses ETM/PTM management
>> +         registers via co-processor 14.
>> +
>> +       * cpu: the cpu phandle this ETM/PTM is affined to. When omitted the
>> +         source is considered to belong to CPU0.
>> +
>> +* Optional property for TMC:
>> +
>> +       * arm,buffer-size: size of contiguous buffer space for TMC ETR
>> +        (embedded trace router)
>> +
>> +
>> +Example:
>> +
>> +1. Sinks
>> +       etb@20010000 {
>> +               compatible = "arm,coresight-etb10", "arm,primecell";
>> +               reg = <0 0x20010000 0 0x1000>;
>> +
>> +               coresight-default-sink;
>> +               clocks = <&oscclk6a>;
>> +               clock-names = "apb_pclk";
>> +               port {
>> +                       etb_in_port: endpoint@0 {
>> +                               slave-mode;
>> +                               remote-endpoint = <&replicator_out_port0>;
>> +                       };
>> +               };
>> +       };
>> +
>> +       tpiu@20030000 {
>> +               compatible = "arm,coresight-tpiu", "arm,primecell";
>> +               reg = <0 0x20030000 0 0x1000>;
>> +
>> +               clocks = <&oscclk6a>;
>> +               clock-names = "apb_pclk";
>> +               port {
>> +                       tpiu_in_port: endpoint@0 {
>> +                               slave-mode;
>> +                               remote-endpoint = <&replicator_out_port1>;
>> +                       };
>> +               };
>> +       };
>> +
>> +2. Links
>> +       replicator {
>> +               /* non-configurable replicators don't show up on the
>> +                * AMBA bus.  As such no need to add "arm,primecell".
>> +                */
>> +               compatible = "arm,coresight-replicator";
>> +               /* this will show up in debugfs as "0.replicator" */
>> +               id = <0>;
>> +
>> +               ports {
>> +                       #address-cells = <1>;
>> +                       #size-cells = <0>;
>> +
>> +                       /* replicator output ports */
>> +                       port@0 {
>> +                               reg = <0>;
>> +                               replicator_out_port0: endpoint {
>> +                                       remote-endpoint = <&etb_in_port>;
>> +                               };
>> +                       };
>> +
>> +                       port@1 {
>> +                               reg = <1>;
>> +                               replicator_out_port1: endpoint {
>> +                                       remote-endpoint = <&tpiu_in_port>;
>> +                               };
>> +                       };
>> +
>> +                       /* replicator input port */
>> +                       port@2 {
>> +                               reg = <0>;
>> +                               replicator_in_port0: endpoint {
>> +                                       slave-mode;
>> +                                       remote-endpoint = <&funnel_out_port0>;
>> +                               };
>> +                       };
>> +               };
>> +       };
>> +
>> +       funnel@20040000 {
>> +               compatible = "arm,coresight-funnel", "arm,primecell";
>> +               reg = <0 0x20040000 0 0x1000>;
>> +
>> +               clocks = <&oscclk6a>;
>> +               clock-names = "apb_pclk";
>> +               ports {
>> +                       #address-cells = <1>;
>> +                       #size-cells = <0>;
>> +
>> +                       /* funnel output port */
>> +                       port@0 {
>> +                               reg = <0>;
>> +                               funnel_out_port0: endpoint {
>> +                                       remote-endpoint =
>> +                                                       <&replicator_in_port0>;
>> +                               };
>> +                       };
>> +
>> +                       /* funnel input ports */
>> +                       port@1 {
>> +                               reg = <0>;
>> +                               funnel_in_port0: endpoint {
>> +                                       slave-mode;
>> +                                       remote-endpoint = <&ptm0_out_port>;
>> +                               };
>> +                       };
>> +
>> +                       port@2 {
>> +                               reg = <1>;
>> +                               funnel_in_port1: endpoint {
>> +                                       slave-mode;
>> +                                       remote-endpoint = <&ptm1_out_port>;
>> +                               };
>> +                       };
>> +
>> +                       port@3 {
>> +                               reg = <2>;
>> +                               funnel_in_port2: endpoint {
>> +                                       slave-mode;
>> +                                       remote-endpoint = <&etm0_out_port>;
>> +                               };
>> +                       };
>> +
>> +               };
>> +       };
>> +
>> +3. Sources
>> +       ptm@2201c000 {
>> +               compatible = "arm,coresight-etm3x", "arm,primecell";
>> +               reg = <0 0x2201c000 0 0x1000>;
>> +
>> +               cpu = <&cpu0>;
>> +               clocks = <&oscclk6a>;
>> +               clock-names = "apb_pclk";
>> +               port {
>> +                       ptm0_out_port: endpoint {
>> +                               remote-endpoint = <&funnel_in_port0>;
>> +                       };
>> +               };
>> +       };
>> +
>> +       ptm@2201d000 {
>> +               compatible = "arm,coresight-etm3x", "arm,primecell";
>> +               reg = <0 0x2201d000 0 0x1000>;
>> +
>> +               cpu = <&cpu1>;
>> +               clocks = <&oscclk6a>;
>> +               clock-names = "apb_pclk";
>> +               port {
>> +                       ptm1_out_port: endpoint {
>> +                               remote-endpoint = <&funnel_in_port1>;
>> +                       };
>> +               };
>> +       };
>> --
>> 1.9.1
>>
