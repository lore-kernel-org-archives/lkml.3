Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751393AbaDAJcL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 05:32:11 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:46306 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbaDAJcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 05:32:08 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-9d-533a87940606
Message-id: <533A878D.8080302@samsung.com>
Date: Tue, 01 Apr 2014 11:31:57 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.3.0
MIME-version: 1.0
To: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        gregkh@linuxfoundation.org, mturquette@linaro.org,
        linux@arm.linux.org.uk, robh+dt@kernel.org, grant.likely@linaro.org,
        mark.rutland@arm.com, galak@codeaurora.org, kyungmin.park@samsung.com,
        sw0312.kim@samsung.com, m.szyprowski@samsung.com, t.figa@samsung.com,
        laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH RFC v4 2/2] clk: Add handling of clk parent and rate
 assigned from DT
References: <1396284116-19178-1-git-send-email-s.nawrocki@samsung.com>
 <1396284116-19178-3-git-send-email-s.nawrocki@samsung.com>
 <5339A036.6090703@codethink.co.uk> <20140401062306.GS17250@pengutronix.de>
In-reply-to: <20140401062306.GS17250@pengutronix.de>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIIsWRmVeSWpSXmKPExsVy+t/xy7pT2q2CDa49N7F4cKuVyWL+kXOs
	Fv1vFrJaHPizg9GiefF6NouzTW/YLTonLmG32PT4GqvF5V1z2CxuX+a1WHvkLrvF0usXmSye
	TrjIZtG69wi7xd/tm1gsZkx+yWaxfsZrFgdBjzXz1jB6tDT3sHlc7utl8nj2cjKTx+yOmawe
	m1Z1snncubaHzWP/3DXsHpuX1Hv0/zXw6NuyitHj8ya5AJ4oLpuU1JzMstQifbsEroz9/xYx
	F8wSrDg+8TxbA+M+3i5GTg4JAROJ78/Xs0LYYhIX7q1n62Lk4hASWMoocbGvnxHC+cQocXTn
	UWaQKl4BLYkXXUtZQGwWAVWJ+wdusIPYbAKGEr1H+xhBbFGBCIm5EzezQdQLSvyYfA+sXkRA
	U6Lv9mKwOLPAbmaJ9W/0QWxhgWiJMw0bmSGWXWCUeLDuFthQTqDzHlz+ww7RoCOxv3UaVLO8
	xOY1b5knMArMQrJjFpKyWUjKFjAyr2IUTS1NLihOSs811CtOzC0uzUvXS87P3cQIicYvOxgX
	H7M6xCjAwajEw2tRbhksxJpYVlyZe4hRgoNZSYT3e7NVsBBvSmJlVWpRfnxRaU5q8SFGJg5O
	qQZG70VptyUvqSYecT83/7OkYZfNHZF9e2OleS6oPVCd6+E1mW2BCltpeuGkOfsm7lWRn7iU
	V5CnT2vzFSXWDNXVEod0NYxXfma/yrjIP0J739FdTxW8KxXUvt6N5os6sWOqbNKZpQzWNn8q
	fdew2Vh9uqy5W/BRe9M9bgYJvjmBx15mPRVPPluoxFKckWioxVxUnAgA2iLsy6QCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/14 08:23, Sascha Hauer wrote:
>> tree/bindings/clock/clock-bindings.txt
>> > b/Documentation/devicetree/bindings/clock/clock-bindings.txt
>>> > >index 700e7aa..59fbb4e 100644
>>> > >--- a/Documentation/devicetree/bindings/clock/clock-bindings.txt
>>> > >+++ b/Documentation/devicetree/bindings/clock/clock-bindings.txt
>>> > >@@ -132,3 +132,45 @@ clock signal, and a UART.
>>> > >    ("pll" and "pll-switched").
>>> > >  * The UART has its baud clock connected the external oscillator and its
>>> > >    register clock connected to the PLL clock (the "pll-switched" signal)
>>> > >+
>>> > >+==Assigned clock parents and rates==
>>> > >+
>>> > >+Some platforms require static initial configuration of parts of the clocks
>>> > >+controller. Such a configuration can be specified in a clock consumer node
>>> > >+through clock-parents and clock-rates DT properties. The former should
>>> > >+contain a list of parent clocks in form of phandle and clock specifier pairs,
>>> > >+the latter the list of assigned clock frequency values (one cell each).
>>> > >+
>>> > >+    uart@a000 {
>>> > >+        compatible = "fsl,imx-uart";
>>> > >+        reg = <0xa000 0x1000>;
>>> > >+        ...
>>> > >+        clocks = <&clkcon 0>, <&clkcon 3>;
>>> > >+        clock-names = "baud", "mux";
>>> > >+
>>> > >+        clock-parents = <0>, <&pll 1>;
>>> > >+        clock-rates = <460800>;
>>> > >+    };
>>> > >+
>>> > >+In this example the pll is set as parent of "mux" clock and frequency of "baud"
>>> > >+clock is specified as 460800 Hz.
[...]
>> > 
>> > How do you support not-setting a rate for a clock?
>
> Not setting a rate is supported by specifying the rate to 0. That should
> be documented of course.

Yes, a rate won't be set for a clock if its corresponding entry in
clock-rates property is set to 0. Sorry, should have mentioned it.

Would adding a sentence as below to end of the first paragraph above
make it clear ?

"To skip setting a rate or parent for a clock the value of a corresponding
entry in the clock-rates or clock-parents property respectively should
be set to 0. The trailing zeros can be omitted."

--
Thanks,
Sylwester
