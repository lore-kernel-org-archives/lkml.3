Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934459AbaFSSWp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 14:22:45 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:41948 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933601AbaFSSWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 14:22:42 -0400
MIME-Version: 1.0
In-Reply-To: <CAJe_ZhfmsgvnVu-VgN63LaZ-522HuAY_EVfB6ujQjdzBE+u=zA@mail.gmail.com>
References: <1402944372-31901-1-git-send-email-bjorn.andersson@sonymobile.com>
	<7hvbrzbh1u.fsf@paris.lan>
	<CAJAp7OhHr4Cgcp9pvQ3=MAie_zSnFJxG28Vf37qJ98BK7P1jaQ@mail.gmail.com>
	<7hzjha8b97.fsf@paris.lan>
	<842A7147-A2CC-42BD-9947-CBADF738DC92@codeaurora.org>
	<7hegym6uca.fsf@paris.lan>
	<CAJe_ZhfmsgvnVu-VgN63LaZ-522HuAY_EVfB6ujQjdzBE+u=zA@mail.gmail.com>
Date: Thu, 19 Jun 2014 11:22:41 -0700
Message-ID: <CAJAp7OgfsVs9C0RNrDnQ5g7heba7JjaYFrj7wVUqT_m+wu-A3A@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] Qualcomm Resource Power Manager driver
From: Bjorn Andersson <bjorn@kryo.se>
To: Jassi Brar <jaswinder.singh@linaro.org>
Cc: Kevin Hilman <khilman@linaro.org>, Kumar Gala <galak@codeaurora.org>,
        Lee Jones <lee.jones@linaro.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Paul Walmsley <paul@pwsan.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 8:55 PM, Jassi Brar <jaswinder.singh@linaro.org> wrote:
> On 18 June 2014 22:14, Kevin Hilman <khilman@linaro.org> wrote:
[...]
>> Thinking more about what this RPM driver actually does, and since you
>> mentioned patterns across SoCs, it seems to me the RPM driver bascially
>> just doing the IPC.
>>
>> So, rather than MFD or drivers/soc, it seems to me that it should be
>> implmented as a controller in the new common mailbox framwork[1] being
>> worked on by Jassi Brar (added to Cc.)
>>
>> IIUC, RPM is actually only doing one-way IPC (it only exposes a write()
>> interface to clients) so it seems like a rather simple implementation of
>> a mailbox controller.
>>
> Yup, qcom_rpm.c is exactly what drivers/mailbox/ is meant for.
>

The RPM provides a register file with 80ish registers of variable size, to
program the hardware you write to these registers. Then you write to a register
selector register and then signal an outgoing interrupt.

That is, the interface exposed to the kernel by the SoC is not an mailbox like
interface.

So I do not share your view that this is "exactly what mailbox is meant for",
because if so then you're just re-inventing regmap - with variable size regs.


The reason why I'm not using a regmap as my abstraction between the rpm and the
clients (e.g. regulator driver) is because it only supports fixed size
registers.


To me the mailbox api is supposed to abstract communication hardware, not to
abstract communication between software components.

Regards,
Bjorn
