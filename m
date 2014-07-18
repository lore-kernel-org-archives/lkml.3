Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965673AbaGRQN6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 12:13:58 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:45619 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932384AbaGRQN4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 12:13:56 -0400
Message-ID: <53C947C0.5020604@mm-sol.com>
Date: Fri, 18 Jul 2014 19:13:52 +0300
From: Stanimir Varbanov <svarbanov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Josh Cartwright <joshc@codeaurora.org>
Subject: Re: [PATCH v2 0/4] Support for Qualcomm QPNP PMIC's
References: <1405613855-27572-1-git-send-email-svarbanov@mm-sol.com> <53C857DE.7030507@codeaurora.org>
In-Reply-To: <53C857DE.7030507@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2014 02:10 AM, Stephen Boyd wrote:
> On 07/17/14 09:17, Stanimir Varbanov wrote:
>> Hello everyone,
>>
>> Here is the continuation of patch sets sent recently about Qualcomm
>> QPNP SPMI PMICs.
>>
>> The previous version of the patch set can be found at [1].
>>
>> Changes since v1:
>>  - removed completely custom *of* parser
>>  - renamed the mfd driver from qpnp-spmi to pm8xxx-spmi
>>  - now MFD_PM8XXX_SPMI Kconfig option depends on SPMI
>>
>> Removing of the custom *of* parser leads to that that the *reg* devicetree
>> property cannot exist and therefore cannot be parsed to get PMIC peripheral
>> resources. I took this step aside because no one from mfd drivers does this
>> parsing. This will lead to inconvenience in the peripheral drivers to define
>> internally the SPMI base addresses depending on the compatible property
>> i.e. PMIC version. 
> 
> We should teach the of platform layer to translate reg properties up
> until the point that they can't be translated anymore. If they can't be
> translated all the way back to cpu addresses we can make the resource
> have IORESOURCE_REG instead of IORESOURCE_MEM and then said pmic
> platform drivers can use platform_get_resource() with IORESOURCE_REG
> instead of IORESOURCE_MEM to get the addresses.
> 

I considered this as an option, if it is acceptable by OF maintainers it
will be awesome.

Rob, Grant, is that feasible?

-- 
regards,
Stan
