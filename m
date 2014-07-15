Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758630AbaGOJvf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 05:51:35 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:57280 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758038AbaGOJva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 05:51:30 -0400
Message-ID: <53C4F99F.1020407@mm-sol.com>
Date: Tue, 15 Jul 2014 12:51:27 +0300
From: Stanimir Varbanov <svarbanov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Bjorn Andersson <bjorn@kryo.se>
CC: linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Lee Jones <lee.jones@linaro.org>,
        Josh Cartwright <joshc@codeaurora.org>
Subject: Re: [RFC PATCH v2 3/5] rtc: add qpnp rtc driver
References: <1404393243-7324-1-git-send-email-svarbanov@mm-sol.com> <1404393243-7324-4-git-send-email-svarbanov@mm-sol.com> <CAJAp7Ohis95K9Fw5ff7jfed5YFwRaMqHL-FToPqz7YU_Ux3zEg@mail.gmail.com> <53BEB487.8030309@mm-sol.com>
In-Reply-To: <53BEB487.8030309@mm-sol.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn,

On 07/10/2014 06:43 PM, Stanimir Varbanov wrote:
> On 07/10/2014 04:08 PM, Bjorn Andersson wrote:
>> On Thu, Jul 3, 2014 at 6:14 AM, Stanimir Varbanov <svarbanov@mm-sol.com> wrote:
>> [...]
>>> +static const struct of_device_id qpnp_rtc_table[] = {
>>> +       { .compatible = "qcom,qpnp-rtc", },
>>> +       {}
>>> +};
>>> +MODULE_DEVICE_TABLE(of, rtc_qpnp_table);
>>
>> We have had a lot of discussions related to how to name pm8x41
>> drivers; as they obviously fall under pm8xxx in most peoples eyes.
> 
> IMO the pm8xxx is misleading already.

I guess we can rename pm8921-core.c to pm8921-ssbi.c. And then "QPNP"
variant can become pm8xxx-spmi.c. This way the name reflects the
physical interface used for particular pmic. We need to drop out the
"xx41" because this driver will support PMA8084 as well.

Then we can try to extend the pm8xxx subsystem drivers (pmic8xxx-keypad,
rtc-pm8xxx, pm8xxx-vibrator, pmic8xxx-pwrkey) to support pm8xxx-spmi
(qpnp) depending on compatible string.

-- 
regards,
Stan
