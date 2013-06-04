Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812Ab3FDKTU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 06:19:20 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:22973 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab3FDKTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 06:19:17 -0400
X-AuditID: cbfec7f5-b7f376d000001ec6-66-51adbf22bc6b
Message-id: <51ADBF20.3050905@samsung.com>
Date: Tue, 04 Jun 2013 12:19:12 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: grant.likely@linaro.org, tony@atomide.com, balbi@ti.com, arnd@arndb.de,
        swarren@nvidia.com, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, rob.herring@calxeda.com, rob@landley.net,
        b-cousson@ti.com, linux@arm.linux.org.uk, gregkh@linuxfoundation.org,
        benoit.cousson@linaro.org, mchehab@redhat.com,
        akpm@linux-foundation.org, cesarb@cesarb.net, davem@davemloft.net,
        rnayak@ti.com, shawn.guo@linaro.org, santosh.shilimkar@ti.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        nsekhar@ti.com
Subject: Re: [PATCH v6 1/9] drivers: phy: add generic PHY framework
References: <1367229812-30574-1-git-send-email-kishon@ti.com>
 <1367229812-30574-2-git-send-email-kishon@ti.com> <51A531A9.4030800@gmail.com>
 <51A59466.6090504@ti.com>
In-reply-to: <51A59466.6090504@ti.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0hTYRjHe3fOzo6ryWlpvFppTCqQsoySNxEJijgVhFZC2AdbOlRwKlua
	C2SiM2q5KQqp85KXmaVTa5qXmG1Op6HmJJ1tKpoNrZkluRTJkprrg99+D8//8uVPYtxR3JdM
	TL4jECXzk3gEGx/aHLAc4+mbIk/8GEGovEVDoD+F/Sy0NqXFUM+sFJWu2AikmriKys0yHBnK
	5pjI8LsToJzaFgKNzucRSGufYKLq+2ocjb0uJ1CZOh9HNU9zMTQ1xkE6Uy8L6RUvGGghXwdQ
	7zMDAzU7inH0VanB0HyzGkPWYhkT6ccvnfWlZTl5BL3xqxDQa6uFOF3lHGfRfVMlGN323Mag
	FxtLmfT0hI6g35Zs4LS+QsOiW9VS2lxSDWhFzneCXn5jIegBaweDdmr9IqhodlicICkxXSA6
	Hn6LnVA52cFKneRmNGmK8Czg9JQDDxJSp2BfpQq4eS8cnWkh5IBNcqk6AB2WBob7WAHw42wN
	LgckyaEC4ZAlymXAqUPQIfuJu5iggqHCpNwK8qYiYK16hOViDrUbrhfNbGm8XNaudcyViVGT
	OLS9X2K4Hnuoc9A4/fl/WcO/5kHFltuDOgyrra8wF2PUUajPfUy42R+2ar5hBYBSbStRbZOp
	tsmqANYAvAVpsani2/HCk0FivlCclhwfFJsi1AL3ClY7QV1/qBFQJODt4kjaNZFcJj9dLBEa
	ASQxnhenu7EpksuJ40vuCUQpMaK0JIHYCBikh28W0JgydKclNy90Kwc79Os2U/1wiKfB/Ci7
	7Qvn/FzmE3hjn09IFB7zbv+stOKa44DNLzNgxP+l5/Jldrr5ekC9c9i6eTDU+6G9tgvujJaG
	9foN94REhS/YNzY79UsFF+/aHqw5lGcW8/u6nQ7lJ/Hq/ED2gk//kSvydvsOmT3hAw8XJ/CD
	AzGRmP8XZ5eDXeMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 05/29/2013 07:38 AM, Kishon Vijay Abraham I wrote:
> On Wednesday 29 May 2013 04:07 AM, Sylwester Nawrocki wrote:
>> > On 04/29/2013 12:03 PM, Kishon Vijay Abraham I wrote:
>>> >> The PHY framework provides a set of APIs for the PHY drivers to
>>> >> create/destroy a PHY and APIs for the PHY users to obtain a reference
>>> >> to the
>>> >> PHY with or without using phandle. For dt-boot, the PHY drivers should
>>> >> also register *PHY provider* with the framework.
>>> >>
>>> >> PHY drivers should create the PHY by passing id and ops like init, exit,
>>> >> power_on and power_off. This framework is also pm runtime enabled.
>>> >>
>>> >> The documentation for the generic PHY framework is added in
>>> >> Documentation/phy.txt and the documentation for dt binding can be
>>> >> found at
>>> >> Documentation/devicetree/bindings/phy/phy-bindings.txt
>>> >>
>>> >> Signed-off-by: Kishon Vijay Abraham I<kishon@ti.com>
>> >
>> > Thanks for working on this. For the record, I plan to give this a try
>> > in the end of this week, with my simple MIPI CSI/DSI PHY driver. I might
>> > have some more comments then. For now just couple of remarks after
>> > reading the documentation.
>
> Thanks for reviewing. I'll wait for your comments before posting the 
> next version.

So I've used this API for the Exynos SoC MIPI CSI-2 and MIPI DSI DPHYs.
I could remove all the local modifications, comparing to your v5, since 
this iteration already have what's needed, thanks! In my case the PHY 
provider was a platform device and so were the PHY consumer devices. Those 
PHYs are very simple, there is less than one register per PHY (some bits 
are shared across the MIPI CSI-2 receiver and MIPI DSI transmitter DPHYs), 
but having this generic PHY driver means, among others, there is a proper 
DT support. I could finally get rid of the the platform callback at 
arch/arm/plat-samsung/setup-mipiphy.c.

I found this code useful as is, except previous minor comments I don't 
really have more remarks now. This API looks quite good, and it seems much 
lighter comparing to the original version.

I assume, the way it is designed now, allows it to be used also with PHYs that 
hang off other buses, e.g. I2C.

It would be nice to get this in 3.11.

Hmm, actually I have some doubts, let me comment in other e-mail..


Regards,
Sylwester
