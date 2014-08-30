Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751111AbaH3C12 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 22:27:28 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:31434 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbaH3C1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 22:27:24 -0400
X-AuditID: cbfee690-f79ce6d00000115a-93-5401368ac92c
From: Inha Song <ideal.song@samsung.com>
To: broonie@kernel.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sameo@linux.intel.com, lee.jones@linaro.org,
        ckeepax@opensource.wolfsonmicro.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        alsa-devel@alsa-project.org, cw00.choi@samsung.com,
        Inha Song <ideal.song@samsung.com>
Subject: [alsa-devel] [PATCH v5 0/2] mfd: arizona: add support for INn_MODE
 register control
Date: Sat, 30 Aug 2014 11:27:17 +0900
Message-id: <1409365639-5320-1-git-send-email-ideal.song@samsung.com>
X-Mailer: git-send-email 2.0.0.390.gcb682f8
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkkeLIzCtJLcpLzFFi42JZI2JSrNtlxhhisOOUmcWVi4eYLKY+fMJm
	8W/KDXaL61+es1rMP3KO1aL/zUJWi11/7zNanHu1ktHi/tejjBaXd81hs1h6/SKTxfK3/9ks
	Jkxfy2LRuvcIu8XpblYHfo8Nn5vYPNbMW8Pocbmvl8lj5fIvbB6bVnWyedy5tofNY97JQI+X
	E3+zefRtWcXo8XmTXABXFJdNSmpOZllqkb5dAlfG8//aBc/YKh7dn8jWwLiKtYuRg0NCwETi
	Q29hFyMnkCkmceHeerYuRi4OIYGljBKvvt5gh0iYSLx/OoERIjGdUeLBu5dQzhwmiR0zDjCC
	VLEJaEh8/7yZGcQWARp1e04nM0gRs0AHs8SUbbsYQdYJC8RJfLtiAVLDIqAq0fuoBayXV8BV
	Ys+5s1DbtCX2NcwEO0NC4Ba7xI7eVewQDQIS3yYfYoE4W1Zi0wFmiHpJiYMrbrBMYBRcwMiw
	ilE0tSC5oDgpvchErzgxt7g0L10vOT93EyMwZk7/ezZhB+O9A9aHGAU4GJV4eC+8ZAgRYk0s
	K67MPcRoCrRhIrOUaHI+MDLzSuINjc2MLExNTI2NzC3NlMR5X0v9DBYSSE8sSc1OTS1ILYov
	Ks1JLT7EyMTBKdXAmBcgbXBC3cP7StUR2ev97omMtnMfbG9gSz9rXcYVlBh5Z2Xzp6wrny00
	Nv94fapawfL5j/Wzjxw7uDOst3BSbsrHu6qmLFNeOTgcS2Ir+SF0adLby21VS3b0v8o/b7Z7
	dlDphpJVygziH04FfjsmOOEYu0jOdVef54t7HE4vnhUV5l2soi/6TYmlOCPRUIu5qDgRAJAu
	MleUAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsVy+t9jQd0uM8YQg4e79CyuXDzEZDH14RM2
	i39TbrBbXP/ynNVi/pFzrBb9bxayWuz6e5/R4tyrlYwW978eZbS4vGsOm8XS6xeZLJa//c9m
	MWH6WhaL1r1H2C1Od7M68Hts+NzE5rFm3hpGj8t9vUweK5d/YfPYtKqTzePOtT1sHvNOBnq8
	nPibzaNvyypGj8+b5AK4ohoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPIS
	c1NtlVx8AnTdMnOA3lBSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYwZjz/
	r13wjK3i0f2JbA2Mq1i7GDk5JARMJN4/ncAIYYtJXLi3nq2LkYtDSGA6o8SDdy8ZIZw5TBI7
	ZhwAq2IT0JD4/nkzM4gtAtRxe04nM0gRs0AHs8SUbbuAijg4hAXiJL5dsQCpYRFQleh91ALW
	yyvgKrHn3Fl2iG3aEvsaZrJNYORewMiwilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4Jp9J
	7WBc2WBxiFGAg1GJh/fCS4YQIdbEsuLK3EOMEhzMSiK8Uo+BQrwpiZVVqUX58UWlOanFhxhN
	gbZPZJYSTc4Hpou8knhDYxMzI0sjc0MLI2NzJXHeA63WgUIC6YklqdmpqQWpRTB9TBycUg2M
	jV9PT2qo/VnWPnGVQFzap/lbOrVqeOdtnH5rUdL93osSrjelX08o+6x809Jw+oSgYmH/s3GZ
	u1K+Hm/ccyBzT1rb+4CiBHmLhav3nb4Wum535Q2d7+vjgtdc1lvNoNhwoFEwWCBivVi6l6ut
	wCnrVSofn7xy13ea57u93/NOsvza3sCmqetqlViKMxINtZiLihMBIhQrDN8CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series add support for INn_MODE register control using platform data.
Each input signal path can be configurated either as a Analogue or Digital using
the INn_MODE registers.

Changes for v5
- Change to use of_property_for_each_u32

Changes for v4
- Update document content for more clarity

Changes for v3
- Change to use of_property_read_u32_array
- Fix a few typos
- Update commit message

Changes for v2
- Change to support
- Update commit message
- Update document content for more clarity

Inha Song (2):
  mfd: arizona: Add support for INn_Mode register control
  mfd: arizona: Update DT binding to support INn_MODE init_data

 Documentation/devicetree/bindings/mfd/arizona.txt |  7 +++++++
 drivers/mfd/arizona-core.c                        | 13 +++++++++++++
 2 files changed, 20 insertions(+)

-- 
2.0.0.390.gcb682f8

