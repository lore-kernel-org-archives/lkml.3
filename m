Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932322AbaEPKwy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 06:52:54 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:19605 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932302AbaEPKww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 06:52:52 -0400
X-AuditID: cbfec7f5-b7fae6d000004d6d-16-5375ee025aae
Message-id: <5375EDFD.1020708@samsung.com>
Date: Fri, 16 May 2014 12:52:45 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Rahul Sharma <rahul.sharma@samsung.com>
Cc: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Mike Turquette <mturquette@linaro.org>,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tomasz Figa <tomasz.figa@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Tushar Behera <tushar.behera@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH RFC 3/4] clk: samsung: Add driver to control CLKOUT line on
 Exynos SoCs
References: <1400175151-27779-1-git-send-email-t.figa@samsung.com>
 <1400175151-27779-4-git-send-email-t.figa@samsung.com>
 <CAPdUM4P7Z1eLVKuc0N1iPaekM_7kNv7KCve2MgrEziszfnzz7A@mail.gmail.com>
In-reply-to: <CAPdUM4P7Z1eLVKuc0N1iPaekM_7kNv7KCve2MgrEziszfnzz7A@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGLMWRmVeSWpSXmKPExsVy+t/xy7pM70qDDaZ8VLGY+vAJm8X8I+dY
	LXoXXGWz2PT4GqvF5V1z2CxmnN/HZLH2yF12i6XXLzJZPJ1wkc1i0dYv7BZTFh1mtWjde4Td
	YtWuP4wW7X/3sjnweayZt4bRY+esu+wem1Z1snncubaHzWPzknqPvi2rGD0+b5ILYI/isklJ
	zcksSy3St0vgymjZ8Iq94A57xZw+zwbGPtYuRk4OCQETicfHH7ND2GISF+6tZ+ti5OIQEljK
	KHHkby+U85lRYtKLmWwgVbwCWhIfnq4H62ARUJVY8n862CQ2ATWJzw2PwGr4gWrWNF1n6WLk
	4BAViJB4fEEIolVQ4sfkeywgtoiAtkTDsRaw+cwCb1kkVq34ADZHWCBWovnrCnaIxYcYJbY8
	a2UESXAKBEvMuH8UrJtZQEdif+s0NghbXmLzmrfMExgFZyFZMgtJ2SwkZQsYmVcxiqaWJhcU
	J6XnGukVJ+YWl+al6yXn525ihMTV1x2MS49ZHWIU4GBU4uFlCC0NFmJNLCuuzAW6hoNZSYTX
	7RVQiDclsbIqtSg/vqg0J7X4ECMTB6dUA+OquQeUr655OI/7kd7q5xbz3ux/nzQvYFO8qd+6
	u4EPmvZ7Lmtn9PKZM9lMXIa/6/mRWZtv2jdwMlQ+0Av4IHP+Uf5/U6t3blWuvRZLfrE/X5BY
	FsOz2cbnaZOdglEmR/f18FM+Ujv2+x1U9BS6efzw2bS9O0QvvX5SedpM50Pir5nb4jZpqpko
	sRRnJBpqMRcVJwIAbAe7xIkCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rahul,

On 16.05.2014 12:39, Rahul Sharma wrote:
> [snip]
>> +       gate->lock = &clkout_lock;
>> +
>> +       mux->reg = reg + EXYNOS_PMU_DEBUG_REG;
>> +       mux->mask = EXYNOS_CLKOUT_MUX_MASK;
>> +       mux->shift = EXYNOS_CLKOUT_MUX_SHIFT;
>> +       mux->lock = &clkout_lock;
>> +
>> +       clk = clk_register_composite(NULL, "clkout", parent_names,
>> +                                       parent_count, &mux->hw,
>> +                                       &clk_mux_ops, NULL, NULL, &gate->hw,
>> +                                       &clk_gate_ops, 0);
>> +       if (IS_ERR(clk))
>> +               goto err_unmap;
>> +
> 
> Hi Tomasz,
> 
> Do we really need a composite clock here? How about registering
> a mux and a gate separately?

What's wrong with a composite clock? It simplifies the code as just a
single clock needs to be registered. I don't see any drawbacks compared
to registering two clocks separately.

Best regards,
Tomasz
