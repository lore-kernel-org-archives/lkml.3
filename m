Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037AbaJGTUm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 15:20:42 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:46345 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754370AbaJGTUj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 15:20:39 -0400
MIME-Version: 1.0
In-Reply-To: <1854393.Qf7h4x8eso@phil>
References: <1412674438-26160-1-git-send-email-kever.yang@rock-chips.com>
	<1412674438-26160-3-git-send-email-kever.yang@rock-chips.com>
	<CAD=FV=UNXUuJbRpECV0Ay0hR02Dg=rBw+XScvMdfngzWfCqp4w@mail.gmail.com>
	<1854393.Qf7h4x8eso@phil>
Date: Tue, 7 Oct 2014 12:20:38 -0700
X-Google-Sender-Auth: N6YXDlYcMIXBqdp071ETZQLG4lU
Message-ID: <CAD=FV=WwXXQ6941WuATBiNqZ0sM3EkSo-EHHoqn3uGmZdNvW5w@mail.gmail.com>
Subject: Re: [PATCH 2/2] ARM: dts: enable init rate for clock
From: Doug Anderson <dianders@chromium.org>
To: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>
Cc: Kever Yang <kever.yang@rock-chips.com>,
        Mike Turquette <mturquette@linaro.org>,
        Sonny Rao <sonnyrao@chromium.org>, Addy Ke <addy.ke@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, Jianqun Xu <xjq@rock-chips.com>,
        han jiang <hj@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        =?UTF-8?B?5oi05YWL6ZyWIChKYWNrKQ==?= <dkl@rock-chips.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-rockchip@lists.infradead.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heiko,

On Tue, Oct 7, 2014 at 11:27 AM, Heiko Stübner <heiko@sntech.de> wrote:
> Am Dienstag, 7. Oktober 2014, 10:03:19 schrieb Doug Anderson:
>> Kever,
>>
>> On Tue, Oct 7, 2014 at 2:33 AM, Kever Yang <kever.yang@rock-chips.com>
> wrote:
>> > We need to initialize PLL rate and some of bus clock rate while
>> > kernel init, for there is no other module will do that.
>> >
>> > Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
>> > ---
>> >
>> >  arch/arm/boot/dts/rk3288.dtsi | 10 ++++++++++
>> >  1 file changed, 10 insertions(+)
>> >
>> > diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
>> > index 874e66d..2f4519b 100644
>> > --- a/arch/arm/boot/dts/rk3288.dtsi
>> > +++ b/arch/arm/boot/dts/rk3288.dtsi
>> > @@ -455,6 +455,16 @@
>> >
>> >                 rockchip,grf = <&grf>;
>> >                 #clock-cells = <1>;
>> >                 #reset-cells = <1>;
>> >
>> > +               assigned-clocks = <&cru PLL_GPLL>, <&cru PLL_CPLL>,
>> > +                                 <&cru PLL_NPLL>, <&cru ACLK_CPU>,
>> > +                                 <&cru HCLK_CPU>, <&cru PCLK_CPU>,
>> > +                                 <&cru ACLK_PERI>, <&cru HCLK_PERI>,
>> > +                                 <&cru PCLK_PERI>;
>> > +               assigned-clock-rates = <594000000>, <400000000>,
>> > +                                      <500000000>, <300000000>,
>>
>> When I boot up, I see that ACLK_CPU was 297000000.  You specified
>> 300000000.  Did you expect to get 300?  If you expected 297, I think
>> you should put 297.  If you expected 300 then we have some debugging
>> to do.  Note: I'm not quite sure how you'd expect to get 300 given
>> that none of the PLLs divide evenly to 300...
>
> I'd think 300 is simply the target value. I.e. take the closest rate <= 300
> MHz, same for 150 etc. I somehow like the approach of specifying what the rate
> _should_ ideally be :-) .
>
> Also reduces the amount of thougths necessary (and possible head-scratching)
> when adapting the pll rates to some other constraints (child-clocks already
> have the target rates and cannot drop to some even stranger value).

OK, fair enough.  I guess maybe I've overly paranoid and like to make
sure that someone has thought through exactly what various core clocks
should be and made sure that the voltage matched and that clocks were
never out of spec.  ...but if others really like specifying more ideal
values then I'm OK with it.  I will say that I'd really like the PLLs
to be exact, though.  I think those are now...

-Doug
