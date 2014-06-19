Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334AbaFSUBY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 16:01:24 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:64668 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823AbaFSUBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 16:01:22 -0400
MIME-Version: 1.0
In-Reply-To: <CAJAp7OgfsVs9C0RNrDnQ5g7heba7JjaYFrj7wVUqT_m+wu-A3A@mail.gmail.com>
References: <1402944372-31901-1-git-send-email-bjorn.andersson@sonymobile.com>
	<7hvbrzbh1u.fsf@paris.lan>
	<CAJAp7OhHr4Cgcp9pvQ3=MAie_zSnFJxG28Vf37qJ98BK7P1jaQ@mail.gmail.com>
	<7hzjha8b97.fsf@paris.lan>
	<842A7147-A2CC-42BD-9947-CBADF738DC92@codeaurora.org>
	<7hegym6uca.fsf@paris.lan>
	<CAJe_ZhfmsgvnVu-VgN63LaZ-522HuAY_EVfB6ujQjdzBE+u=zA@mail.gmail.com>
	<CAJAp7OgfsVs9C0RNrDnQ5g7heba7JjaYFrj7wVUqT_m+wu-A3A@mail.gmail.com>
Date: Fri, 20 Jun 2014 01:31:21 +0530
Message-ID: <CAJe_ZhcSMrN6OeRjo7cG7CMobjEPMMB7o0eUD9HAFskravSQ3w@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] Qualcomm Resource Power Manager driver
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Bjorn Andersson <bjorn@kryo.se>
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

On 19 June 2014 23:52, Bjorn Andersson <bjorn@kryo.se> wrote:
> On Wed, Jun 18, 2014 at 8:55 PM, Jassi Brar <jaswinder.singh@linaro.org> wrote:
>> On 18 June 2014 22:14, Kevin Hilman <khilman@linaro.org> wrote:
> [...]
>>> Thinking more about what this RPM driver actually does, and since you
>>> mentioned patterns across SoCs, it seems to me the RPM driver bascially
>>> just doing the IPC.
>>>
>>> So, rather than MFD or drivers/soc, it seems to me that it should be
>>> implmented as a controller in the new common mailbox framwork[1] being
>>> worked on by Jassi Brar (added to Cc.)
>>>
>>> IIUC, RPM is actually only doing one-way IPC (it only exposes a write()
>>> interface to clients) so it seems like a rather simple implementation of
>>> a mailbox controller.
>>>
>> Yup, qcom_rpm.c is exactly what drivers/mailbox/ is meant for.
>>
>
> The RPM provides a register file with 80ish registers of variable size, to
> program the hardware you write to these registers. Then you write to a register
> selector register and then signal an outgoing interrupt.
>
For mailbox_request_channel(), you have dev_get_qcom_rpm()  and
qcom_rpm_write() for mbox_send_message()
Rest all is what you need to fire off a message to remote or register
for interrupts. So nothing new to me.

> That is, the interface exposed to the kernel by the SoC is not an mailbox like
> interface.
>
 I don't understand how having to program 80 registers makes it "not
like mailbox"?
 I have used mailbox api to pass messages between CPUs (using PPI)
under same instance of Linux and otoh I think it could also support
IPC over gpio (if someone gets that desperate).
Mailbox isn't about how you program the h/w. Do whatever is needed to
send a message across.

BTW I haven't looked closely, but probably you could push the data tables in DT?

Cheers
-Jassi
