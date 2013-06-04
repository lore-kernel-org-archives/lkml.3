Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756480Ab3FDGPX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 02:15:23 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:50953 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab3FDGPU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 02:15:20 -0400
MIME-Version: 1.0
In-Reply-To: <201306032339.39176.heiko@sntech.de>
References: <1370281990-15090-1-git-send-email-mturquette@linaro.org>
 <20130603200722.6077.85426@quantum> <201306032215.45983.heiko@sntech.de> <201306032339.39176.heiko@sntech.de>
From: Mike Turquette <mturquette@linaro.org>
Date: Mon, 3 Jun 2013 23:14:58 -0700
Message-ID: <CAPtuhTitiDVBTLF==je9_Ydks5OCqM1cDv-UwPsGkkgwEj6VWQ@mail.gmail.com>
Subject: Re: [PATCH RFC 2/3] clk: dt: binding for basic multiplexor clock
To: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        devicetree-discuss@lists.ozlabs.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 3, 2013 at 2:39 PM, Heiko Stübner <heiko@sntech.de> wrote:
> Am Montag, 3. Juni 2013, 22:15:45 schrieb Heiko Stübner:
>> Am Montag, 3. Juni 2013, 22:07:22 schrieb Mike Turquette:
>> > Quoting Heiko Stübner (2013-06-03 12:33:19)
>> >
>> > > Hi Mike,
>> > >
>> > > I think it's a multiplexEr clock in the patch title, and see below
>> >
>> > Doh, you are right.  But "xor" is so much cooler looking than "xer"...
>> >
>> > > Am Montag, 3. Juni 2013, 19:53:09 schrieb Mike Turquette:
>> > > > Device Tree binding for the basic clock multiplexor, plus the setup
>> > > > function to register the clock.  Based on the existing fixed-clock
>> > > > binding.
>> > > >
>> > > > Also relocate declaration of of_fixed_factor_clk_setup to keep things
>> > > > tidy.
>> > > >
>> > > > Signed-off-by: Mike Turquette <mturquette@linaro.org>
>> > >
>> > > [...]
>> > >
>> > > > +
>> > > > +     reg = of_iomap(node, 0);
>> > > > +     pr_err("%s: reg is 0x%p\n", __func__, reg);
>> > > > +
>> > > > +     if (of_property_read_u32(node, "mask", &mask)) {
>> > > > +             pr_err("%s: missing mask property for %s\n", __func__,
>> > > > node->name); +             return;
>> > > > +     }
>> > > > +
>> > > > +     if (of_property_read_u32(node, "shift", &shift))
>> > > > +             pr_debug("%s: missing shift property defaults to zero
>> > > > for %s\n", +                             __func__, node->name);
>> > > > +
>> > > > +     if (of_property_read_bool(node, "index_one"))
>> > > > +             clk_mux_flags |= CLK_MUX_INDEX_ONE;
>> > > > +
>> > > > +     clk = clk_register_mux_table(NULL, clk_name, parent_names,
>> > > > num_parents, +                     0, reg, 0, mask, clk_mux_flags,
>> > > >
>> > >                       ^- should probably be shift
>> > >
>> > > Otherwise looks cool and I'm currently trying it with my Rockchip code.
>> >
>> > Right again.  My test platform seems to not shift the mask at all so
>> > this did not cause a visible bug for me.
>>
>> I'm currently converting my rockchip stuff to it, as it would solve a lot
>> of problems with the numerous clock types I'm defining just to put the
>> shift and mask values somewhere.
>>
>> So lets see if anything more turns up ;-)
>
> yep ... of_mux_clk_setup is quite talkative ... there are quite some (debug-?)
> pr_errs in it ;-)
>

Yes I realized that after sending.  Hopefully not too many curse words
in the trace messages.  Will remove for v2.

Regards,
Mike

>
> Heiko
