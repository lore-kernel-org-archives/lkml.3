Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561AbaDVGVw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 02:21:52 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:36012 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbaDVGVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 02:21:44 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-5d-53560a75e869
Message-id: <53560A6F.8030909@samsung.com>
Date: Tue, 22 Apr 2014 08:21:35 +0200
From: Robert Baldyga <r.baldyga@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        myungjoo.ham@samsung.com, cw00.choi@samsung.com, dbaryshkov@gmail.com,
        dwmw2@infradead.org, balbi@ti.com, gregkh@linuxfoundation.org,
        grant.likely@linaro.org, ldewangan@nvidia.com, kishon@ti.com,
        gg@slimlogic.co.uk, anton@enomsg.org, jonghwa3.lee@samsung.com,
        rongjun.ying@csr.com, linux@roeck-us.net, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, m.szyprowski@samsung.com,
        t.figa@samsung.com
Subject: Re: [PATCH v2 05/13] extcon: extcon-class: improve extcon client API
References: <1397475984-28001-1-git-send-email-r.baldyga@samsung.com>
 <1397475984-28001-6-git-send-email-r.baldyga@samsung.com>
 <20140419105225.GB976@ambient.musicnaut.iki.fi>
In-reply-to: <20140419105225.GB976@ambient.musicnaut.iki.fi>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0iTYRTHefZedknj9RZPUkSTypaZitGTDPND4PshoxAj+mJTl0qbyuZM
	A2teVjrSeammy8ylps6ppBZOvM6Vhhe0kSJeRqCVUzPF1NAst33x2++c8zvn/+WwMFcL7smK
	T0gWShIEIi7JwQd3+7+clXFuhPttWHyQ/kcI6n13GvVaHqKJ9e8EKppbwdAr0wiBCuuKMaRa
	0hJI1XoZ9ey0AZRV2USiEWsdQLnDcxganX9CouquehxpH1XhyNxeRqIXVSocvX6jwNCcdoiB
	GkwzTFQ9McZAUxm1JKpZ/keiAnUDjhoX1DhSdJqYqGt0h0BNJYt4yFFaX64HtDk/j0G3G8oI
	ukC1BmiDZoZJ19Wsk3Tfby1Ot9Ty6GZdLklb60sJenq8g6S7X+qZdF7WT5JeKNwmacOmnEnn
	t+rANbdbHH6MUBSfIpScC77NiXucnQmSTETq16dX5ECHKwGLBalA+NfoowTsPTwER2ebSCXg
	sFypagCbh6sIR7EKYHnOAmaznCkezFRO4zbGqRPQsjFJ2pikfGDrZgGwsQd1E85m9BEO3wVu
	Fc/afXfKG1q7VPajGFVNwI5fnQzbwI0Kg8PjE7gjrQVAdYXBvs2m+DBzstG+je0ldCuekw4+
	Blv0y1gBoDT7QjT7NM0+rQJgOuAhlEUnSaNixf6+UoFYKkuI9Y1OFDcDx1Ost4HKj0FGQLEA
	18kZ+kWEuxKCFGma2AggC+O6O8fu7LWcYwRp94WSxEiJTCSUGgGDxfaUg8g/bZ/CrBsRqVuf
	U86IQsN050OT00mv9JxVj+trAaecZC4Dkcqx/u0j0o27S4dLPgwWjX4zvVdzglbaoy4GL87c
	SdUEbJqvPuv3Kudvr8Lx4eQtNuxJcRe/9Z0/uLh7csqbP1RlFhx/MDBwIvvCmqU0XXSAN41F
	axWBVuOle3IuLo0T+PMwiVTwH4XVonTyAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2014 12:52 PM, Aaro Koskinen wrote:
> Hi,
> 
> On Mon, Apr 14, 2014 at 01:46:16PM +0200, Robert Baldyga wrote:
>>  	dev_info(&pdev->dev,
>> -		 "OMAP USB OTG controller rev %d.%d (%s, id=%d, vbus=%d)\n",
>> -		 (rev >> 4) & 0xf, rev & 0xf, config->extcon, otg_dev->id,
>> +		 "OMAP USB OTG controller rev %d.%d (id=%d, vbus=%d)\n",
>> +		 (rev >> 4) & 0xf, rev & 0xf, otg_dev->id,
>>  		 otg_dev->vbus);
> 
> This change is unrelated to the patch and not needed.
>

It's related because we no longer use config->extcon since we have
cable-oriented API. We can keep displaying it, but this value is
actually meaningless.

Best regards
Robert Baldyga
Samsung R&D Institute Poland
