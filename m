Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161895Ab3DEISi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 04:18:38 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:19467 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab3DEISf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 04:18:35 -0400
X-AuditID: cbfee690-b7f656d0000007e3-03-515e88d93232
Message-id: <515E88E3.5070507@samsung.com>
Date: Fri, 05 Apr 2013 17:18:43 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308
 Thunderbird/17.0.4
MIME-version: 1.0
To: Doug Anderson <dianders@chromium.org>
Cc: Chris Ball <cjb@laptop.org>, Will Newton <will.newton@gmail.com>,
        Seungwon Jeon <tgih.jun@samsung.com>, Bing Zhao <bzhao@marvell.com>,
        Ashok Nagarajan <asnagarajan@chromium.org>,
        Paul Stewart <pstew@chromium.org>, Olof Johansson <olof@lixom.net>,
        linux-mmc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] RFC: mmc: dw_mmc: Always go to STATE_DATA_BUSY from
 STATE_DATA_ERROR
References: <1363382956-14557-1-git-send-email-dianders@chromium.org>
 <5146EAB0.1030705@samsung.com>
 <CAD=FV=Ww-iK=-vg4jnJe6w4836-yQUoUyxNvCYsDQ5w0q-OMMQ@mail.gmail.com>
In-reply-to: <CAD=FV=Ww-iK=-vg4jnJe6w4836-yQUoUyxNvCYsDQ5w0q-OMMQ@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsVy+t8zTd2bHXGBBnNvSllsXhdvMW/rUVaL
	7a83slmcXXaQzeLyrjlsFkf+9zNanLr+mc1iw92prBYf7l9ktli46RCbA5fH7IaLLB47Z91l
	9zh0ZS2jx5UTTawekxdeZPbo27KK0ePzJrkA9igum5TUnMyy1CJ9uwSujAMdd5kLlrFUbH69
	gLmBcSlzFyMHh4SAicSE6SldjJxAppjEhXvr2boYuTiEBJYxSvQvf84KkTCRmH73LAtEYhGj
	xPeL05ghnJeMElt+T2IGqeIV0JL49LaZBcRmEVCVuLLqOFicTUBHYvu340wgtqhAmMSm6X2s
	EPWCEj8m3wOrFxHQlHjW8BJsKLPAbSaJVeePsoEkhAWiJT5tOcQOsW0to8Sj1QcYQRKcAsES
	T34cBpvKDLRhf+s0NghbXmLzmrdgkyQEvrJL7Hz6jxXiJAGJb5MPsUA8LSux6QAzxG+SEgdX
	3GCZwCg2C8lRs5CMnYVk7AJG5lWMoqkFyQXFSelFJnrFibnFpXnpesn5uZsYIbE6YQfjvQPW
	hxiTgVZOZJYSTc4HxnpeSbyhsZmRhamJqbGRuaUZacJK4rzqLdaBQgLpiSWp2ampBalF8UWl
	OanFhxiZODilGhgXeZrb2UhKi7D2Hbzz1nmX7d33k6PKGj6z9nZcSc0J2D7tsqR8rcD1Jzcd
	/k2fczrAc21GJNNzacM6TglV045pzlxqdb47LC1LZlTsbt9Uv8SnQO7Grqrqms9rHyyzY9yp
	wMQkZpilW/1gw8NOz37bnI3Bm1fvPfV7RoU6j8lE81r5J05/niqxFGckGmoxFxUnAgB1u6ey
	6wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGKsWRmVeSWpSXmKPExsVy+t9jAd2bHXGBBrPeilhsXhdvMW/rUVaL
	7a83slmcXXaQzeLyrjlsFkf+9zNanLr+mc1iw92prBYf7l9ktli46RCbA5fH7IaLLB47Z91l
	9zh0ZS2jx5UTTawekxdeZPbo27KK0ePzJrkA9qgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4
	UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoPuUFMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqG
	BMH1GBmggYR1jBkHOu4yFyxjqdj8egFzA+NS5i5GTg4JAROJ6XfPskDYYhIX7q1n62Lk4hAS
	WMQo8f3iNGYI5yWjxJbfk8A6eAW0JD69bQbrYBFQlbiy6jhYnE1AR2L7t+NMILaoQJjEpul9
	rBD1ghI/Jt8DqxcR0JR41vASbCizwG0miVXnj7KBJIQFoiU+bTnEDrFtLaPEo9UHGEESnALB
	Ek9+HAabygy0YX/rNDYIW15i85q3zBMYBWYhWTILSdksJGULGJlXMYqmFiQXFCel5xrqFSfm
	Fpfmpesl5+duYgSngmdSOxhXNlgcYhTgYFTi4c3oiw0UYk0sK67MPcQowcGsJMK7ky8uUIg3
	JbGyKrUoP76oNCe1+BBjMjAMJjJLiSbnA9NUXkm8obGJmZGlkZmxibmxMWnCSuK8B1qtA4UE
	0hNLUrNTUwtSi2C2MHFwSjUwHuhZJGmUZ+HCsLw1IGJSJbPW8Z1c3tXT9v6oa7Wpb9NqNWyc
	fuHR5PcrMnkym2UE5lXINJ5oCI8zXvPv5HvLyF+9DLNNfh0V2rBFfuK924yuicIl585xCei1
	tJ/yb0y4WTrX9MhT6dJ/OR/45k1MOnSu9ZJ/Dfs2YTVfq9lTLntNrZJTmsapxFKckWioxVxU
	nAgA4yGlAkkDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Doug,

You're right..it's something wrong.
Actually i didn't test with your patch, but your commit message is reasonable.

I will check until next week after test.

Best Regards,
Jaehoon Chung

On 03/27/2013 03:06 AM, Doug Anderson wrote:
> Jaehoon,
> 
> On Mon, Mar 18, 2013 at 3:21 AM, Jaehoon Chung <jh80.chung@samsung.com> wrote:
>> Hi Doug,
>>
>> Great..i have found the problem like this.
>> I will check your patch..and share the result.
> 
> Did you have any time to check this patch?
> 
> Thanks!
> 
> -Doug
> 

