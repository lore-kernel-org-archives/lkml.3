Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977AbaLWNlt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 08:41:49 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:11144 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755862AbaLWNlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 08:41:47 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-7a-549971188aa5
Message-id: <54997113.2080804@samsung.com>
Date: Tue, 23 Dec 2014 14:41:39 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
MIME-version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: tomasz.figa@gmail.com, kgene.kim@samsung.com, kyungmin.park@samsung.com,
        inki.dae@samsung.com, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3]  clk: samsung: Use samsung_cmu_register_one() to
 simplify code
References: <1419320423-19228-1-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1419320423-19228-1-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrELMWRmVeSWpSXmKPExsVy+t/xq7oShTNDDC68Y7K4/uU5q8Wk+xNY
	LHoXXGWzONv0ht3i8q45bBYzzu9jsli16w+jA7vHzll32T36tqxi9Pi8SS6AOYrLJiU1J7Ms
	tUjfLoEr48ufFawFZ7kqOlYfYGpgfMzRxcjJISFgIrHm3HxGCFtM4sK99WxdjFwcQgJLGSX+
	rlvOAuF8YpTonHaJFaSKV0BL4tizv2AdLAKqEs2Tb4PF2QQMJXqP9oHFRQUiJE7e3cMOUS8o
	8WPyPRYQW0RAQ2Lm3ytgNcwCyxglri2KBbGFBSIlPl3dzAxiCwm4Suz8PBesl1PATeLnzI9A
	vRxA9XoS9y9qQbTKS2xe85Z5AqPALCQbZiFUzUJStYCReRWjaGppckFxUnquoV5xYm5xaV66
	XnJ+7iZGSDh/2cG4+JjVIUYBDkYlHt6T72eECLEmlhVX5h5ilOBgVhLhlU+fGSLEm5JYWZVa
	lB9fVJqTWnyIkYmDU6qBMeT+l4n1c7qN+bQe8M455Sl4rC/tZJ3yu5VWj6c5vPqy9v2zRmfr
	OM7pqwxez9C5fzo1dtLNumcpQpe81iq8dwtTD+LMiRHkePfnz3UJv7dfIvrv3Ju8cIpBhnYW
	87fDURs2XY1YsF0u2+dYsFse65TLH668WKUiJL1Yeb93c1XUq4M5037+E1ViKc5INNRiLipO
	BABKPrnfRQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo,

On 23/12/14 08:40, Chanwoo Choi wrote:
> This patch-set uses the samsung_cmu_register_one() function to simplify the
> clock driver for Exynos3250/Exynos4415 SoC and change return value of
> samsung_cmu_register_one() because some clock driver may need the instance
> of samsung_clk_provider structure.
> 
> Chanwoo Choi (3):
>   clk: samsung: Changes the return value of samsung_cmu_register_one()
>   clk: samsung: exynos3250: Use samsung_cmu_register_one() to simplify code
>   clk: samsung: exynos4415: Use samsung_cmu_register_one() to simplify code
> 
>  drivers/clk/samsung/clk-exynos3250.c | 217 ++++++++---------------------------
>  drivers/clk/samsung/clk-exynos4415.c | 216 ++++++++--------------------------
>  drivers/clk/samsung/clk.c            |  13 ++-
>  drivers/clk/samsung/clk.h            |   3 +-
>  4 files changed, 107 insertions(+), 342 deletions(-)

Thanks for the cleanup, I've queued that for 3.20. And fixed a minor
checkpatch warning when applying:

ERROR: "foo* __init bar" should be "foo * __init bar"
#29: FILE: drivers/clk/samsung/clk.c:377:
+struct samsung_clk_provider* __init samsung_cmu_register_one(

total: 1 errors, 0 warnings, 42 lines checked

0001-clk-samsung-Changes-the-return-value-of-samsung_cmu_.patch has style
problems, please review.

-- 
Thanks,
Sylwester
