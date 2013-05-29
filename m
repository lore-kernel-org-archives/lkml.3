Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759301Ab3E2Qs3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 12:48:29 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:64481 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757827Ab3E2QsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 12:48:23 -0400
MIME-Version: 1.0
In-Reply-To: <20130528100941.GK22683@gmail.com>
References: <1369661455-17839-1-git-send-email-gabriel.fernandez.st@gmail.com>
	<1369661455-17839-3-git-send-email-gabriel.fernandez.st@gmail.com>
	<20130528100941.GK22683@gmail.com>
Date: Wed, 29 May 2013 18:48:22 +0200
Message-ID: <CACRpkdYUBn4sv2vtTa1dNsd6RnCVRvep168pmiCzhF1fYsRvCA@mail.gmail.com>
Subject: Re: [PATCH 2/3] ARM: u8540: Add Pinctrl Device Tree settings for
 uart0, uart2
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Gabriel Fernandez <gabriel.fernandez.st@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Olivier Clergeaud <olivier.clergeaud@st.com>,
        Gabriel Fernandez <gabriel.fernandez@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 28, 2013 at 12:09 PM, Lee Jones <lee.jones@linaro.org> wrote:
> On Mon, 27 May 2013, Gabriel Fernandez wrote:
>> From: Gabriel Fernandez <gabriel.fernandez@st.com>
>>
>> This patch adds pinctrl device tree settings for uart0 and uart2
>> for ccu8540 board.
>>
>> Signed-off-by: Gabriel Fernandez <gabriel.fernandez@st.com>
>> ---
>>  arch/arm/boot/dts/ccu8540-pinctrl.dtsi     | 77 ++++++++++++++++++++++++
>>  arch/arm/boot/dts/ccu8540.dts              |  7 +++
>>  arch/arm/boot/dts/dbx5x0.dtsi              |  2 +-
>>  arch/arm/boot/dts/ste-nomadik-pinctrl.dtsi | 95 ++++++++++++++++++++++++++++++
>
> This is starting to get a bit confusing. How intrusive would it be to
> place the ccu8540-pinctrl information inside ccu8540.dts instead of
> breaking it out into different files and convoluting the issue?
>
> Also, please correct me if I'm wrong, but isn't what we call the
> Nomadik Pinctrl/GPIO really the same as DBX500 Pinctrl/GPIO? I wonder
> if this would be a better naming convention?
>
> Linus, what do you think?

I think the definitions can live in their own file like this since it
saves a lot of
lines... And the use of <dt-bindings/*> is really nice.

> Nodes look pretty good, except shouldn't 'ste' really be 'stericsson'?

I started to use ste-* on the Nomadik and U300 stuff to avoid all too
long filenames.

I would actually like to rename all the ux500-related files ste-*
so they get grouped together in the filelist, but I've heard that there
was a plan to create per-vendor subdirs in arch/arm/boot/dts
so maybe I should go for that instead?

[Gabriel]
> i missed
>           pinctrl {
>                        compatible = "stericsson,db8540-pinctrl";

Are you sending a v2?

Yours,
Linus Walleij
