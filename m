Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588AbaDXPNS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 11:13:18 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:57369 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040AbaDXPNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 11:13:12 -0400
MIME-Version: 1.0
In-Reply-To: <20140424144717.GI26661@saruman.home>
References: <1398342897-23670-1-git-send-email-cw00.choi@samsung.com>
	<1398342897-23670-10-git-send-email-cw00.choi@samsung.com>
	<20140424144717.GI26661@saruman.home>
Date: Fri, 25 Apr 2014 00:13:12 +0900
Message-ID: <CAGTfZH1XgRkGWL+ySZ8uTKbhD9djZx3C4Tar+aKkUEmLAV7KJw@mail.gmail.com>
Subject: Re: [PATCHv3 9/9] extcon: palmas: Use devm_extcon_dev_allocate for extcon_dev
From: Chanwoo Choi <cwchoi00@gmail.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        gg@slimlogic.co.uk, Kishon Vijay Abraham I <kishon@ti.com>,
        ckeepax@opensource.wolfsonmicro.com, Mark Brown <broonie@kernel.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 11:47 PM, Felipe Balbi <balbi@ti.com> wrote:
> On Thu, Apr 24, 2014 at 09:34:57PM +0900, Chanwoo Choi wrote:
>> This patch use devm_extcon_dev_allocate() to simplify the memory control
>> of extcon device.
>>
>> Cc: Graeme Gregory <gg@slimlogic.co.uk>
>> Cc: Kishon Vijay Abraham I <kishon@ti.com>
>> Cc: Felipe Balbi <balbi@ti.com>
>> Cc: Samuel Ortiz <sameo@linux.intel.com>
>> Cc: Lee Jones <lee.jones@linaro.org>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Acked-by: Lee Jones <lee.jones@linaro.org>
>
> Tested-by: Felipe Balbi <balbi@ti.com>

Thanks for your test.

>
> *BUT* you need to fix NULL vs ERR_PTR return in your code. The way this
> is, we can easily dereference an ERR_PTR because the code doesn't test
> for it. I suggest always returning valid pointer or ERR_PTR and avoid
> returning NULL at all.

OK, as my reply on other mail, I'll fix return type by using ERR_PTR
instead of NULL.

Thanks,
Chanwoo Choi
