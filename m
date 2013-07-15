Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758310Ab3GOXEB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 19:04:01 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:36846 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754695Ab3GOXD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 19:03:58 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-33-51e47fdc81ef
Message-id: <51E47FDC.1020202@samsung.com>
Date: Tue, 16 Jul 2013 08:03:56 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: balbi@ti.com
Cc: Kishon Vijay Abraham I <kishon@ti.com>, myungjoo.ham@samsung.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, grant.likely@linaro.org,
        rob.herring@calxeda.com, rob@landley.net, gregkh@linuxfoundation.org,
        benoit.cousson@linaro.org
Subject: Re: [PATCH v6] usb: dwc3: use extcon fwrk to receive connect/disconnect
References: <1373902742-9495-1-git-send-email-kishon@ti.com>
 <20130715155106.GE32035@arwen.pp.htv.fi>
In-reply-to: <20130715155106.GE32035@arwen.pp.htv.fi>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDIsWRmVeSWpSXmKPExsWyRsSkQPdO/ZNAg575lhYH79dbzPx0k83i
	wOyHrBYH/uxgtGhevJ7N4sLTHjaLhW1LWCwu75rDZjF7ST+LxaJlrcwWtxtXsFkcXnGAyWLd
	y+ksDrweCz5fYfd4tXomq8eda3vYPPbPXcPucX7GQkaPvi2rGD2O39jO5PF5k1wARxSXTUpq
	TmZZapG+XQJXRu/7dYwFyxUrvr5Zw9TAuEq6i5GTQ0LAROLx+WnsELaYxIV769m6GLk4hASW
	MkpMvbGUHaZowe5+FojEIkaJHwefs0M4rxglDt2eyQhSxSugJXHu1UwWEJtFQFVi4cH1YDYb
	UHz/ixtsILaoQJjEyulXWCDqBSV+TL4HZosICEisf3EJbCizwG0miUuXfjKDJIQFAiQ+fvkA
	doaQQLrEvC3fmEBsTgFTiRezesGGMgvoSOxvnQZly0tsXvOWGWSQhEAvh8TC998ZIS4SkPg2
	+RDQNg6ghKzEpgPMEK9JShxccYNlAqPYLCQ3zUIydhaSsQsYmVcxiqYWJBcUJ6UXGeoVJ+YW
	l+al6yXn525iBMb06X/Pencw3j5gfYgxGWjlRGYp0eR8YErIK4k3NDYzsjA1MTU2Mrc0I01Y
	SZxXrcU6EOj/xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYxeOXXct66eS03e273Y7rn5JL2nGa1q
	J2JPlPDwHVo907bX6sar06d9K87UnWF9cmQyQ8dBHxtp742rE0pnr1to8IvjZt5hMQ8FdymW
	qKkrmgo38M9addjm1Za7m085T54fedXENHPnMf5JjT1PGf+Y/vLSjlC5z6jjGnpaW/zQ9iN7
	PmrNYFmuxFKckWioxVxUnAgAxblqrv8CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJKsWRmVeSWpSXmKPExsVy+t9jAd079U8CDY4c0Lc4eL/eYuanm2wW
	B2Y/ZLU48GcHo0Xz4vVsFhee9rBZLGxbwmJxedccNovZS/pZLBYta2W2uN24gs3i8IoDTBbr
	Xk5nceD1WPD5CrvHq9UzWT3uXNvD5rF/7hp2j/MzFjJ69G1Zxehx/MZ2Jo/Pm+QCOKIaGG0y
	UhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgG5WUihLzCkF
	CgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMGb0vl/HWLBcseLrmzVMDYyrpLsYOTkk
	BEwkFuzuZ4GwxSQu3FvP1sXIxSEksIhR4sfB5+wQzitGiUO3ZzKCVPEKaEmcezUTrINFQFVi
	4cH1YDYbUHz/ixtsILaoQJjEyulXWCDqBSV+TL4HZosICEisf3EJbCizwG0miUuXfjKDJIQF
	AiQ+fvnADmILCaRLzNvyjQnE5hQwlXgxqxdsKLOAjsT+1mlQtrzE5jVvmScwCsxCsmMWkrJZ
	SMoWMDKvYhRNLUguKE5KzzXSK07MLS7NS9dLzs/dxAhOGM+kdzCuarA4xCjAwajEw3uQ80mg
	EGtiWXFl7iFGCQ5mJRFeO2GgEG9KYmVValF+fFFpTmrxIcZkYBBMZJYSTc4HJrO8knhDYxMz
	I0sjc0MLI2Nz0oSVxHkPtloHAn2fWJKanZpakFoEs4WJg1OqgXHxxZCJXAd15gYUno8KPRms
	Nn/xv/Sm59Mc+Kfbb7oYe/Tp7ntdkck3XRQVbvdom241XcsRt6hwxZz+I2xuun2tX464tDp1
	/O3+XVafrv+DjfOvW/0muSKBU3mTGjL0H/y5aXJUs5vtQdAc1ubT5w50rLu0lbu30Cx8l714
	tDx3kFC2oqH/KiWW4oxEQy3mouJEANdjELZcAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2013 12:51 AM, Felipe Balbi wrote:
