Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758022AbaDXPGV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 11:06:21 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:53848 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178AbaDXPGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 11:06:18 -0400
MIME-Version: 1.0
In-Reply-To: <20140424150344.GO26661@saruman.home>
References: <1398342897-23670-1-git-send-email-cw00.choi@samsung.com>
	<1398342897-23670-2-git-send-email-cw00.choi@samsung.com>
	<20140424144257.GF26661@saruman.home>
	<CAGTfZH0+VCvr=JNbq8kbtC2CDN63k28+oSd__6sb+Qy2tQ4_ng@mail.gmail.com>
	<20140424150344.GO26661@saruman.home>
Date: Fri, 25 Apr 2014 00:06:18 +0900
Message-ID: <CAGTfZH09FiaAzEy56DYu0JY2CHwfB3+m6kP6Xog1Zctxs_m7zg@mail.gmail.com>
Subject: Re: [PATCHv3 1/9] extcon: Add extcon_dev_allocate/free() to control
 the memory of extcon device
From: Chanwoo Choi <cwchoi00@gmail.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        gg@slimlogic.co.uk, Kishon Vijay Abraham I <kishon@ti.com>,
        ckeepax@opensource.wolfsonmicro.com, Mark Brown <broonie@kernel.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 12:03 AM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Thu, Apr 24, 2014 at 11:58:29PM +0900, Chanwoo Choi wrote:
>> >> +void extcon_dev_free(struct extcon_dev *edev)
>> >> +{
>> >> +     if (edev)
>> >> +             kfree(edev);
>> >
>> > kfree(NULL) is safe
>>
>> I don't understand about meaning 'kfree(NULL)'.
>> Why do I free 'NULL' pointer' instead of 'edev' pointer?
>
> you don't need to check if evdev is valid before calling kfree() on it
> because if it happens to be NULL, no cute bunnies will be sacrificed.
>

OK, I'll fix it as following code without checking whether 'edev' is
NULL or not.

void extcon_dev_free(struct extcon_dev *edev)
{
          kfree(edev);
}

Thanks,
Chanwoo Choi
