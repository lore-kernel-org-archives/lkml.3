Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823AbaCDKGX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 05:06:23 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:38999 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756618AbaCDKGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 05:06:18 -0500
X-AuditID: cbfee690-b7f266d00000287c-ef-5315a59980be
Date: Tue, 04 Mar 2014 10:06:17 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH] PM / devfreq: Rewrite devfreq_update_status() to fix
 multiple bugs
To: Saravana Kannan <skannan@codeaurora.org>,
        =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20140304095513568@myungjoo.ham
Msgkey: 20140304095513568@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20140304095513568@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <8984550.302431393927576253.JavaMail.weblogic@epv6ml05>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42JZI2JSpDtzqWiwwbO3GhaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugSujY9tT5oJj7BUvfkg0MK5g72Lk5BASUJdYtOQkG4gtIWAisffC
	FnYIW0ziwr31QHEuoJqljBIXtk6FK3p2fwYLRGI+o8T5J6+ZQRIsAioSS8+0ANkcHGwCehIz
	PyeDhIUFwiVeXlnJAmKLCORL9O68yQTSyyzQxySxcv4jNogrlCTW7HsFVsQrIChxcuYTFpA5
	EgKqEpdusUGE1STunbsPdYOExKzpF1ghbF6JGe1PWSBsOYlpX9cwQ9jSEudnbWCEeWbx98dQ
	cX6JY7d3MEGM55V4cj8YZszuzV+gxgtITD1zEKpVS+Lxv2tQNp/EmoVvWWDG7Dq1nBmm9/6W
	uUwgNrOAosSU7ofsELaWxJcf+9hQfQViO0tMePiOZQKj8iwkqVlI2mchaUdWs4CRZRWjaGpB
	ckFxUnqRiV5xYm5xaV66XnJ+7iZGYFI4/e/ZhB2M9w5YH2JMBsbIRGYp0eR8YFLJK4k3NDYz
	sjA1MTU2Mrc0I01YSZxX7VFSkJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQbGzkLF1pUTw5Xd
	Mirjt5ecX1QtwSOU6d7e8T111w2JSE/u9YsUNj46u++KgjanQ7zNU4NDIY9Cph4U9hIxYf95
	783eGeJGOt7X1ucniarmzl/OUKIuqrAhW+rL5zvq1ju2xPqYv8p98/KpxJ+21TvKH+u6ri+Z
	84jl/DSvFzsfLCtudHuQdJhXiaU4I9FQi7moOBEAYHZhrCADAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHKsWRmVeSWpSXmKPExsVy+t/t6bozl4oGG7QcU7K4vGsOmwOjx+dN
	cgGMUWk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBD
	lRTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2StGG5kZ6RgZ6pkZ6hsaxVoYGBkamQDUJaRkd
	254yFxxjr3jxQ6KBcQV7FyMnh5CAusSiJSfZQGwJAROJZ/dnsEDYYhIX7q0HinMB1cxnlDj/
	5DUzSIJFQEVi6ZkWIJuDg01AT2Lm52SQsLBAuMTLKyvBekUE8iV6d95kAullFuhjklg5/xEb
	xDIliTX7XoEV8QoISpyc+YQFZI6EgKrEpVtsEGE1iXvn7kPdIyExa/oFVgibV2JG+1Oo2+Qk
	pn1dwwxhS0ucn7WBEebmxd8fQ8X5JY7d3sEEMZ5X4sn9YJgxuzd/gRovIDH1zEGoVi2Jx/+u
	Qdl8EmsWvmWBGbPr1HJmmN77W+YygdjMAooSU7ofskPYWhJffuxjQ/UViO0sMeHhO5YJjHKz
	kKRmIWmfhaQdWc0CRpZVjKKpBckFxUnpFSZ6xYm5xaV56XrJ+bmbGMGp6dmSHYwNF6wPMQpw
	MCrx8DpMEQkWYk0sK67MPcQowcGsJMKruFA0WIg3JbGyKrUoP76oNCe1+BBjMjD+JjJLiSbn
	A9NmXkm8obGxiZmJqaWJhYGpOWnCSuK8C24lBQkJpCeWpGanphakFsFsYeLglGpgnPxS3Gy1
	+cuUSXovGBtCj6/UtFY/0idR+mm595OqvfWK314cSl1RtZKFsc8iLu52ZvaK8yHP66P0hRb/
	KlhrbZngtuVFn5etqrpGX6bOrXANxf6Z7YbbnSbtPqYh6p84q+T1mnknl/nvkuZLObl5V/7D
	Sfc9NpizR95X/T7bcZmTDc+mW/42SizFGYmGWsxFxYkAU7boeJEDAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s24A6Xve002639

> The current devfreq_update_status() has the following bugs:
> - If previous frequency doesn't have a valid level, it does an out of bounds
>   access into the trans_table and causes memory corruption.
> - When the new frequency doesn't have a valid level, the time spent in the
>   new frequency is counted towards the next valid frequency switch instead of
>   being ignored.
> - The time spent on the previous frequency is added to the new frequency's
>   stats instead of the previous frequency's stats.
> 
> This patch fixes all of this.
> 
> Signed-off-by: Saravana Kannan <skannan@codeaurora.org>

Merged.

It appears to be Greg's LTS material as well.


Cheers,
MyungJoo

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
