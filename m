Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423Ab3DLLwG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 07:52:06 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:44668 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755371Ab3DLLwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 07:52:04 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-fc-5167f561bf02
Date: Fri, 12 Apr 2013 11:52:01 +0000 (GMT)
From: =?euc-kr?B?x9S47cHW?= <myungjoo.ham@samsung.com>
Subject: Re: Re: [RESEND][PATCH 1/3] PM / devfreq: exynos4_bus: Fix missing
 mutex_unlock if opp_find_freq_floor fails
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Axel Lin <axel.lin@ingics.com>,
        =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        =?euc-kr?Q?=B1=E8=B1=B9=C1=F8?= <kgene.kim@samsung.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20130412115002607@myungjoo.ham
Msgkey: 20130412115002607@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130412115002607@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <15500134.204421365767518757.JavaMail.weblogic@epv6ml01>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAKsWRmVeSWpSXmKPExsWyRsSkWDfxa3qgwfJuMYvLu+awOTB6fN4k
	F8AYxWWTkpqTWZZapG+XwJXx4t5H5oJZ/BX7Lu5la2B8wtfFyMkhJKAusWjJSTYQW0LAROL1
	ql0sELaYxIV764HiXEA1Sxklvh66zgRTdK1vNhNEYj6jxP6PW9lBEiwCqhJLp+0Bsjk42ATM
	Je7PCAIJCwuUSsxctI4VpF5E4DijxP0zJ5hBHGaBdYwS0z4uYYY4Q0lizb5XYKt5BQQlTs58
	AnWGqsTGVTeZIeJqEs+3r4WKS0jMmn6BFcLmlZjR/hQqLicx7esaZghbWuL8rA2MMO8s/v4Y
	Ks4vcez2DiaQQ0F6n9wPhhmze/MXaEgISEw9cxCqVUviw4RuqPF8EmsWvmWBGbPr1HJmmN77
	W+aCA4hZQFFiSvdDdghbS+LLj31s6N7iFXCROP3yI/MERuVZSFKzkLTPQtKOrGYBI8sqRtHU
	guSC4qT0IlO94sTc4tK8dL3k/NxNjMDUcPrfs4k7GO8fsD7EmAyMk4nMUqLJ+cDUklcSb2hs
	ZmRhamJqbGRuaUaasJI4r3qLdaCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxuU3lN2FvaWS
	Jk/cd88zZ5Kd+o1Dt8X4Octe3LSZplN684R6td6D//vLp635w/HPZNGGR3NVfqfu7fUxP3JD
	qG3HY267FeaOdxzt5pRXq9QfDBBdznf8ztWe1prX5XX9l+Z53/mxd4NMdJyTSNyestms+zQ2
	Xdrx77xnzrwVzybHJHHl++gY5iuxFGckGmoxFxUnAgDrf+pvIwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkk+LIzCtJLcpLzFFi42I5/e/2DN3Er+mBBqd+8ltc3jWHzYHR4/Mm
	uQDGqDSbjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWhDcyM9IwM9UyM9Q+NYK0MDAyNToJqEtIwX
	9z4yF8zir9h3cS9bA+MTvi5GTg4hAXWJRUtOsoHYEgImEtf6ZjNB2GISF+6tB4pzAdXMZ5TY
	/3ErO0iCRUBVYum0PUA2BwebgLnE/RlBIGFhgVKJmYvWsYLUiwgcZ5S4f+YEM4jDLLCOUWLa
	xyXMENuUJNbse8UCYvMKCEqcnPmEBWKbqsTGVTeZIeJqEs+3r4WKS0jMmn6BFcLmlZjR/hQq
	Licx7esaZghbWuL8rA2MMFcv/v4YKs4vcez2DiaQQ0F6n9wPhhmze/MXqIcFJKaeOQjVqiXx
	YUI31Hg+iTUL37LAjNl1ajkzTO/9LXPBAcQsoCgxpfshO4StJfHlxz42dG/xCrhInH75kXkC
	o9wsJKlZSNpnIWlHVrOAkWUVo2hqQXJBcVJ6hYlecWJucWleul5yfu4mRnCCerZkB2PDBetD
	jAIcjEo8vC+E0wOFWBPLiitzDzFKcDArifDG7E0LFOJNSaysSi3Kjy8qzUktPsSYDIzBicxS
	osn5wOSZVxJvaGxsYmZiamliYWBqTpqwkjjvs1brQCGB9MSS1OzU1ILUIpgtTBycUg2Mi4Lm
	vnrQ+XhZ5jmlSRXrwvRSPjx0zwhVfrTF9nhxw5eM6lq74vjjHi8TLt2QfyaxUU5t5q9et687
	tQraPZ3SVyr/En22tee1o+Wb5vt32a+pOx5hr+9xNTi9IOab2pzuCSzLq05Vb4gLyL7lovKf
	1exjwvrHc1/c3+JpGXrg45UVx+4c+m3rpsRSnJFoqMVcVJwIAPXH38CUAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r3CBqC62012608

> On Friday, April 12, 2013 01:54:18 PM Axel Lin wrote:
> > We need to call mutex_unlock() in the error path.
> > 
> > Signed-off-by: Axel Lin <axel.lin@ingics.com>
> 
> All three patches applied to linux-pm.git/linux-next.
> 
> Exynos maintainers, if you have any objections, please holler.
> 
> Thanks,
> Rafael

This patch was included in the last pull-request patchset
though the path was updated. (its precedessor patch moved
exynos drivers to /drivers/devfreq/exynos/* after adding
Exynos common driver files)


Cheers,
MyungJoo.

> 
> > ---
> >  drivers/devfreq/exynos4_bus.c |    3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/devfreq/exynos4_bus.c b/drivers/devfreq/exynos4_bus.c
> > index 1deee09..54b9615 100644
> > --- a/drivers/devfreq/exynos4_bus.c
> > +++ b/drivers/devfreq/exynos4_bus.c
> > @@ -974,7 +974,8 @@ static int exynos4_busfreq_pm_notifier_event(struct notifier_block *this,
> >  			rcu_read_unlock();
> >  			dev_err(data->dev, "%s: unable to find a min freq\n",
> >  				__func__);
> > -			return PTR_ERR(opp);
> > +			err = PTR_ERR(opp);
> > +			goto unlock;
> >  		}
> >  		new_oppinfo.rate = opp_get_freq(opp);
> >  		new_oppinfo.volt = opp_get_voltage(opp);
> > 
> -- 
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
> 
> 
> 
>        
>   
>          
> 
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
