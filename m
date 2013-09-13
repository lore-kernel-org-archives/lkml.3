Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383Ab3IMA5f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 20:57:35 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:56468 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754495Ab3IMA5e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 20:57:34 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <1379032225-6425-1-git-send-email-emilio@elopez.com.ar>
References: <1378863781-4235-1-git-send-email-emilio@elopez.com.ar>
	<1379032225-6425-1-git-send-email-emilio@elopez.com.ar>
Date: Thu, 12 Sep 2013 17:57:32 -0700
Message-ID: <CAOesGMiUMniKRLRgGPsimR0bXWQFbx+SL5dUJXOb8t0JfEcHsg@mail.gmail.com>
Subject: Re: [PATCH] memory: add a basic OF-based memory driver
From: Olof Johansson <olof@lixom.net>
To: =?ISO-8859-1?Q?Emilio_L=F3pez?= <emilio@elopez.com.ar>
Cc: Mike Turquette <mturquette@linaro.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        =?ISO-8859-1?Q?David_Lanzend=F6rfer?= <david.lanzendoerfer@o2s.ch>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 5:30 PM, Emilio López <emilio@elopez.com.ar> wrote:
> This driver's only job is to claim and ensure the necessary clock
> for memory operation on a DT-powered machine remains enabled.
>
> Signed-off-by: Emilio López <emilio@elopez.com.ar>
> ---
>
> I believe this new patch should resolve all the concerns raised; as
> always, all feedback is welcome :)

I think you're going about this the wrong way.

If you have a problem with a clock not staying on, shouldn't you just
marking it appropriately in the clock table instead, making sure it's
initialized with at least one reference to it? I believe that is how
some of the other platforms handle this, and it's a lot cleaner than
adding a fake binding and a fake driver just to grab a single clock.


-Olof
