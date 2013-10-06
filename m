Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab3JFRRR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 13:17:17 -0400
Received: from gw.cm.dream.jp ([59.157.128.2]:48154 "EHLO vsmtp02.cm.dti.ne.jp"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753546Ab3JFRRP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 13:17:15 -0400
Date: Mon, 7 Oct 2013 02:16:52 +0900
From: Takashi YOSHII <takasi-y@ops.dti.ne.jp>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Simon Horman <horms@verge.net.au>, SH-Linux <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, ben.dooks@codethink.co.uk,
        Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>,
        devicetree@vger.kernel.org, linux-serial@vger.kernel.org,
        Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] ARM: shmobile: emev2: Define SMU clock DT bindings
Message-Id: <20131007021652.ced3167a4d03eec809d0b6ee@ops.dti.ne.jp>
In-Reply-To: <21574726.tiJa6Opb1k@avalon>
References: <52410F86.4040301@renesas.com>
	<20130924131331.0e9a5f830f531655b2ea0ebe@ops.dti.ne.jp>
	<20130924045215.GE3619@verge.net.au>
	<21574726.tiJa6Opb1k@avalon>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

> > > Device tree clock binding document for EMMA Mobile EV2 SMU.
> > > Following nodes are defined to describe clock tree.
> > > - renesas,emev2-smu
> > > - renesas,emev2-smu-clkdiv
> > > - renesas,emev2-smu-gclk
> > 
> > I realise this has been entirely consistent in the past and
> > even as recently as Linus' pre v3.12-rc2 master branch.
> > However, after some recent discussion we are now trying to make our
> > compatibility strings consistently of the form renesas,<unit>-<soc>.
> > 
> > With this in mind I believe the strings should be:
> > 
> > - renesas,smu-emev2
> > - renesas,smu-clkdiv-emev2
> > - renesas,smu-gclk-emev2
> > 
> > To be honest I am not quite sure about the "-clkdiv" and "-gclk"
> > bits and I would appreciate some review from others.
> 
> I don't have access to the EMEV2 datasheet so my ability to comment on this is 
> somehow limited. However, given that the clock hardware is very SoC-specific, 
> it might make sense to keep the names proposed by Yoshii-san. This would be 
> consistent with the other clock bindings.

Just for explanation:
EM/EV2(there is "/" according to its Users Manual) might be a little difficult
 one for general discussion. It stands for "EMMA Mobile EV2", and is a SoC of
"EMMA Mobile" series, they say. So, possibly, the string was
 emmamobile-smu or emmamobile-smu-ev2 if it is EV2 specific variant.

But, EMEV2 is the only SoC known in EMMA Mobile series, and no document found
 to tell if some other one(if any. there used to be, they say) has SMU or not. 
That's why I choose "emev2-smu". This is <unit> part, and no <soc> portion.

> > > +++ b/Documentation/devicetree/bindings/clock/emev2-clock.txt
...
> > > +Example of provider:
> > > +
> > > +usia_u0_sclkdiv: usia_u0_sclkdiv {
> > > +	compatible = "renesas,emev2-smu-clkdiv";
> > > +	reg = <0x610 0>;
> 
> Is the registers space really 0 bytes long ?

Both those are address. as
> > +- reg: Byte offset from SMU base and Bit position in the register

The outer unit (smu) does
> > > +	#address-cells = <2>;
> > > +	#size-cells = <0>;
and no "ranges".
These clock node is defined not as memory-mapped.

Looks strange? I think so.
This _was introduced_ to comply ePAPR that requires the node name to consist
of generic name and @address to make it unique.
So, the first version was like this.
| usia_u0_sclkdiv: clock@610,0 {
| 	compatible = "renesas,emev2-smu-clkdiv";
| 	reg = <0x610 0>;

But later, I trashed it for the consistency with clock nodes without <reg>, say
> > > +	c32ki: c32ki {
> > > +		compatible = "fixed-clock";

I am still not sure what the clock nodes should be. But, I think what we are
 discussing is out of the scope of current ePAPR, which does not give the answer.

> > > +
> 
> There's an extra blank line at the end of the file.
Oops. Thank you.
/yoshii
