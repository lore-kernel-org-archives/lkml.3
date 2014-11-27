Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843AbaK0MMV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 07:12:21 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:47055 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913AbaK0MMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 07:12:19 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-4c-5477152003e5
Message-id: <54771518.1010004@samsung.com>
Date: Thu, 27 Nov 2014 13:12:08 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
MIME-version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kgene.kim@samsung.com,
        mark.rutland@arm.com, olof@lixom.net, catalin.marinas@arm.com,
        will.deacon@arm.com, tomasz.figa@gmail.com, thomas.abraham@linaro.org,
        linus.walleij@linaro.org, kyungmin.park@samsung.com,
        inki.dae@samsung.com, chanho61.park@samsung.com,
        geunsik.lim@samsung.com, sw0312.kim@samsung.com,
        jh80.chung@samsung.com, a.kesavan@samsung.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 11/19] clk: samsung: exynos5433: Add clocks for
 CMU_BUS{0|1|2} domains
References: <1417073716-22997-1-git-send-email-cw00.choi@samsung.com>
 <1417073716-22997-12-git-send-email-cw00.choi@samsung.com>
 <6217579.xNXtO7YiDs@wuerfel> <54771173.6090408@samsung.com>
In-reply-to: <54771173.6090408@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnkeLIzCtJLcpLzFFi42I5/e/4ZV0F0fIQg0eftSwer1nMZPF30jF2
	i/fLehgtLu/Xtrj+5Tmrxfwj51gt/kxoZbOYdH8Ci8WNX22sFr0LrrJZnG16w24x5c9yJotN
	j6+xWlzeNYfNYsb5fUwWS69fZLI4df0zkDv5JZvFsRlLGC1W7frDaPHy4wkWB1GPNfPWMHr8
	/jWJ0WPnrLvsHneu7WHz2Lyk3uPKiSZWj74tqxg9Pm+SC+CI4rJJSc3JLEst0rdL4Mo49+Iv
	S8EZnorF8ywaGPu5uhg5OSQETCQur73NCGGLSVy4t56ti5GLQ0hgKaPEvYvrWCCcT4wSHa9/
	glXxCmhJrH/5nRXEZhFQleg+tR7MZhMwlOg92gdWIyoQIXHy7h52iHpBiR+T77GA2CICGhIz
	/14Bq2EWmMoicfpzMYgtLBAjcXXNX0aIZQcYJV7/mgXWzCmgLdHc2QFkcwA16Encv6gF0Ssv
	sXnNW+YJjAKzkKyYhVA1C0nVAkbmVYyiqaXJBcVJ6bmGesWJucWleel6yfm5mxghkfhlB+Pi
	Y1aHGAU4GJV4eBMel4UIsSaWFVfmHmKU4GBWEuHlYiwPEeJNSaysSi3Kjy8qzUktPsTIxMEp
	1cAo0NF2x7SlUL55j8bh3oXVu5U2Js849nf6iavTWf2kmtfvnVXwgMe3qc027fsk2+N2j+Qu
	Vbxi9q2UChYRtGXfuv7d+sR9F33V01tEqg7GzOI76/q8/pab9rZHMSdnCqsXM9ar8XYYLVqz
	S6coZ+Zu2d/bWuzaZk1yTUy4mLxywvJeL6uX7vVKLMUZiYZazEXFiQDRmvTtogIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 27/11/14 12:56, Chanwoo Choi wrote:
> On 11/27/2014 08:41 PM, Arnd Bergmann wrote:
>> > On Thursday 27 November 2014 16:35:08 Chanwoo Choi wrote:
>>> >> +  - "samsung,exynos5433-cmu-bus0", "samsung,exynos5433-cmu-bus1"
>>> >> +    and "samsung,exynos5433-cmu-bus2" - clock controller compatible for CMU_BUS
>>> >> +    which generates global data buses clock and global peripheral buses clock.
>>> >>  
>>> >>  - reg: physical base address of the controller and length of memory mapped
>>> >>    region.
>>> >>
>> > 
>> > This looks like you are duplicating the bindings and the code, but
>> > it's really the same hardware multiple times with minor variations
>> > that you should be able to describe properly here. Why not make
>> > three nodes with the same compatible string and have them handled
>> > by the same code?
>
> Each CMU_BUSx domain of Exynos5433 have different base address as following:
> - CMU_BUS0's base address and range : 0x1360_0000 ~ 0x1360_0b04
> - CMU_BUS1's base address and range : 0x1480_0000 ~ 0x1480_0b04
> - CMU_BUS2's base address and range : 0x1340_0000 ~ 0x1340_0b04
> 
> So, I implement CMU_BUSx domain which has each compatible string.

You can always have multiple entries in the reg property. I've done
something like this for the exynos4415 CMU_ISPx units:

	cmu_isp: clock-controller@12060000 {
		compatible = "samsung,exynos4415-cmu-isp";
		reg = <0x12060000 0xB10>, <0x12070000 0xB10>;
		#clock-cells = <1>;

		assigned-clocks = <&cmu CLK_FOUT_ISP_PLL>;
		assigned-clock-rates = <300000000>;
	};

--
Regards,
Sylwester
