Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221AbaHTWNe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 18:13:34 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:43127 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbaHTWNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 18:13:32 -0400
MIME-Version: 1.0
In-Reply-To: <20140820212843.GB16274@sonymobile.com>
References: <1407771634-14946-1-git-send-email-iivanov@mm-sol.com>
	<1407771634-14946-3-git-send-email-iivanov@mm-sol.com>
	<53F456F3.3000309@linaro.org>
	<20140820212843.GB16274@sonymobile.com>
Date: Wed, 20 Aug 2014 15:13:31 -0700
Message-ID: <CAJAp7Ojt=PCCDhoR+nhEtQbPHzsp+=uTLx-XMM7-W78bfnQytA@mail.gmail.com>
Subject: Re: [PATCH v3 2/6] pinctrl: Introduce pinctrl driver for Qualcomm
 SSBI PMIC's
From: Bjorn Andersson <bjorn@kryo.se>
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2014 at 2:28 PM, Bjorn Andersson
<bjorn.andersson@sonymobile.com> wrote:
> On Wed 20 Aug 01:06 PDT 2014, Srinivas Kandagatla wrote:
>> 2> Looking back at v3.4 kernel, for gpio modes, BIT(0) of bank 0 is set
>> to enable gpio mode. without this bit driver does not work for output pins.
>>
>
> Thanks, I missed that.
>
> Unfortunately, setting that bit results in input not working - the interrupt
> bits are never set for gpios that have that bit set. I'm trying to figure out
> why this is the case before sending out the new version...

With help from Andy Gross this is now corrected as well, turned out
that BIT(0) in bank0 controls if the "direction" is considered. As I
was tricked by the multiple levels of indirection in the codeaurora
version I got these wrong.

Will send out an updated version shortly.

Regards,
Bjorn
