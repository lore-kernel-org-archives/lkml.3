Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806AbbA2Mxg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 07:53:36 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:62467 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbbA2Mxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 07:53:34 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-29-54ca2cb9b9fa
Message-id: <54CA2D3D.3070908@samsung.com>
Date: Thu, 29 Jan 2015 13:53:17 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
MIME-version: 1.0
To: cw00.choi@samsung.com
Cc: Tomasz Figa <tomasz.figa@gmail.com>,
        Mike Turquette <mturquette@linaro.org>, Kukjin Kim <kgene@kernel.org>,
        "pankaj.dubey@samsung.com" <pankaj.dubey@samsung.com>,
        "inki.dae@samsung.com" <inki.dae@samsung.com>,
        "chanho61.park@samsung.com" <chanho61.park@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 01/12] clk: samsung: exynos5433: Add clocks using common
 clock framework
References: <1421821618-8627-1-git-send-email-cw00.choi@samsung.com>
 <1421821618-8627-2-git-send-email-cw00.choi@samsung.com>
 <54C287A0.50407@samsung.com>
 <CAGTfZH0nXzDgFoMF4eSW71Sey44aY9gYRzX+uWP39ut2jY_Pfg@mail.gmail.com>
In-reply-to: <CAGTfZH0nXzDgFoMF4eSW71Sey44aY9gYRzX+uWP39ut2jY_Pfg@mail.gmail.com>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBLMWRmVeSWpSXmKPExsVy+t/xq7o7dU6FGBzfzWdxeb+2xfUvz1kt
	Jt2fwGLR//g1s8XlXXPYLGac38dk8XTCRTaLRVu/sFvMmPySzWLVrj+MDlweO2fdZffYtKqT
	zePOtT1sHn1bVjF6fN4kF8AaxWWTkpqTWZZapG+XwJVx/ltRwUP+io6z/SwNjI08XYycHBIC
	JhJzTp1mgbDFJC7cW8/WxcjFISSwlFHiVfcjVgjnE6PEjGVX2ECqeAW0JM5+ucMKYrMIqErM
	b9wBFmcTMJToPdrHCGKLCkRInLy7hx2iXlDix+R7QBs4OEQEJCVa9pmBzGQWWM4scX1zG1hc
	WCBRYvc6LpByIYGnjBK/fiSC2JwCwRIr96xjBSlhFlCXmDIlFyTMLCAvsXnNW+YJjAKzkCyY
	hVA1C0nVAkbmVYyiqaXJBcVJ6blGesWJucWleel6yfm5mxghof91B+PSY1aHGAU4GJV4eGds
	OhkixJpYVlyZe4hRgoNZSYS3UOlUiBBvSmJlVWpRfnxRaU5q8SFGJg5OqQZG6ZNinUxvb7X2
	tavLHnnH8n3CqZLHOjLp+nOZpm8oveylZOknm/nAKH6ZmmC+kPnPPyKGvUu3vxcNq/xy6nys
	vgJnudP20IAf03cYdsec3nJl2rJPq/eVpRdN373ktFLNV9fgsz7ZMtNN3r/Re//7oWxY3936
	ysxzp1ctYG9kjJOcqqJte/CDEktxRqKhFnNRcSIA5uDfRlsCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo,

On 23/01/15 21:54, Chanwoo Choi wrote:
> On Sat, Jan 24, 2015 at 2:40 AM, Sylwester Nawrocki
> <s.nawrocki@samsung.com> wrote:
>> On 21/01/15 07:26, Chanwoo Choi wrote:
>>> +/* list of all parent clock list */
>>
>>> +PNAME(mout_bus_pll_user_p)   = { "fin_pll", "sclk_bus_pll", };
>> ...
>>> +
>>> +static struct samsung_mux_clock top_mux_clks[] __initdata = {
>>
>>> +     MUX(CLK_MOUT_BUS_PLL_USER, "mout_bus_pll_user", mout_bus_pll_user_p,
>>> +                     MUX_SEL_TOP1, 0, 1),
>> ...
>>> +};
>>> +
>>> +static struct samsung_div_clock top_div_clks[] __initdata = {
>> ...
>>> +     /* DIV_TOP3 */
>>> +     DIV(CLK_DIV_ACLK_IMEM_SSSX_266, "div_aclk_imem_sssx_266",
>>> +                     "mout_bus_pll_user", DIV_TOP3, 24, 3),
>>
>> Shouldn't "fin_pll" be renamed to "oscclk" ? In the documentation
>> the root clock (from XXTI input pin) seems to be referred as OSCCLK.
>> And I can't see "fin_pll" clock registered anywhere. Shouldn't there
>> be a "fixed-rate-clock" as a parent of at least CMU_TOP? e.g.
> 
> Right,
> I added "fin_pll" fixed clock in DT as following:
> When I registered "fin_pll" fixed clock, I could use "fin_pll" clock
> for exynos5433 cmu without adding additional dt node.
> 
> fin_pll: xxti {
>         compatible = "fixed-clock";
>         clock-output-names = "fin_pll";
>         #clock-cells = <0>;
> };
> 
> I'll add the example of "fin_pll" dt node to documentation for exynos5433 cmu.

OK, thanks. But I think it needs to be named "oscclk", FIN_PLL is almost
not existent in the SoC's documentation.
I'd suggest to define the root oscillator clock (XXTI/OSCCLK) as "oscclk"
in DT, rather than registering "fin_pll" fixed clock in the driver.

>> xxti: xxti {
>>         compatible = "fixed-clock";
>>         #clock-cells = <0>;
>>         clock-output-names = "oscclk";
>>         clock-frequency = <24000000>;
>> };
>>
>> &cmu_top {
>>         clocks = <&xxti>;
>> };

--
Regards,
Sylwester
