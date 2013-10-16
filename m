Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934027Ab3JPL3r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 07:29:47 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:55811 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932542Ab3JPL3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 07:29:45 -0400
MIME-Version: 1.0
In-Reply-To: <20131015134526.GB7461@ab42.lan>
References: <20131008122145.GA21985@ab42.lan>
	<1381235122-23730-3-git-send-email-christian.ruppert@abilis.com>
	<CACRpkdaMq1bzcTP6KZCGuWSm2MB0vSmJ4aRskuQNB8at4YnWRQ@mail.gmail.com>
	<20131015134526.GB7461@ab42.lan>
Date: Wed, 16 Oct 2013 13:29:44 +0200
Message-ID: <CACRpkdZjfNJtAsbge+HsWZQjNREnJQ7msyPy9g3cMLtc8KhmPg@mail.gmail.com>
Subject: Re: [PATCH 03/03] GPIO: Add TB10x GPIO driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Christian Ruppert <christian.ruppert@abilis.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Patrice CHOTARD <patrice.chotard@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sascha Leuenberger <sascha.leuenberger@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 3:45 PM, Christian Ruppert
<christian.ruppert@abilis.com> wrote:
> On Wed, Oct 09, 2013 at 02:19:17PM +0200, Linus Walleij wrote:

>> It's not like I'm 100% certain on where to use one or the other
>> construct (a mechanism like the above is needed for threaded
>> IRQs I've noticed) but the chained handler seems more to the
>> point does it not?
>>
>> The only downside I've seen is that the parent IRQ does not get
>> a name and the accumulated IRQ stats in /proc/interrupts but
>> surely we can live without that (or fix it).
>>
>> Since I'm a bit rusty on chained IRQs correct me if I'm wrong...
>
> OK, it took me a while to figure this back out again because as far as
> I'm familiar with the IRQ framework you're right. The reason I'm not
> using irq_set_chained_handler is that we have one driver instance per
> GPIO bank and all GPIO banks share the same interrupt line. This means
> every driver instance needs its own (different) user data and a simple
> call to irq_set_handler_data(tb10x_gpio) won't suffice. I'm not aware of
> any mechanism that allows interrupt sharing with the
> irq_set_chained_handler() mechanism.

OK yes makes perfect sense. We'll live with this then.

I didn't see a new version of this patch with the other two, shall
I just apply this last version in the pin control tree with the
two other patches?

Yours,
Linus Walleij
