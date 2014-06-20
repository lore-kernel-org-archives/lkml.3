Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934440AbaFTFRn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 01:17:43 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:59488 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbaFTFRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 01:17:41 -0400
MIME-Version: 1.0
In-Reply-To: <7hegym6uca.fsf@paris.lan>
References: <1402944372-31901-1-git-send-email-bjorn.andersson@sonymobile.com>
	<7hvbrzbh1u.fsf@paris.lan>
	<CAJAp7OhHr4Cgcp9pvQ3=MAie_zSnFJxG28Vf37qJ98BK7P1jaQ@mail.gmail.com>
	<7hzjha8b97.fsf@paris.lan>
	<842A7147-A2CC-42BD-9947-CBADF738DC92@codeaurora.org>
	<7hegym6uca.fsf@paris.lan>
Date: Thu, 19 Jun 2014 22:17:40 -0700
Message-ID: <CAJAp7Ogw967gbBGmiifhtNTsZ57g8MMy4mUR1YwvpWVSZnmOjA@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] Qualcomm Resource Power Manager driver
From: Bjorn Andersson <bjorn@kryo.se>
To: Kevin Hilman <khilman@linaro.org>
Cc: Kumar Gala <galak@codeaurora.org>, Lee Jones <lee.jones@linaro.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Paul Walmsley <paul@pwsan.com>,
        Jaswinder Singh <jaswinder.singh@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 9:44 AM, Kevin Hilman <khilman@linaro.org> wrote:
[...]
> Thinking more about what this RPM driver actually does, and since you
> mentioned patterns across SoCs, it seems to me the RPM driver bascially
> just doing the IPC.
>

Yes, technically this is IPC. But it's all exposed in memory as if it
was hardware, so there's no messages or packets to be interpreted by
the other side.

> So, rather than MFD or drivers/soc, it seems to me that it should be
> implmented as a controller in the new common mailbox framwork[1] being
> worked on by Jassi Brar (added to Cc.)
>
> IIUC, RPM is actually only doing one-way IPC (it only exposes a write()
> interface to clients) so it seems like a rather simple implementation of
> a mailbox controller.
>

What I think you miss here is the detail of that what the regulator
writes is not what is passed over the IPC, but rather is just an
interface to abstract away how things are spread our in the register
space.

So the only place where we do have a "mailbox" here is the actual
function call between the regulator and the rpm drivers; not between
the rpm driver and the rpm.

> I believe Bjorn is already on the list of folks Cc'd on the common
> mailbox framework, so it would be good to hear from him why RPM wouldn't
> fit under that framework.
>

In a separate group of Qualcomm platforms the communication with the
RPM is done by passing messages over a shared memory channel; as this
requires a completely different implementation of the rpm driver, I
have started to look at Jassi's patch series.

Unfortunately at this point it does not look like the proposed mailbox
framework would reduce the complexity of the implementation nor
provide any additional benefits when it comes to being able to
exchange the underlaying communication methods.

But I will continue to follow the development of the mailbox framework.

Regards,
Bjorn
