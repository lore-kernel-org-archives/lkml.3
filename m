Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177AbaKDLJe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 06:09:34 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:44155 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbaKDLJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 06:09:29 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-62-5458b3e7e696
Message-id: <1415099366.7941.16.camel@AMDC1943>
Subject: Re: [PATCH v4 02/14] regulator: Add function to map modes to struct
 regulator_desc
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Mark Brown <broonie@kernel.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, Olof Johansson <olof@lixom.net>,
        Chris Zhong <zyw@rock-chips.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Date: Tue, 04 Nov 2014 12:09:26 +0100
In-reply-to: <5458B22D.8000209@collabora.co.uk>
References: <1415025649-8119-1-git-send-email-javier.martinez@collabora.co.uk>
 <1415025649-8119-3-git-send-email-javier.martinez@collabora.co.uk>
 <1415097072.7941.5.camel@AMDC1943> <5458B22D.8000209@collabora.co.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKLMWRmVeSWpSXmKPExsVy+t/xq7rPN0eEGGyZrGYx9eETNovrX56z
	Wsw/co7V4ujvAos1f5UsehdcZbO4vGsOm8WM8/uYLE5d/8xmMf/BDmYHLo+/z6+zeOycdZfd
	Y9OqTjaPKyeaWD3+ztrP4tG3ZRWjx+dNcgHsUVw2Kak5mWWpRfp2CVwZ554tZCq4wlPx8+ph
	xgbGu5xdjJwcEgImEgcmXWeHsMUkLtxbz9bFyMUhJLCUUeLw4YXMEM5nRollL6+xgVTxCuhL
	fJy1BMwWFoiVWHBxJVg3m4CxxOblEHERATuJG6sfgjUzCxxjkpi5ah1LFyMHB4uAqsSq3WCb
	OYHmfLpxiBFiwW1GiZ0L97KAJJgF1CUmzVvEDFIvIaAs0djvBrFXUOLH5HtQJfISm9e8ZZ7A
	KDALSccsJGWzkJQtYGRexSiaWppcUJyUnmukV5yYW1yal66XnJ+7iRESFV93MC49ZnWIUYCD
	UYmHd0V8RIgQa2JZcWXuIUYJDmYlEd7VVUAh3pTEyqrUovz4otKc1OJDjEwcnFINjEx6R340
	n+h84XtP586T5102ltzqWw2iBI/ZWCf6x7sW/1UvzLR8r8m6p23Hakmuh8kxgqcPXTAPEJn7
	Y8bUyPN1s9XqJwaLiB3nFlh1ZO6rI3ElG73yt/SeC8nPlP0V4/ddjm9blR3nN+n4BUmcP33u
	7Zwbv847NHpflUfV49uNQkdvm+3yV2Ipzkg01GIuKk4EAB67Ta1oAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wto, 2014-11-04 at 12:02 +0100, Javier Martinez Canillas wrote:
> Hello Krzysztof,
> 
> Thanks a for your feedback.
> 
> On 11/04/2014 11:31 AM, Krzysztof Kozlowski wrote:
> >> + *
> >> + * @map_modes: Callback invoked to translate between hardware to standard modes.
> > 
> > Initially I thought it should map from standard to hardware. But then I
> > looked at max77802 implementation and it maps from hardware to standard.
> > Anyway I got confused (both are "modes" and both unsigned ints).
> > 
> > Could you describe which should be returned?
> > 
> 
> Sure, maybe rewording to:
> 
> "Callback invoked to translate from hardware to standard modes." ?
> 
> But I'll add also document that the parameter should be a hardware
> mode and the return value a standard mode.

Great!

> 
>  >>   */
> >>  struct regulator_desc {
> >>  	const char *name;
> >> @@ -285,6 +287,8 @@ struct regulator_desc {
> >>  	unsigned int enable_time;
> >>  
> >>  	unsigned int off_on_delay;
> >> +
> >> +	unsigned int (*map_modes)(unsigned int mode);
> > 
> > Shouldn't this be in regulator ops?
> > 
> 
> regulator ops are for the operations that a regulator support
> (enable, disable, set mode, etc). All the thse are actions but
> how to translate between hardware and standard modes is not an
> action but a non-varying configuration of the regulator.
> 
> So I believe that regulator desc was what fit the most. I don't
> have a strong opinion though if people think that it should be
> in regulator ops instead.

I understand, it's fine for me.

Best regards,
Krzysztof


