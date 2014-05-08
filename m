Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465AbaEHIDb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 04:03:31 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:19320 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732AbaEHID2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 04:03:28 -0400
X-AuditID: cbfec7f5-b7fae6d000004d6d-bf-536b3a47d4a7
Message-id: <536B3946.9070106@samsung.com>
Date: Thu, 08 May 2014 11:59:02 +0400
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: Afzal Mohammed <afzal.mohd.ma@gmail.com>
Cc: linux@arm.linux.org.uk, open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm: memset: zero out upper bytes in r1
References: <1399273875-8403-1-git-send-email-a.ryabinin@samsung.com>
 <20140507234255.GA2050@afzal-ThinkPad-R50e>
In-reply-to: <20140507234255.GA2050@afzal-ThinkPad-R50e>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBLMWRmVeSWpSXmKPExsVy+t/xa7ruVtnBBnc2y1j837ia3WLT42us
	Fpd3zWGzuH2Z14HFo6W5h81j56y77B6bl9R7fN4kF8ASxWWTkpqTWZZapG+XwJXRPnsvU8FJ
	1orXS06zNTAuZeli5OSQEDCRWHLiIROELSZx4d56ti5GLg4hgaWMEmvW32GCcBqZJDpb97CB
	VPEKaEnMWXSFGcRmEVCVOLV+BtgkNgE9iX+ztoPViApESNxrPMwKUS8o8WPyPbAaEQEdidsv
	d4P1Mgt0MEq0b6oGsYUFbCRWrHgNVi8kUCyxf+pbMJtTwELi9rYORoh6HYn9rdPYIGx5ic1r
	3jJPYBSYhWTFLCRls5CULWBkXsUomlqaXFCclJ5rpFecmFtcmpeul5yfu4kRErpfdzAuPWZ1
	iFGAg1GJh3eBTEawEGtiWXFl7iFGCQ5mJRHeOJ7sYCHelMTKqtSi/Pii0pzU4kOMTBycUg2M
	drL7Gycd05Db6n9DRs1CXIyHV4r50K0WtSJj8U2ZbA0ygRVrmxjq3nw+Mp3Xbv296ybi0Qy8
	WyZYsne7cNj4RLwLWz+prGFbZQQjO7eo6tSof6sKbcSE11yLLtqoGfSZYTlr5SMp74U6exjD
	Clx29yklae3+xbW49ffpwsN1Hydbfn/qyq3EUpyRaKjFXFScCADOXnc2OwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/14 03:42, Afzal Mohammed wrote:
> 
> int is to be converted to unsigned char in memset, would having above
> change immediately upon entry to memset rather than at a place where it
> won't always execute make intention clearer ? (although it doesn't make
> difference)
> 

I think it's better to keep it near other manipulations with r1.
Plus this will save us from executing extra instruction on 'memset -> 6 -> 5 -> return'
path (memset for size <= 3).


> ubfx r1, r1, #0, #8 would have given the needed typecasting, but seems
> it is available only on ARMv6T2 & above.
> 

Indeed. It might be wrapped it with #if #else, but it will be a bit ugly,
probably not worth to do.




