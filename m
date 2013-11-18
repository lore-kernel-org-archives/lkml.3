Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834Ab3KRNWQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 08:22:16 -0500
Received: from mail-oa0-f44.google.com ([209.85.219.44]:59769 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019Ab3KRNWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 08:22:09 -0500
MIME-Version: 1.0
In-Reply-To: <201311071748050629542@gmail.com>
References: <1383732348-18576-1-git-send-email-lee.jones@linaro.org>
	<1383732348-18576-3-git-send-email-lee.jones@linaro.org>
	<CACRpkdZekui-CoPdwtyATQyAv07CZp3B9L=qU6xAk8J43=Bb6w@mail.gmail.com>
	<201311071253281097419@gmail.com>
	<CACRpkdYUKKLvMWcSxb24ZvYUq1QMzs9cw-h5CpZ1Q5S2s3RVBQ@mail.gmail.com>
	<201311071748050629542@gmail.com>
Date: Mon, 18 Nov 2013 14:22:09 +0100
Message-ID: <CACRpkdZg9H+efyZMPAAQX475zcyRx-wzd53jcSe40eASy0Dirw@mail.gmail.com>
Subject: Re: Re: PINCTRL:We May need mutex protect in pinctrl API
From: Linus Walleij <linus.walleij@linaro.org>
To: "xulinuxkernel@gmail.com" <xulinuxkernel@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 7, 2013 at 10:48 AM, xulinuxkernel@gmail.com
<xulinuxkernel@gmail.com> wrote:

> sorry,our code is not upstream.
> But if two threads come in pinctrl_select_state()  at the same time,
> Is that okay?

Why would two threads come in there at the same time?

We have exactly one pinctrl* handle per device, and we
select the state on it. This is like for example the device
driver would have one thread telling it to go to "default"
state and another thread telling it to go to "idle" or "sleep"
state for example.

If we really have a device driver doing such things
for a good reason, then we need to protect it, but I
want to see that device driver first.

I am quite sure that it's safe to say that the upstream
kernel does not contain a device that will ask the hardware
to move around between different states like this from
different threads, such calls will be serialized by the
nature of sequencing in e.g. runtime PM.

I need to see the device driver and the use case so I
can understand why this would be needed.

I think the need from this arise from an abuse of the
pin controller states.

Yours,
Linus Walleij
