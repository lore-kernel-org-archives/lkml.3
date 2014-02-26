Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692AbaBZFMQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 00:12:16 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:55545 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656AbaBZFMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 00:12:07 -0500
X-AuditID: cbfee68d-b7fcd6d00000315b-91-530d77a34e33
Date: Wed, 26 Feb 2014 05:12:03 +0000 (GMT)
From: =?euc-kr?B?x9S47cHW?= <myungjoo.ham@samsung.com>
Subject: Re: Re: [PATCH] PM / devfreq: Fix out of bounds access of transition
 table array
To: Saravana Kannan <skannan@codeaurora.org>
Cc: =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20140226051127859@myungjoo.ham
Msgkey: 20140226051127859@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20140226051127859@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <19338058.266151393391521988.JavaMail.weblogic@epml02>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjleLIzCtJLcpLzFFi42JZI2JSpLu4nDfY4OVnIYvLu+awOTB6fN4k
	F8AYxWWTkpqTWZZapG+XwJWxdHUvU8Emnorna68zNzC28HQxcnIICahLLFpykg3ElhAwkZh7
	+iELhC0mceHeeqA4F1DNUkaJl9dOM8EUzXo2iwUiMZ9Rovv/ckaQBIuAqsTvX6uAOjg42ATM
	Je7PCAIJCwtESly7MRVsgYiAnsSRphWsIL3MAueZJC52nWKCuEJJYs2+V2CbeQUEJU7OfAJ1
	hapE17rJrCAzeQXUJFoehUCEJSRmTb/ACmHzSsxofwpVLicx7esaZghbWuL8rA2MMM8s/v4Y
	Ks4vcez2DiaQkSC9T+4Hw4zZvfkLNBwEJKaeOQjVqiUxvXEP1Co+iTUL37LAjNl1ajkzTO/9
	LXPBPmEWUJSY0v2QHcLWkvjyYx8buq94BZwkPj57wj6BUXkWktQsJO2zkLQjq1nAyLKKUTS1
	ILmgOCm9yFCvODG3uDQvXS85P3cTIzAtnP73rHcH4+0D1ocYk4ExMpFZSjQ5H5hW8kriDY3N
	jCxMTUyNjcwtzUgTVhLnTXqYFCQkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qB8bg8Qw67NLOY
	a9eRqx2uVr2vrz6VC7v7NrhtMXPJ4x/Pbmm9v7C49d+cvlBvlnj2qedv/zDi43SfdfZvHFtr
	1a6LdicfxLFld8jbZBW1i9gqyUtHXdF/rrxmDtMP9p1/P1ifkbsj7jvnn+TyGwaldnHHlugn
	Jf3REPggv3zDk+1eX1cI+GaUKLEUZyQaajEXFScCAAj3M5khAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPKsWRmVeSWpSXmKPExsVy+t/tGbqLy3mDDfYs5bG4vGsOmwOjx+dN
	cgGMUWk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBD
	lRTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2StGG5kZ6RgZ6pkZ6hsaxVoYGBkamQDUJaRlL
	V/cyFWziqXi+9jpzA2MLTxcjJ4eQgLrEoiUn2UBsCQETiVnPZrFA2GISF+6tB4pzAdXMZ5To
	/r+cESTBIqAq8fvXKqAEBwebgLnE/RlBIGFhgUiJazemgs0REdCTONK0ghWkl1ngPJPExa5T
	TBDLlCTW7HsFtoBXQFDi5MwnUMtUJbrWTWYFmckroCbR8igEIiwhMWv6BVYIm1diRvtTqHI5
	iWlf1zBD2NIS52dtYIS5efH3x1Bxfoljt3cwgYwE6X1yPxhmzO7NX6DeFZCYeuYgVKuWxPTG
	PVCr+CTWLHzLAjNm16nlzDC997fMBfuEWUBRYkr3Q3YIW0viy499bOi+4hVwkvj47An7BEa5
	WUhSs5C0z0LSjqxmASPLKkbR1ILkguKk9AoTveLE3OLSvHS95PzcTYzg5PRsyQ7GhgvWhxgF
	OBiVeHgDWHiDhVgTy4orcw8xSnAwK4nwSmcDhXhTEiurUovy44tKc1KLDzEmA+NvIrOUaHI+
	MHHmlcQbGhubmJmYWppYGJiakyasJM674FZSkJBAemJJanZqakFqEcwWJg5OqQZGXVN/ps12
	64Juu9wTqJxTLt0mliZSUOSyqGt+0trW8Itlebw63k+uTVEQ3fH1bOjJ/uOr2GZymUYwX6q9
	4H+ufibHmxKGmvLv26Xn+i/W6+p7uktOoXv6rb8mPRP+rpsf8WiblrBV9TeuK4lTPp+ccOj3
	qrkTXnZ1M02XKYv+O2Hy5cmaPWumKLEUZyQaajEXFScCAOZZLhmSAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s1Q5CPhe027999

> On 02/23/2014 11:15 PM, Saravana Kannan wrote:
> > The previous_freq value for a device could be an invalid frequency that
> > results in a error value being returned from devfreq_get_freq_level().
> > Check for an error value before using that to index into the transition
> > table.
> >
> > Not doing this check will result in memory corruption when previous_freq is
> > not a valid frequency.
> >
> > Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
> 
> MyungJoo/Kyungmin,
> 
> Would either of you have some time to respond to this?
> 
> Thanks,
> Saravana

Dear Saravana,

> > +	prev_lev = devfreq_get_freq_level(devfreq, devfreq->previous_freq);
> > +	if (prev_lev < 0)
> > +		return 0;

If devfreq_get_freq_level returned error, please return that error
to the caller. You are retuning 0 in that case.

Plus, do you think we are going to change profile->freq_table in run-time?
(by accidently? or intentionally?)

Cheers,
MyungJoo.

> 
> 
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
> 
> 
> 
>        
>   
>          
> 
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
