Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759383AbaJaNID (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 09:08:03 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:37268 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757928AbaJaNH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 09:07:59 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7f6c6d00000120b-91-545389ac9a3e
Content-transfer-encoding: 8BIT
Message-id: <1414760874.7318.15.camel@AMDC1943>
Subject: Re: [PATCH v3 01/14] mfd: max77686/802: Map regulator driver to its
 own of_node
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mark Brown <broonie@kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Chanwoo Choi <cw00.choi@samsung.com>
Date: Fri, 31 Oct 2014 14:07:54 +0100
In-reply-to: <20141031122330.GP18557@sirena.org.uk>
References: <1414668053-31370-1-git-send-email-k.kozlowski@samsung.com>
 <1414668053-31370-2-git-send-email-k.kozlowski@samsung.com>
 <20141031122330.GP18557@sirena.org.uk>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsVy+t/xy7prOoNDDA5PkLXYOGM9q8WkdQeY
	LKY+fMJmcf3Lc1aL+UfOsVoc/V1g0bvgKpvF2aY37Bb3vx5ltPh2pYPJYtPja6wWl3fNYbOY
	cX4fk8Xty7wWa4/cZbc43c3qIODR0tzD5vH3+XUWj7+rXjB77Jx1l91j06pONo871/awecw7
	GeixeUm9R9+WVYwenzfJBXBFcdmkpOZklqUW6dslcGVs33+ftaCJu+Jg1232BsZHHF2MnBwS
	AiYSjVeOskHYYhIX7q0Hsrk4hASWMkpMf7mQGSTBKyAo8WPyPZYuRg4OZgF5iSOXskHCzALq
	EpPmLWKGqP/MKLH533dGiHp9iembt4L1CgtESby5tBxsAZuAscTm5UvAbBEBZYmr3/eygDQz
	Czxgkdi/eC07SIJFQFXiycoeJhCbE6hhyoy/TBAb1jFKbH25hB3kCgmg7sZ+twmMArOQ3DcL
	4b5ZSO5bwMi8ilE0tTS5oDgpPddQrzgxt7g0L10vOT93EyMkzr7sYFx8zOoQowAHoxIP7wrJ
	4BAh1sSy4srcQ4wSHMxKIrw/OoBCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGPPFbgpLnHuS+YbD
	tGhx96Z9m+yzLQquM6o8s8qQzd178fsusfqmrSznz/b/WMDCPDVDrZy5jF2lWn35/r4Txuej
	+c8+Z5jh+Jj1oWjgk5n+N457b/W7sn9W791nTNrbXN40XZr+87hew0nd7G/M3v81GKYfSBH/
	qnZ2jeFrn2NKE0pemPV9/qPEUpyRaKjFXFScCACMuTYnkQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pią, 2014-10-31 at 12:23 +0000, Mark Brown wrote:
> On Thu, Oct 30, 2014 at 12:20:40PM +0100, Krzysztof Kozlowski wrote:
> > Add of_compatible fields for max77686 and max77802 regulator drivers.
> > The driver's node should be the same as voltage-regulators node. This
> > simplifies parsing of regulators init data from DTS.
> 
> No, this is broken.  You're introducing an ABI break that conveys no
> additional information, I can't see any reason why this should make it
> simpler to parse init data (you've certainly not articulated one in the
> changelog here) but even if it did you are changing the ABI incompatibly
> and convenience isn't a good reason to do that.

The ABI won't be broken - both drivers would work fine with old and new
DTB. However I agree that I should justify this more...

Javier and you explained me using parent's device for rdev->dev so I
think this change won't be needed and I'll just drop it.

Thank you for feedback.

> I'm getting very frustrated with what's going on with these drivers,
> there seem to be a lot of rather large sets of patches spawning lots of
> discussion but also frequent review problems and very little actually
> getting merged (look at the set of changes in the past few merge windows
> for example).  There's something going wrong here.

If I over-spammed you, then I am deeply sorry.

Best regards,
Krzysztof


