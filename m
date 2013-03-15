Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070Ab3CORWK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 13:22:10 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:60996 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426Ab3CORWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 13:22:09 -0400
Message-ID: <514358BC.4030600@wwwdotorg.org>
Date: Fri, 15 Mar 2013 11:22:04 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Bill Huang <bilhuang@nvidia.com>
CC: Stephen Warren <swarren@nvidia.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "ian@slimlogic.co.uk" <ian@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ian Lartey <ian@slimlogic.co.uk>
Subject: Re: [PATCH 1/1] mfd: palmas: Add power off control
References: <1363258680-12600-1-git-send-email-bilhuang@nvidia.com>  <5142AF55.80708@nvidia.com> <1363326713.3311.50.camel@bilhuang-vm1>
In-Reply-To: <1363326713.3311.50.camel@bilhuang-vm1>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-9
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2013 11:51 PM, Bill Huang wrote:
> On Fri, 2013-03-15 at 13:19 +0800, Stephen Warren wrote:
>> On 03/14/2013 04:58 AM, Bill Huang wrote:
>>> Hook up "pm_power_off" to palmas power off routine if there is DT
>>> property "ti,system-power-controller" defined, so platform which is
>>> powered by this regulator can be powered off properly.
>>
>>> diff --git a/drivers/mfd/palmas.c b/drivers/mfd/palmas.c
>>
>>> +	pdata->pm_off = of_property_read_bool(node,
>>> +			"ti,system-power-controller");
>>
>> You would need to add that property to the DT binding documentation for
>> this device.
>
> Does it work that some time later Laxmain helps to add it when he
> submits his pmic bindings for Palmas?

I'll note that Ian Lartey and Graeme Gregory actually seem to be the
people defining the PMIC bindings for Palmas. See:

http://comments.gmane.org/gmane.linux.documentation/9948

Or is Laxman planning to send some updates to that?

But irrespective of that no, I don't think that influences this at all;
if you introduce driver support for new DT content, then either that DT
content should already be documented in the binding, or this patch
should add it to the documentation.
