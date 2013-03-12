Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947Ab3CLAvv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 20:51:51 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:47782 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754484Ab3CLAvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 20:51:50 -0400
Date: Tue, 12 Mar 2013 01:51:06 +0100
From: Davide Ciminaghi <ciminaghi@gnudd.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        rubini@gnudd.com, sameo@linux.intel.com, giancarlo.asnaghi@st.com,
        mturquette@linaro.org, linus.walleij@linaro.org,
        rob.herring@calxeda.com, broonie@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] x86, pci sta2x11-fixup: add function to access sta2x11 instance id
Message-ID: <20130312005106.GB15494@mail.gnudd.com>
References: <1362756691-14736-1-git-send-email-ciminaghi@gnudd.com> <1362756691-14736-3-git-send-email-ciminaghi@gnudd.com> <201303081613.34371.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <201303081613.34371.arnd@arndb.de>
X-Face: #Q;A)@_4.#>0+_%y]7aBr:c"ndLp&#+2?]J;lkse\^)FP^Lr5@O0{)J;'nny4%74.fM'n)M
	>ISCj.KmsL/HTxz!:Ju'pnj'Gz&.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 08, 2013 at 04:13:34PM +0000, Arnd Bergmann wrote:
> On Friday 08 March 2013, Davide Ciminaghi wrote:
> > 
> > The sta2x11 instance id will be included in clock names to make them
> > unique in case of multiple sta2x11's living on the same machine.
> > 
> > Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>
> 
> I might be missing something, but this seems counterintuitive. Shouldn't
> the clock names really be constant and independent of the instance?
> 
> The instance should be identified already by the dev_name, right?
>
Hi,

sorry for the delay.
Well, I actually wrote this some months ago, so I might also be missing
something (yes, I know I shouldn't :-).
If I understand well, I should call clk_register_* with dev pointing to
the struct device corresponding to the sta2x11 instance to which the clock
belongs and a constant name (while currently I set dev to NULL and use a
different name for each instance of the same clock, by postfixing the name
with an instance id).
You're probably right, even if looking at the code in drivers/clk/clk.c,
there's something I'm not sure about (and I cannot do any tests right now):

_clk_register() takes hw->init->name as clock name, where hw->init->name
should come from the second arg of clk_register_*, if I'm not wrong.
Then __clk_init does:

if (__clk_lookup(clk->name)) {
   	pr_debug("%s: clk %s already initialized\n", __func__, clk->name);
	ret = -EEXIST;
	goto out;
}

Is it actually possible registering multiple clocks with the same name ?
Sorry maybe I missed your point ...


Thanks and regards
Davide
