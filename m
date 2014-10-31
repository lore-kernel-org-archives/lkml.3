Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001AbaJaIRO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 04:17:14 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:43527 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbaJaIRM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 04:17:12 -0400
MIME-Version: 1.0
In-Reply-To: <5cf5e2e5cd154992b2896b98988a409a@BN1BFFO11FD007.protection.gbl>
References: <1413479495-14206-1-git-send-email-soren.brinkmann@xilinx.com>
	<1413479495-14206-9-git-send-email-soren.brinkmann@xilinx.com>
	<CACRpkda9v=H9rQBq484c+UCwEKeca9qOE_78Wf+STB4rDwhuyA@mail.gmail.com>
	<5cf5e2e5cd154992b2896b98988a409a@BN1BFFO11FD007.protection.gbl>
Date: Fri, 31 Oct 2014 09:17:11 +0100
Message-ID: <CACRpkdZjJQTxVhvq5BT3mHBDHge_wHBNi9N_6u0WVbPB3wBDKw@mail.gmail.com>
Subject: Re: [PATCH RFC v2 8/8] ARM: zynq: DT: Add pinctrl information
From: Linus Walleij <linus.walleij@linaro.org>
To: =?UTF-8?Q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>
Cc: Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 5:03 PM, Sören Brinkmann
<soren.brinkmann@xilinx.com> wrote:
> On Tue, 2014-10-28 at 04:05PM +0100, Linus Walleij wrote:
>> On Thu, Oct 16, 2014 at 7:11 PM, Soren Brinkmann
>> <soren.brinkmann@xilinx.com> wrote:
>>
>> > Add pinctrl descriptions to the zc702 and zc706 device trees.
>> >
>> > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
>>
>> (...)
>> > +&pinctrl0 {
>> > +       pinctrl_can0_default: pinctrl-can0-default {
>> > +               common {
>> > +                       function = "can0";
>> > +                       groups = "can0_9_grp";
>> > +                       bias-pull-up = <0>;
>>
>> No. If you want pull-up, just use
>> bias-pull-up;
>>
>> If you want to disable pull-up, use
>> bias-disable;
>
> But bias-disable also disables high-impedance. That doesn't work for me,
> I think.

Hm. Some sequencing problem right? Like you count on
bias-high-impdedance being set in some other state?

I think each state should be self-contained, so you set
all the stuff you need in a state, do not rely on things coming
in pre-set from another state.

So in this case just set bias-high-impedance; then and
if the state does not have bias-pull-up, *always* disable it
in the driver.

>>
>> > +                       slew-rate = <0>;
>>
>> If this measure is any kind of time unit, this is against the laws of nature.
>
> It's not. As the bindings say, the argument is driver specific.

Okay then.

>> > +               rx {
>> > +                       pins = "MIO46";
>> > +                       bias-high-impedance = <1>;
>>
>> Just
>> bias-high-impedance;
>
> Same problem as I have above. To allow all permutations of pull-up and
> tri-state I can't just have a single disable-bias property.

Again it seems to be a sequencing problem. And device tree is
not good at sequences, therefore all states should be self-contained.

Yours,
Linus Walleij
