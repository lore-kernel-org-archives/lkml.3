Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481Ab3FMPgD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 11:36:03 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:34599 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756779Ab3FMPgB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 11:36:01 -0400
MIME-Version: 1.0
In-Reply-To: <201306131723.04721.heiko@sntech.de>
References: <201306102139.32444.heiko@sntech.de>
	<CACRpkdb-vbdQJOeZvCEsKLatK-0BhEfUTJqmGURJGf1NWx__Ew@mail.gmail.com>
	<201306131635.21446.heiko@sntech.de>
	<201306131723.04721.heiko@sntech.de>
Date: Thu, 13 Jun 2013 17:36:00 +0200
Message-ID: <CACRpkdZavNX3jk4K5unEJCED4vTuZEUF=NC1naGOMyr54hXQKw@mail.gmail.com>
Subject: Re: [PATCH 1/2] pinctrl: add function to parse generic pinconfig
 properties from a dt node
From: Linus Walleij <linus.walleij@linaro.org>
To: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
Cc: James Hogan <james.hogan@imgtec.com>,
        Patrice Chotard <patrice.chotard.st@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 13, 2013 at 5:23 PM, Heiko Stübner <heiko@sntech.de> wrote:

>> Ok, I'll see that I get this fixed :-)
>
> Hmm ... what is the meaning of the argument of bias-disable and bias-high-
> impedance, as the kernel-doc in pinconf-generic.h does not tell?

I think those arguments are N/A, ignored, doesn't matter.
If these options were typed, they would be bool.

Please improve documentation if you can... sorry for all the
rough edges.

> bias-bus-hold ignores its argument and we already clarified that the pull-* do
> have != 0 or 0 argument.

I think in the DT binding, both these forms:

bias-pull-up;
bias-pull-up = <150000>;

Should be allowed.

So when parsing, you first check if it exists, then if there
is an argument, if there is no value supplied, just set it
to 1, as that is clearly != 0...

Yours,
Linus Walleij
