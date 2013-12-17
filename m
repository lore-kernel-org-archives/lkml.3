Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108Ab3LQN0n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 08:26:43 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:25250 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162Ab3LQN0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 08:26:40 -0500
X-AuditID: cbfec7f5-b7f6f6d000005b3b-c4-52b0510f6edb
From: Kamil Debski <k.debski@samsung.com>
To: "'Anton Tikhomirov'" <av.tikhomirov@samsung.com>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org
Cc: kyungmin.park@samsung.com, kishon@ti.com, Tomasz Figa <t.figa@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>, gautam.vivek@samsung.com,
        mat.krawczuk@gmail.com, yulgon.kim@samsung.com, p.paneri@samsung.com,
        jg1.han@samsung.com, galak@codeaurora.org, matt.porter@linaro.org
References: <1386246579-25141-1-git-send-email-k.debski@samsung.com>
 <1386246579-25141-4-git-send-email-k.debski@samsung.com>
 <006a01cef551$7fb4e240$7f1ea6c0$%tikhomirov@samsung.com>
In-reply-to: <006a01cef551$7fb4e240$7f1ea6c0$%tikhomirov@samsung.com>
Subject: RE: [PATCH v4 3/9] phy: Add new Exynos USB PHY driver
Date: Tue, 17 Dec 2013 14:26:37 +0100
Message-id: <02d201cefb2b$9e04e710$da0eb530$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7xtb/TcbT2JoEKQI6IBVag+SxyjgDmHfwwAXcg4IA=
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFIsWRmVeSWpSXmKPExsVy+t/xy7r8gRuCDOb+57ZYsvsGq8X8I+dY
	LfrfLGS1aLtykN3i8sJLrBYXnvawWZxtegPk7prDZjHj/D4mi0XLWpkt1h65y25xtv82m8XE
	pmnsFue3dDJZHH7TzmqxfsZrFouOswfZHQQ9Lvf1MnnsnHWX3ePOtT1sHn1bVjF6HL+xncnj
	8ya5ALYoLpuU1JzMstQifbsEroyL63rYCh6zVbRPn8HawLietYuRk0NCwETifU8/lC0mceHe
	erYuRi4OIYGljBIn9lxkh3AamCT+/1zC2MXIwcEmoCmx6p4HSFxEYB2jxNYns1hAHGaBy0wS
	R+6/ZYXo2MUosaV5EzvIXE4BV4nHO1cwg9jCAnYS57d3MYLYLAKqEoc6toLFeQUcJN5c/MwE
	YQtK/Jh8jwXEZhbQkli/8zgThC0vsXnNW2aQKyQE1CUe/dUFCYsIWEn8m9kDVS4icbfhOesE
	RqFZSCbNQjJpFpJJs5C0LGBkWcUomlqaXFCclJ5rpFecmFtcmpeul5yfu4kREp9fdzAuPWZ1
	iFGAg1GJh/fAsvVBQqyJZcWVuYcYJTiYlUR4v3lsCBLiTUmsrEotyo8vKs1JLT7EyMTBKdXA
	mPbxVlVdwd/3ly9t7zx+XD9n6d/Y0qQ9f5nu5XaGyWwXvTzV5saXtM4zD+5ESafznq7hXskg
	w/Nw1ZTde1alv2q5+f1AelHqbXHXqzz9xV8mLGTJPfn55LEjAgUrdAJYD/3zX3UuUWSuZau2
	tYznPRv2EE3uhwLWjyLCvzqkXXigtvW1f+kOYSWW4oxEQy3mouJEACO/jf6tAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anton,

> From: Anton Tikhomirov [mailto:av.tikhomirov@samsung.com]
> Sent: Tuesday, December 10, 2013 3:43 AM
> 
> Hi Kamil,
> 
> Same USB2.0 PHY may be used by several HCDs, for example EHCI and OHCI.
> Consider the situation, when EHCI stops using the PHY and calls
> power_off, then OHCI becomes non-operational. In other words, PHY
> power_on and power_off calls must be balanced.
> 
> Shall we handle it in your driver? (usage count?)

Please look in the drivers/phy/phy-core.c file. Usage count is handled
there - see phy_power_on and phy_power_off functions. I understand that
after both EHCI and OHCI power on the phy, the usage count is 2. So
powering off one of them (EHCI for instance) the usage count is still
1, so the OHCI should still work properly.

[snip]

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland


