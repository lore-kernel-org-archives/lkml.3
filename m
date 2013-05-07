Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280Ab3EGJtq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 05:49:46 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:47302 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021Ab3EGJtp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 05:49:45 -0400
Message-ID: <5188CE36.9010602@slimlogic.co.uk>
Date: Tue, 07 May 2013 10:49:42 +0100
From: Graeme Gregory <gg@slimlogic.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: Mark Brown <broonie@kernel.org>, myungjoo.ham@samsung.com,
        cw00.choi@samsung.com, balbi@ti.com, ldewangan@nvidia.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, grant.likely@linaro.org,
        rob.herring@calxeda.com, rob@landley.net, ruchika@ti.com,
        tony@atomide.com, sameo@linux.intel.com
Subject: Re: [PATCH v4] extcon: Palmas Extcon Driver
References: <1362662506-14823-4-git-send-email-kishon@ti.com> <1367846225-15685-1-git-send-email-kishon@ti.com> <20130506144010.GF13472@opensource.wolfsonmicro.com> <51888D55.3090907@ti.com> <20130507075824.GM7478@sirena.org.uk> <5188CD9C.6010602@ti.com>
In-Reply-To: <5188CD9C.6010602@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/13 10:47, Kishon Vijay Abraham I wrote:
> Hi,
>
> On Tuesday 07 May 2013 01:28 PM, Mark Brown wrote:
>> On Tue, May 07, 2013 at 10:42:53AM +0530, Kishon Vijay Abraham I wrote:
>>> On Monday 06 May 2013 08:10 PM, Mark Brown wrote:
>>>> On Mon, May 06, 2013 at 06:47:04PM +0530, Kishon Vijay Abraham I
>>>> wrote:
>>>>
>>>>> +        if (palmas_usb->linkstat != PALMAS_USB_STATE_VBUS) {
>>>>> +            if (palmas_usb->vbus_reg) {
>>>>> +                ret = regulator_enable(palmas_usb->vbus_reg);
>>>>> +                if (ret) {
>>>>> +                    dev_dbg(palmas_usb->dev,
>>>>> +                        "regulator enable failed\n");
>>>>> +                    goto ret0;
>>
>>>> This is very bad karma, why is the regulator optional?
>>
>>> The platform can provide it's own vbus control in which case this is
>>> not needed.
>>
>> So why is there no interaction with this external VBUS control and how
>> does the driver distinguish between that and an error getting the
>> regulator?
>
> The platform specifies if it provides its own VBUS control by the dt
> property ti,no_control_vbus. So the driver will give an error only
> when *ti,no_control_vbus* is not set. Graeme?
>
> Thanks
> Kishon
That is correct, but as currently there are only two users I guess this
depends on Laxmans usecase. If he doesn't need this extra complexity I
would remove it for now. It was originally done with another SoC in mind!

Graeme

