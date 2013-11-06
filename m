Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932538Ab3KFNX7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 08:23:59 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:62771 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932208Ab3KFNXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 08:23:55 -0500
Date: Wed, 06 Nov 2013 14:23:48 +0100
From: Tomasz Figa <t.figa@samsung.com>
Subject: Re: [PATCH v3 1/3] phy: Add new Exynos USB PHY driver
In-reply-to: <AE90C24D6B3A694183C094C60CF0A2F6026B73E7@saturn3.aculab.com>
To: David Laight <David.Laight@aculab.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        Kamil Debski <k.debski@samsung.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm@vger.kernel.org,
        kyungmin.park@samsung.com, s.nawrocki@samsung.com,
        m.szyprowski@samsung.com, gautam.vivek@samsung.com,
        mat.krawczuk@gmail.com, yulgon.kim@samsung.com, p.paneri@samsung.com,
        av.tikhomirov@samsung.com, jg1.han@samsung.com, galak@codeaurora.org
Message-id: <10911451.fGryrFqfmX@amdc1227>
Organization: Samsung Poland R&D Center
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7Bit
X-AuditID: cbfec7f4-b7f0a6d000007b1b-c9-527a42e91576
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42I5/e/4Fd2XTlVBBlun8Fks2X2D1WLH0s1M
	FvOPnGO16H+zkNWi7cpBdovLCy+xWvx4fYHN4sLTHjaLs01v2C2m7fzPanF51xw2ixnn9zFZ
	LFrWymyx9shddouz/bfZLM5v6WSyOPymndWi4+xBdgchj/7ZU9g8Lvf1MnnsnHWX3aNvyypG
	j+M3tjN5fN4kF8AWxWWTkpqTWZZapG+XwJXR+WEZa8FizopdP6+yNzCuZ+9i5OSQEDCRWPLv
	GxuELSZx4d56IJuLQ0hgKaPEt1ubWSCcLiaJa+dfMoJUsQmoSXxueATWISKgJXF95zNmkCJm
	gcfMEmtWTmMBSQgL2Ek8On8ArIFFQFXixNaHTCA2L1DDx4ubwWx+AXWJd9uegtmiAm4S038c
	ZAaxOQW8JN4/mckOsXkJo8SFgz+ZIZoFJX5Mvge2gFlAXmLf/qmsELaWxPqdx5kmMArOQlI2
	C0nZLCRlCxiZVzGKppYmFxQnpeca6hUn5haX5qXrJefnbmKExN6XHYyLj1kdYhTgYFTi4U2Q
	rwwSYk0sK67MPcQowcGsJMJrZVAVJMSbklhZlVqUH19UmpNafIiRiYNTqoHRslO7qn2mgULQ
	lky2b+nP10WIea629Jie8GdK2f/lKdLuipu0Fk9+HfzYLmJTyCGTuKlhNqH5ieapL4XfbWOp
	uLz0+jzJ9hAViWDJac7cP/eLl53/4u/t2vh5xaszpRsT9hXnnLo+yf+ksMrH3msPMor8z/Js
	cJ8jXXgkwqR/6au/c1v4nlxTYinOSDTUYi4qTgQAidB2VpsCAAA=
References: <1383668001-19141-1-git-send-email-k.debski@samsung.com>
 <2413995.ezl3Ca2YTh@amdc1227>
 <AE90C24D6B3A694183C094C60CF0A2F6026B73E7@saturn3.aculab.com>
User-Agent: KMail/4.11.2 (Linux/3.11.5-gentoo; KDE/4.11.2; x86_64; ; )
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Wednesday 06 of November 2013 13:03:45 David Laight wrote:
> > > I just did a diff of registers in exynos 4210 and 4212 PHY drivers [1]
> > > and couldn't find that big a difference in register layout. Of course
> > > there are a few changes in HSIC bit fields and PHYFSEL but that's only
> > > minimal and could well be handled in a single driver.
> > >
> > > [1] -> http://diffchecker.com/py3tp68m
> > 
> > This is quite a lot of differences, especially including shifted
> > bitfields... In addition there is another set of available PHYs
> > and inter-dependencies between them.
> 
> Might be worth feeding both files through "sed -e 's/_421[02]_/_421x_/'"
> prior to doing the diff.
> And maybe changing the order of some definitions so they match.
> Then the actual differences will be more obvious.

I have fed it already through my built-in sed when reading.

Still despite many similarities, I think there is enough difference to
justify having different callback functions for both, especially based on
my experience with the old Exynos USB2 PHY driver in drivers/usb/phy, when
trying to make it more complete.

Best regards,
Tomasz