> On Mon, Jul 15, 2013 at 09:09:02PM +0530, Kishon Vijay Abraham I wrote:
>> Modified dwc3-omap to receive connect and disconnect notification using
>> extcon framework. Also did the necessary cleanups required after
>> adapting to extcon framework.
>>
>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>> Acked-by: Felipe Balbi <balbi@ti.com>
>> Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
>> ---
>> This patch should be applied after all of the extcon patchset will be applied
>> because this patch has dependency of extcon patch related to DT.
>> http://goo.gl/Tu3qW
>>
>> Changes from v5:
>> * rebased to 3.11-rc1
>> Changes from v4:
>> * checked the return values of extcon_register_interest and print an error
>> message. Note that I dint do return since there might be cases where
>> one of USB (device mode) or USB-HOST (host mode) might succeed.
>> * Added depends on of EXTCON in usb_dwc3. Only some platforms might
>> be using EXTCON, but inorder to avoid compilation errors, added
>> depends on
>> Changes from v3:
>> * did #include of of_extcon.h after Chanwoo resent the patch separating
>> extcon-class.c from of_extcon.c
>> Changes from v2:
>> * updated the Documentation with dwc3 dt binding information.
>> * used of_extcon_get_extcon_dev to get extcon device from device tree data.
>> Changes from v1:
>> * regulator enable/disable is now done here instead of palmas-usb as some users
>> of palmas-usb wont need regulator.
>>  Documentation/devicetree/bindings/usb/omap-usb.txt |    5 +
>>  drivers/usb/dwc3/Kconfig                           |    1 +
>>  drivers/usb/dwc3/dwc3-omap.c                       |  125 +++++++++++++++++---
>>  3 files changed, 112 insertions(+), 19 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/usb/omap-usb.txt b/Documentation/devicetree/bindings/usb/omap-usb.txt
>> index 57e71f6..9088ab0 100644
>> --- a/Documentation/devicetree/bindings/usb/omap-usb.txt
>> +++ b/Documentation/devicetree/bindings/usb/omap-usb.txt
>> @@ -53,6 +53,11 @@ OMAP DWC3 GLUE
>>     It should be set to "1" for HW mode and "2" for SW mode.
>>   - ranges: the child address space are mapped 1:1 onto the parent address space
>>  
>> +Optional Properties:
>> + - extcon : phandle for the extcon device omap dwc3 uses to detect
>> +   connect/disconnect events.
>> + - vbus-supply : phandle to the regulator device tree node if needed.
>> +
>>  Sub-nodes:
>>  The dwc3 core should be added as subnode to omap dwc3 glue.
>>  - dwc3 :
>> diff --git a/drivers/usb/dwc3/Kconfig b/drivers/usb/dwc3/Kconfig
>> index 757aa18..08a9fab 100644
>> --- a/drivers/usb/dwc3/Kconfig
>> +++ b/drivers/usb/dwc3/Kconfig
>> @@ -1,6 +1,7 @@
>>  config USB_DWC3
>>  	tristate "DesignWare USB3 DRD Core Support"
>>  	depends on (USB || USB_GADGET) && GENERIC_HARDIRQS
>> +	depends on EXTCON
> 
> can you rebase this on top of 'testing' branch. I have a patch there
> which give glue layers their own Kconfig symbols. If you do that, I can
> queue this patch myself for v3.12, unless we have dependencies on other
> patches which aren't in mainline, in which case, I'd ask to simply
> remove this Kconfig change for now.
> 

Dear Felipe and Kishon,

We have some confusion about applying this patch.

I already applied this patch on extcon-next branch for v3.12. This patch has the dependency on below extcon patch.
[PATCH] usb: dwc3: use extcon fwrk to receive connect/disconnect
- http://git.kernel.org/cgit/linux/kernel/git/chanwoo/extcon.git/commit/?h=extcon-next&id=68517aac722c8c3e0c153b3ede40aace25cb66fa
[PATCH] extcon: Add an API to get extcon device from dt node
- http://git.kernel.org/cgit/linux/kernel/git/chanwoo/extcon.git/commit/?h=extcon-next&id=cb28faede03de7abe82336c3648771a01f5fe225

If Felipe would apply this patch usb.git for v3.12, I think you should include extcon patch together.
[PATCH] extcon: Add an API to get extcon device from dt node
- http://git.kernel.org/cgit/linux/kernel/git/chanwoo/extcon.git/commit/?h=extcon-next&id=cb28faede03de7abe82336c3648771a01f5fe225

The dependency related to patch cause this confusion.
What is your opinion?

Thanks,
Chanwoo Choi

