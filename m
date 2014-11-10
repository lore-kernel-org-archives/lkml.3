Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751587AbaKJWfQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 17:35:16 -0500
Received: from mail-qa0-f54.google.com ([209.85.216.54]:46513 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbaKJWfO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 17:35:14 -0500
MIME-Version: 1.0
In-Reply-To: <38537ddd8ce845cd9929db4ffcb33031@BN1AFFO11FD006.protection.gbl>
References: <1415504283-31321-1-git-send-email-crosthwaite.peter@gmail.com>
	<38537ddd8ce845cd9929db4ffcb33031@BN1AFFO11FD006.protection.gbl>
Date: Tue, 11 Nov 2014 08:35:13 +1000
Message-ID: <CAPokK=p-LXJ0C7_Xy8DR0R0k_YrMRKJSMuh5Z48NWR=wmrQwhg@mail.gmail.com>
Subject: Re: [PATCH 1/2] arm: dts: zynq: Move crystal freq. to board level
From: Peter Crosthwaite <crosthwaitepeter@gmail.com>
To: =?UTF-8?Q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>
Cc: linux-kernel@vger.kernel.org, michals@xilinx.com, sorenb@xilinx.com,
        Steve Wang <steven.wang@digilentinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 7:34 AM, Sören Brinkmann
<soren.brinkmann@xilinx.com> wrote:
> On Sun, 2014-11-09 at 01:38PM +1000, Peter Crosthwaite wrote:
>> The fact that all supported boards use the same 33MHz crystal is a
>> co-incidence. The Zynq PS support a range of crystal freqs so the
>> hardcoded setting should be removed from the dtsi. Re-implement it
>> on the board level.
>>
>> This prepares support for Zynq boards with different crystal
>> frequencies (e.g. the Digilent ZYBO).
>
> Even with the 33MHz in the dtsi you can override it on the board-level.
> Just like the 'status' property is overriden in board dts files.
>

Do you want the deletion undone? Even with override capability I think
it should be removed as the number is board level specific and the
dtsi should be limited to SoC level information.

My understanding is the driver will default to 33MHz as well as a
catch-all, so anyone rolling their own top level OOT DTS is going to
be ok too.

>>
>> Signed-off-by: Peter Crosthwaite <crosthwaite.peter@gmail.com>
>>
>> ---
>> Im guessing long term this should be converted to a fixed clock. But
>> I think this at least steps in that direction.
>
> I was against that since it makes juggling with clock names more
> difficult. The problem is that the CCF uses a global name space of clock
> names.

I thought it was just a

clocks = < &phandle >

Where's the namespacing issue?

Btw I think the clocks=phandle would be populated the the dts as well.
So the DTSI would have no clocks = node, and the dts must populate it.
This allows support for an on-board off-soc clock controller
controlling the PS clock (which is in theory supported by the SoC).

 Not having the oscillator as fixed-clock in DT removed that
> additional complexity. But it would be possible, I guess.
>
>> ---
>>  arch/arm/boot/dts/zynq-7000.dtsi      | 1 -
>>  arch/arm/boot/dts/zynq-parallella.dts | 4 ++++
>>  arch/arm/boot/dts/zynq-zc702.dts      | 4 ++++
>>  arch/arm/boot/dts/zynq-zc706.dts      | 4 ++++
>>  arch/arm/boot/dts/zynq-zed.dts        | 4 ++++
>>  5 files changed, 16 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
>> index ce2ef5b..ee3e5d6 100644
>> --- a/arch/arm/boot/dts/zynq-7000.dtsi
>> +++ b/arch/arm/boot/dts/zynq-7000.dtsi
>> @@ -243,7 +243,6 @@
>>                       clkc: clkc@100 {
>>                               #clock-cells = <1>;
>>                               compatible = "xlnx,ps7-clkc";
>> -                             ps-clk-frequency = <33333333>;
>>                               fclk-enable = <0>;
>>                               clock-output-names = "armpll", "ddrpll", "iopll", "cpu_6or4x",
>>                                               "cpu_3or2x", "cpu_2x", "cpu_1x", "ddr2x", "ddr3x",
>> diff --git a/arch/arm/boot/dts/zynq-parallella.dts b/arch/arm/boot/dts/zynq-parallella.dts
>> index e1f51ca..cd84d45 100644
>> --- a/arch/arm/boot/dts/zynq-parallella.dts
>> +++ b/arch/arm/boot/dts/zynq-parallella.dts
>> @@ -83,3 +83,7 @@
>>  &uart1 {
>>       status = "okay";
>>  };
>> +
>> +&clkc {
>> +     ps-clk-frequency = <33333333>;
>> +};
>> diff --git a/arch/arm/boot/dts/zynq-zc702.dts b/arch/arm/boot/dts/zynq-zc702.dts
>> index 94e2cda..24dcece 100644
>> --- a/arch/arm/boot/dts/zynq-zc702.dts
>> +++ b/arch/arm/boot/dts/zynq-zc702.dts
>> @@ -135,3 +135,7 @@
>>  &uart1 {
>>       status = "okay";
>>  };
>> +
>> +&clkc {
>> +     ps-clk-frequency = <33333333>;
>> +};
>> diff --git a/arch/arm/boot/dts/zynq-zc706.dts b/arch/arm/boot/dts/zynq-zc706.dts
>> index a8bbdfb..7b88399 100644
>> --- a/arch/arm/boot/dts/zynq-zc706.dts
>> +++ b/arch/arm/boot/dts/zynq-zc706.dts
>> @@ -114,3 +114,7 @@
>>  &uart1 {
>>       status = "okay";
>>  };
>> +
>> +&clkc {
>> +     ps-clk-frequency = <33333333>;
>> +};
>> diff --git a/arch/arm/boot/dts/zynq-zed.dts b/arch/arm/boot/dts/zynq-zed.dts
>> index 697779a..4662da2 100644
>> --- a/arch/arm/boot/dts/zynq-zed.dts
>> +++ b/arch/arm/boot/dts/zynq-zed.dts
>> @@ -46,3 +46,7 @@
>>  &uart1 {
>>       status = "okay";
>>  };
>> +
>> +&clkc {
>> +     ps-clk-frequency = <33333333>;
>> +};
>
> I think we currently have the nodes more or less in alphabetical order.
> I'd prefer if we maintained that.
>

Will fix.

Regards,
Peter

> Other than that:
> Acked-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
>
>         Soren
