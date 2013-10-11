Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757206Ab3JKHx4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 03:53:56 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:45456 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756551Ab3JKHxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 03:53:54 -0400
MIME-Version: 1.0
In-Reply-To: <525712C9.6040502@wwwdotorg.org>
References: <20131008122145.GA21985@ab42.lan>
	<1381235122-23730-1-git-send-email-christian.ruppert@abilis.com>
	<CACRpkdafaNE_fgiq8iW=_gT5gDVC_H8m-+0dfpunhAantLdJwQ@mail.gmail.com>
	<20131009132837.GA23021@ab42.lan>
	<CACRpkdbo9MOuCY_UWhzbWwEAom_Z3=Vi575ELix9j3hsZdBzZw@mail.gmail.com>
	<525712C9.6040502@wwwdotorg.org>
Date: Fri, 11 Oct 2013 09:53:53 +0200
Message-ID: <CACRpkdZYTc2_zQww7NfmTjSZEoiksVwpV3sugXnanoUX135iRA@mail.gmail.com>
Subject: Re: [PATCH 01/03] Make non-linear GPIO ranges accesible from gpiolib
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Christian Ruppert <christian.ruppert@abilis.com>,
        Patrice CHOTARD <patrice.chotard@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sascha Leuenberger <sascha.leuenberger@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 10:49 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 10/09/2013 08:01 AM, Linus Walleij wrote:
>> On Wed, Oct 9, 2013 at 3:28 PM, Christian Ruppert
>> <christian.ruppert@abilis.com> wrote:
>>> On Wed, Oct 09, 2013 at 01:58:35PM +0200, Linus Walleij wrote:
>>>> On Tue, Oct 8, 2013 at 2:25 PM, Christian Ruppert
>>>> <christian.ruppert@abilis.com> wrote:
> ...
>>> Obviously, a driver (no matter for which OS) must be aware of
>>> this hardware property so it can decide which value to write to which
>>> register in order to control the pin mux. If we don't want to split (or
>>> worse: duplicate) that information in the driver and device tree, I see
>>> two alternatives.
>>> 1. Define register offsets, masks and register values and the list of
>>>    pins controlled by those register/value pairs in the device tree.
>>
>> This is not a viable alternative of course.
>
> Cough. pinctrl-single. Cough.

Indeed I have had second thoughts about pinctrl-single both
during its inception and later. Especially yesteray when it
sort of popped up that "yeah one register per pin ... then we
have this one extra register on the side to flush the pin settings
out to the IO-ring". (Haven't caught up with that discussion
though.)

It really needs to be kept in its very constrained cage.

For pinctrl-single there are quite a few strings attached,
like the pin can only be controlled by a single register, not
two of them. The indata to the device tree should be
in some nonsensical machine-readable form, not a
human-readable manual, such that the work of writing a
"proper" driver would involve reverse-engineering that
manual.

But it is definately in a grey area.

Yours,
Linus Walleij
