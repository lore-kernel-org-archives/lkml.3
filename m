Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955AbaBGKqU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 05:46:20 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:38119 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbaBGKqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 05:46:18 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-5c-52f4b9787a4e
Message-id: <1391769974.12119.1.camel@AMDC1943>
Subject: Re: [PATCH v2 14/15] charger: max14577: Configure battery-dependent
 settings from DTS
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, Jenny Tc <jenny.tc@intel.com>
Date: Fri, 07 Feb 2014 11:46:14 +0100
In-reply-to: <20140207104238.GH14727@lee--X1>
References: <1391767487-10017-1-git-send-email-k.kozlowski@samsung.com>
 <1391767487-10017-15-git-send-email-k.kozlowski@samsung.com>
 <20140207104238.GH14727@lee--X1>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLLMWRmVeSWpSXmKPExsVy+t/xa7oVO78EGTw4z2+xccZ6VoupD5+w
	WVz/8pzVYtKT98wWE1dOZrZY+7WH3eJs0xt2i/tfjzJabHp8jdXi8q45bBZrj9xlt7jduILN
	4nQ3qwOvx85Zd9k9Nq/Q8li85yWTx6ZVnWwed67tYfOYdzLQY/OSeo++LasYPT5vkgvgjOKy
	SUnNySxLLdK3S+DK6G3axVpwlbuic8EbxgbGiZxdjJwcEgImEnd/zGaEsMUkLtxbz9bFyMUh
	JLCUUeLmnwlMEM5nRonFjx6zglTxCuhLzHg5jQ3EFhZIkNg28QwLiM0mYCyxefkSoDgHh4iA
	isS5N+YgvcwCH5glTj2dwQxSwyKgKtH68AbYNk4BXYn/K3+wQyxYySgx+1Un2FBmAXWJSfMW
	MUOcpCSxu72THSIuL7F5zVtmiCMEJX5MvscygVFgFpKWWUjKZiEpW8DIvIpRNLU0uaA4KT3X
	UK84Mbe4NC9dLzk/dxMjJIq+7GBcfMzqEKMAB6MSD++JpZ+DhFgTy4orcw8xSnAwK4nwSm74
	EiTEm5JYWZValB9fVJqTWnyIkYmDU6qBUSty0meRqSEnDQNtDFyjs+8/V+1XTFzawJjgGzZz
	/up57dtd5wtIJHgF8Oc8WbXb59eJ+is/tHN+y7tGbjl2/7pJxPIzZTWFy17u+3dQdZJhSN71
	a2mK18zszx3/ev5awRwlBs4Ij5qvbl/fBZh03p7kvYlPj22j8y/1kIO2Wxy6GDyk/TiPKbEU
	ZyQaajEXFScCAIbFXHqAAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-02-07 at 10:42 +0000, Lee Jones wrote:
> > Remove hard-coded values for:
> >  - Fast Charge current,
> >  - End Of Charge current,
> >  - Fast Charge timer,
> >  - Overvoltage Protection Threshold,
> >  - Battery Constant Voltage,
> > and use DTS to configure them. This allows using the max14577 charger
> > driver with different batteries.
> > 
> > Now the charger driver requires valid configuration data from DTS. In
> > case of wrong configuration data it fails during probe. Patch adds
> > of_compatible to the charger mfd cell in MFD driver core.
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> 
> I already acked the MFD parts of this. Or has the patch changed?

Hi,

This patch is new in v2 so you haven't acked it yet. I need your ACK
here and in 13/15 (regulator/mfd: max14577: Export symbols for
calculating charger current).

Best regards,
Krzysztof


> > Cc: Kyungmin Park <kyungmin.park@samsung.com>
> > Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> > Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> > Cc: David Woodhouse <dwmw2@infradead.org>
> > Cc: Jenny Tc <jenny.tc@intel.com>
> > ---
> >  drivers/mfd/max14577.c               |    5 +-
> >  drivers/power/max14577_charger.c     |  234 +++++++++++++++++++++++++++++-----
> >  include/linux/mfd/max14577-private.h |   10 ++
> >  include/linux/mfd/max14577.h         |    8 ++
> >  4 files changed, 227 insertions(+), 30 deletions(-)
> 

