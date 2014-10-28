Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488AbaJ1QGi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 12:06:38 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:50254 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617AbaJ1QGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 12:06:36 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdZO+TuCodDzLZ2evRc0ak+4of38aKNqCiC5cMkm++keHw@mail.gmail.com>
References: <1413847670-12245-1-git-send-email-dianders@chromium.org>
	<CACRpkdZO+TuCodDzLZ2evRc0ak+4of38aKNqCiC5cMkm++keHw@mail.gmail.com>
Date: Tue, 28 Oct 2014 09:06:35 -0700
X-Google-Sender-Auth: jVXsaOURHeVsFZXTCMKQFEZ7-Z8
Message-ID: <CAD=FV=UFRPDtKpgpbnMf4U33C0VVP+BzZRj4rsN_D3OGxJwfzA@mail.gmail.com>
Subject: Re: [PATCH 1/4] pinctrl: rockchip: Set wake_enabled
From: Doug Anderson <dianders@chromium.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Heiko Stuebner <heiko@sntech.de>, Chris Zhong <zyw@rock-chips.com>,
        Sonny Rao <sonnyrao@chromium.org>, linux-rockchip@lists.infradead.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

On Tue, Oct 28, 2014 at 8:51 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Tue, Oct 21, 2014 at 1:27 AM, Doug Anderson <dianders@chromium.org> wrote:
>
>> The rockchip pinctrl driver uses irq_gc_set_wake() but doesn't setup
>> the .wake_enabled member.  That means that we can never actually use a
>> pin for wakeup.  When "irq_set_irq_wake()" tries to call through it
>> will always get a failure from set_irq_wake_real() and will then set
>> wake_depth to 0.  Assuming you can resume you'll later get an error
>> message about "Unbalanced IRQ x wake disable".
>>
>> Signed-off-by: Doug Anderson <dianders@chromium.org>
>
> Heiko, are you looking at this patch series? Need you Reviewed-by
> to merge this stuff.

See Heiko's review on the latest version of this series (v2).

https://patchwork.kernel.org/patch/5126811/
https://patchwork.kernel.org/patch/5126941/
https://patchwork.kernel.org/patch/5126971/
https://patchwork.kernel.org/patch/5126801/

-Doug
