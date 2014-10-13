Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946AbaJMNeo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 09:34:44 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:22255 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866AbaJMNel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 09:34:41 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-55-543bd4ef6f10
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Anton Vorontsov <anton@enomsg.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Chanwoo Choi <cw00.choi@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH 0/2] power: charger-manager: Fixes for unbinding other psy
Date: Mon, 13 Oct 2014 15:34:29 +0200
Message-id: <1413207271-23836-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHJMWRmVeSWpSXmKPExsVy+t/xy7rvr1iHGHRt4bI4uFXTYuOM9awW
	1788Z7WY9OQ9s8XElZOZLTrPPmG2eP3C0OJs0xt2i8u75rBZfO49wmix9shddovbjSvYLE7v
	LnHg9ZjQ/4nRY+esu+wem1doeWxa1cnm0bdlFaPH501yAWxRXDYpqTmZZalF+nYJXBlPvr9n
	KpjPVvF62UXGBsbfLF2MnBwSAiYS/zY8YoWwxSQu3FvP1sXIxSEksJRR4kBjIzuE08cksXzd
	BjaQKjYBY4nNy5eAVYkIPGWS6DzTyAjiMAvsYZT49mUHUIaDQ1jAS+LNYS6QBhYBVYmmlavA
	mnkF3CWmfl/JCLFOTuLkscmsExi5FzAyrGIUTS1NLihOSs811CtOzC0uzUvXS87P3cQICbMv
	OxgXH7M6xCjAwajEw2vxxypEiDWxrLgy9xCjBAezkgiv6CXrECHelMTKqtSi/Pii0pzU4kOM
	TBycUg2M0w7M3hbmvOOn6M5lp+O4HFh2Ft56vXS1ZcfWHb4GvLfUi84sWBb945ey+errsfev
	75xbL6P6e+56+9IbXXWaU1Zf+vlVzvj5v0zV7R9cFi5vzUm6cvzj3fmCUkXpitvmd0gqbmj4
	seeFmt05P7mWc4dWeF5d6Xnm215TJuYVa2JV+u4uOj6R9Y0SS3FGoqEWc1FxIgCcwkZeEQIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


These are two fixes for accessing old power supply by charger manager
after unbinding the driver implementing given power supply.

Actually the source of these two bugs and the solution for them is the
same in both patches. However I decided to split this because fixing
this was quite intrusive and squashed patch would be rather big.


Best regards,
Krzysztof


Krzysztof Kozlowski (2):
  power: charger-manager: Fix accessing invalidated power supply after
    fuel gauge unbind
  power: charger-manager: Fix accessing invalidated power supply after
    charger unbind

 drivers/power/charger-manager.c       | 161 +++++++++++++++++++++++-----------
 include/linux/power/charger-manager.h |   3 -
 2 files changed, 108 insertions(+), 56 deletions(-)

-- 
1.9.1

