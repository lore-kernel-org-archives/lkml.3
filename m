Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203AbaDYKgm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 06:36:42 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:47264 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948AbaDYKgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 06:36:13 -0400
MIME-Version: 1.0
In-Reply-To: <20140425074156.GI30677@intel.com>
References: <534D0370.50108@linux.intel.com>
	<535005BA.1040405@codeaurora.org>
	<5357A80B.8030701@linux.intel.com>
	<5357ACF1.9070206@codeaurora.org>
	<20140423135915.GY30677@intel.com>
	<5357D8CC.3080501@codeaurora.org>
	<20140424063546.GA30677@intel.com>
	<5358F30E.9080402@codeaurora.org>
	<20140424115848.GG30677@intel.com>
	<53592D04.4040001@codeaurora.org>
	<20140425074156.GI30677@intel.com>
Date: Fri, 25 Apr 2014 12:36:12 +0200
Message-ID: <CACRpkdaKWSAvMTr_5Krm02JAuB98Z420izgpF--0yuA240eK7w@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] pinctrl: add Intel BayTrail GPIO/pinctrl support
From: Linus Walleij <linus.walleij@linaro.org>
To: "Westerberg, Mika" <mika.westerberg@intel.com>
Cc: Timur Tabi <timur@codeaurora.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        lkml <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 9:41 AM, Westerberg, Mika
<mika.westerberg@intel.com> wrote:
> On Thu, Apr 24, 2014 at 10:25:56AM -0500, Timur Tabi wrote:
>> On 04/24/2014 06:58 AM, Westerberg, Mika wrote:
>> >>>No, that's my point.  I was expecting the pinmux functions of the
>> >>>pinctrl driver are used by ACPI, but apparently they aren't, and
>> >>>that's why I'm asking.
>>
>> >Which functions?
>>
>> The functions in struct pinmux_ops, like get_function_groups.  Will
>> these functions ever be called on an ACPI system?
>
> Well, if you have an ACPI system (like normal PC) it is perfectly fine to
> have pin controller/mux hardware there which is not dependent at all on
> ACPI.
>
> If you happen to have pin controller/mux driver that drives that hardware,
> I'm sure your pinmux functions gets called.

True as far as the driver itself goes.

Pin controllers are however configured into a certain state with
platform data or device tree data. This configuration would need
to be stored in ACPI to fill the equivalent role in such a system,
and that in turn implies some thought given to it during design
of any ACPI-pinctrl bindings.

Yours,
Linus Walleij
