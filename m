Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620Ab3FJKyx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 06:54:53 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:48299 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740Ab3FJKyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 06:54:52 -0400
MIME-Version: 1.0
In-Reply-To: <20130607142020.GB24958@gmail.com>
References: <1370517676-10909-1-git-send-email-lee.jones@linaro.org>
	<1370517676-10909-3-git-send-email-lee.jones@linaro.org>
	<CACRpkdYLB-_JjEd69vVub_Z3L+avQRrFBt1fGuyR0D_owcLWvA@mail.gmail.com>
	<20130607142020.GB24958@gmail.com>
Date: Mon, 10 Jun 2013 12:54:51 +0200
Message-ID: <CACRpkdZiRZj05Wd3YKJO5hzXOMVJ0qESANEa=8LCGR=tn2AK7w@mail.gmail.com>
Subject: Re: [PATCH 2/4] mfd: dbx500-prcmu: Correctly reorder PRCMU clock identifiers
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>, Loic PALLARDY <loic.pallardy@st.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Par-Olof Hakansson <par-olof.hakansson@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 7, 2013 at 4:20 PM, Lee Jones <lee.jones@linaro.org> wrote:
> On Fri, 07 Jun 2013, Linus Walleij wrote:
>
>> > -enum prcmu_clock {
>> > -       PRCMU_SGACLK,
>> (...)
>> > +#define ARMCLK                 0
>> > +#define PRCMU_ACLK             1
>> (...)
>>
>> It seems the enum and the defines want to do two different things?
>>
>> The first is a kernel-internal representation of the clocks, whereas
>> the latter is a HW-centric representation for a certain PRCMU
>> variant (I guess?)
>>
>> Does one actually exclude the other?
>
> From what I can tell, they're non-ordered values which are used as
> read-ins to the clk_mgt array. So long as they are unique I'm not sure
> the order matters. The current order seems 'made up', unless I'm
> mistaken.

Hm, I suspect it might be something to do with the enumeration
inside the PRCMU firmware, but I don't really know. In that case it
could affect the message marshalling, but let's call out the experts...

Yours,
Linus Walleij
