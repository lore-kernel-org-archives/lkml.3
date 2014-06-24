Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607AbaFXPf0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 11:35:26 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:33376 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032AbaFXPfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:35:24 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-6f-53a99ab9b028
From: Kamil Debski <k.debski@samsung.com>
To: "'Daniel Drake'" <drake@endlessm.com>
Cc: linux-kernel@vger.kernel.org,
        "'linux-samsung-soc'" <linux-samsung-soc@vger.kernel.org>,
        linux-usb@vger.kernel.org, kishon@ti.com,
        Tomasz Figa <t.figa@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>, gautam.vivek@samsung.com
References: <1403614495-9291-1-git-send-email-k.debski@samsung.com>
 <CAD8Lp441832-ZVV8FQChEXcLqVpZqygv3iaF95_SfZOH_xkFPg@mail.gmail.com>
In-reply-to: <CAD8Lp441832-ZVV8FQChEXcLqVpZqygv3iaF95_SfZOH_xkFPg@mail.gmail.com>
Subject: RE: [PATCH] phy: phy-samsung-usb2: Change phy power on/power off
 sequence
Date: Tue, 24 Jun 2014 17:35:20 +0200
Message-id: <074a01cf8fc1$e906f0c0$bb14d240$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+Pvj+QwVR3nYVBSCO1eRglxyupmwAAsf0g
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsVy+t/xa7o7Z60MNthwmM/i0fzHzBZtVw6y
	W1x42sNmcXnXHDaLGef3MVksWtbKbLH2yF12i/UzXrM4cHgs+p7l0bdlFaPH8RvbmTw+b5IL
	YInisklJzcksSy3St0vgyri/tIu5YD13xd2HO1kaGP9zdDFyckgImEicPbeOEcIWk7hwbz1b
	FyMXh5DAUkaJN+0LoZwGJol/+5aydzFycLAJaEqsuucB0iAioC6xcMVjFpAaZoFPjBJdezpY
	IRq6GCU6ln1hB6niFAiW+Lm5BaxZWCBE4t7SbJAwi4CqxLmvV5lAbF4BB4kTO1tYIWxBiR+T
	77GAlDMDLZgyJRckzCwgL7F5zVtmkLAEUPjRX10QU0TASOLDq1SIChGJuw3PWScwCs1CMmcW
	wpxZSObMQtKxgJFlFaNoamlyQXFSeq6hXnFibnFpXrpecn7uJkZIlHzZwbj4mNUhRgEORiUe
	3gu7VgQLsSaWFVfmHmKU4GBWEuE17V4ZLMSbklhZlVqUH19UmpNafIiRiYNTqoExYn38248y
	hba2f2Punj+z/NGrxBuu3VpLf9SV//jz5vv53b9WVayIWl3EXuaWv6kjc3lWpzHTK/8rnxi9
	ayzCeLQdZMV2yYf/F33z2Tvr/6q0eecMQ5kPrer/+czJ5oFsXmL+75zfO9PyiiYzp9t9mvR+
	U09Pdrzu1jphpvPPdh4ryj4ky3BeiaU4I9FQi7moOBEAH92c7nACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

> From: Daniel Drake [mailto:drake@endlessm.com]
> Sent: Tuesday, June 24, 2014 5:09 PM
> 
> On Tue, Jun 24, 2014 at 1:54 PM, Kamil Debski <k.debski@samsung.com>
> wrote:
> > The Exynos4412 USB 2.0 PHY hardware differs from the description
> > provided in the documentation. Some register bits have different
> > function. This patch fixes the defines of register bits and changes
> > the way how phys are powered on and off.
> 
> I guess this replaces the patch titled "drivers: phy: exynos4x12-phy:
> fix HSIC1 power on/off sequence"

Yes, indeed it replaces this patch. I did some more research on how the
hardware actually behaves.

> 
> Tested on ODROID-U2. Seems to be working as well as the previous patch:

Thank you very much for testing.

> - Internal SMSC hub works on boot and after reboot, tested with USB
> mouse
> - Internal SMSC ethernet device works on boot, but disappears upon
> reboot. (same as previous patch, also reproduced by Marek)

By reboot I guess that you mean typing "reboot" or by using SysRq magic
and not power cycling?

If so, I had experienced the same symptoms. I guess that the Ethernet
chip is not reset properly and fails to enumerate without power cycling
(it's nRESET pin is connected to P3V3).

I found that removing regulator-always-on from buck8_reg: BUCK8 in the
dts file fixes this problem.

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland


