Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759745AbaEMJJM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:09:12 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:53146 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759533AbaEMJJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:09:05 -0400
X-AuditID: cbfec7f5-b7fae6d000004d6d-c2-5371e12fbbc1
Message-id: <5371E12C.8000409@samsung.com>
Date: Tue, 13 May 2014 11:09:00 +0200
From: Andrzej Hajda <a.hajda@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: devicetree@vger.kernel.org, Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        linux-doc@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [RFC PATCH 0/2] drm/panel: add simple-panel description using DT
References: <1399645002-18000-1-git-send-email-boris.brezillon@free-electrons.com>
 <20140513075148.GF6754@ulmo>
In-reply-to: <20140513075148.GF6754@ulmo>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrALMWRmVeSWpSXmKPExsVy+t/xK7r6DwuDDX5N0rQ48GIhi8X8I+dY
	La58fc9mMXXXSUaLhW1LWCwu75rDZvHtcjO7xds701ksfu6ax+LA6bHg11YWjyebLjJ67Jx1
	l91j8wotj/vdx5k8lh438/i8SS6APYrLJiU1J7MstUjfLoErY8ayGYwFHzkrFsz9zNbA+JO9
	i5GTQ0LARKJxy1JWCFtM4sK99WxdjFwcQgJLGSUuTLjHDuF8YpQ4vGYSM0gVr4CWxLzZB9hA
	bBYBVYlnV5+AxdkENCX+br4JFOfgEBWIkHh8QQiiXFDix+R7LCC2iECqxN+mRywgM5kF/jJK
	rN73hREkISzgK7Fj9lQwW0igWGLZ+Utg8zmBZh6/dRHsUmYBHYn9rdPYIGx5ic1r3jJPYBSY
	hWTHLCRls5CULWBkXsUomlqaXFCclJ5rpFecmFtcmpeul5yfu4kREgtfdzAuPWZ1iFGAg1GJ
	h9eDuSBYiDWxrLgy9xCjBAezkgjvoauFwUK8KYmVValF+fFFpTmpxYcYmTg4pRoYGwM37Zvw
	nNPh51rdCPXqhqCld+bfEtskWXa8Wm8J/ym+/gtHKp7n/Gro+Psr4oFvn3DDnWPi/PcLThuu
	Pm9QYtJhnhfx2vXHhFMzvHLPN+lOqoj898nw31vRpdlCGsV6h2K2l91ItJrUxjvvo+eUYO9O
	iRPuGs6/sxTuJAaHz50lMzWw6PcBJZbijERDLeai4kQA+CAcRWMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2014 09:51 AM, Thierry Reding wrote:
> On Fri, May 09, 2014 at 04:16:40PM +0200, Boris BREZILLON wrote:
>> Hello Thierry,
>>
>> I noticed you're describing each new panel with a new entry in the
>> of_platform_match table and a new compatible string.
>> I guess you have a good reason to do it this way, because retrieving
>> panel description from DT would be pretty easy (see this series ;-)).
>>
>> Could tell me why you chose this approach ?
> 
> The reason is that devicetree mandates that a device be identified using
> a compatible value and that compatible value should be as specific as
> possible. That compatible value should give the device driver enough
> information to know everything it needs (resolution, timings, physical
> dimension).
> 
> Having all of that data in the device tree is redundant.
> 

Many panels I have encountered have no single timings, they accepts
ranges of timings. With 'compatible' approach there is no place to
configure timings specific for particular hw configuration, unless you
abuse somehow compatible string.

However it seems there are not so many cases the same panel must be used
with different timings on different boards, anyway it is a potential issue.

Regards
Andrzej
