Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809AbaD1JeE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 05:34:04 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:36811 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754545AbaD1Jd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 05:33:58 -0400
X-AuditID: cbfec7f5-b7fae6d000004d6d-83-535e20837180
Message-id: <535E208A.4050305@samsung.com>
Date: Mon, 28 Apr 2014 11:34:02 +0200
From: Robert Baldyga <r.baldyga@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        myungjoo.ham@samsung.com, cw00.choi@samsung.com, dbaryshkov@gmail.com,
        dwmw2@infradead.org, balbi@ti.com, grant.likely@linaro.org,
        ldewangan@nvidia.com, kishon@ti.com, gg@slimlogic.co.uk,
        anton@enomsg.org, jonghwa3.lee@samsung.com, rongjun.ying@csr.com,
        linux@roeck-us.net, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, aaro.koskinen@iki.fi,
        m.szyprowski@samsung.com, t.figa@samsung.com
Subject: Re: [PATCH v2 00/13] extcon: major rework
References: <1397475984-28001-1-git-send-email-r.baldyga@samsung.com>
 <20140424195203.GG12809@kroah.com>
In-reply-to: <20140424195203.GG12809@kroah.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02SfSzUcRzH+97v4X53Y/s5D32nNXWmlURU66shG3/8YmstradF/eKG8tQd
	iv7ozK7lyjkPC0dx5eI4rjwsJM96WHkowsJZTThFI08bU537x3+vz3uvz/vzz4fCBAbcnoqM
	iReJY9goIcnHP2y8HTyQuisk6GBRlSfSTfuitrp9qG38DhpanCJQ1sRvDBV19hAoU5uNoYxf
	agJl1Pqj1vV6gFKf6knUM6MFKK17AkN9Px6QSNNcgSP13RIc9TcWkqigJANHT57JMDSh/shB
	lZ1jXKQZ+sRBIyllJCqd/UsiZW4ljqqMuTiSve7koua+dQLp837ivjsZ3WMdYPoV6RymsaGQ
	YJQZC4BpUI1xGW3pIsl0LKlxpqbMmakuTyOZmYp8ghkdbCKZlkc6LpOeOkcyxsw1kmlYkXIZ
	RW05OGV9ke8VJoqKTBSJ3Xyu8CM2Rv7gcTX8W8Ub84QUvKTkgEdB+jDsf67GzGwH+wx6Ug74
	lIDWADggbeOYh3kA076oSJNlSTtDvbyLKwcUhdNOsOLFEVNM0i6wdkUJTGxLn4eGlA7CrFvB
	1WwDbmIbei80dn3FTZ0YXURA2dTk5oI17QFLtNpNFtDXYOW3d6Spn0e7weHic6YY+9/fIntI
	mtkB1uhmMSWgVVtOqLZoqi1aMcDKga0oITROcjU82sNVwkZLEmLCXUNjo6uB+SeW6oHmzbF2
	QFNAaGFp5X4pSECwiZKk6HYAKUxoY9kCQ4IElmFsUrJIHHtZnBAlkrQDDsWzl4KctnuxwxaR
	RgWvfTV4WmHIWvQvdf28LT7Zc4fLTRtvC7/R1HWjbNFnbvm9dtWLndTM57Dbzwq9T5zp6v5+
	ozk52PFQ7vIriZNycr/f7uO9jgb8dNBAYF05v79zfIk9eT/g9nWlXI2a8hfE47qCvKqjEw57
	gnPW7IoDL/TGtwZ0CXFJBOvujIkl7D/1xksH8QIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2014 09:52 PM, Greg KH wrote:
> On Mon, Apr 14, 2014 at 01:46:11PM +0200, Robert Baldyga wrote:
>> This patchset adds many improvements to extcon class driver and extcon
>> provider drivers. It changes extcon API to faster and safer by replaceing
>> function taking extcon and cable names with functions working with
>> structures representing this objects.
> 
> What is "faster" exactly?  How did you measure this?  What benchmarks
> can be run to test this claim?
> 

Most of new API functions are O(1), because they take as argument
pointer to struct extcon_cable, and operates on it. In contrast,
previous API functions needed to compare given cable name with name of
each cable specified in extcon controller. This solution was also prone
to errors - when you make typo in extcon name or cable name it will not
be detected at compilation time. The new API uses names only at
initialization, and after that each function takes pointer to struct
extcon_cable.

The old API is also fragile because defined list of cables could be
different in each extcon provider (the same cable could have different
name in each extcon provider), so using different extcon providers with
different drivers would need doing modifications in drivers.

Best regards
Robert Baldyga
Samsung R&D Institute Poland
