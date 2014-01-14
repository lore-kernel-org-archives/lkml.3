Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751915AbaANQN3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 11:13:29 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:34518 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751521AbaANQN1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 11:13:27 -0500
Date: Tue, 14 Jan 2014 17:12:58 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Mark Brown <broonie@kernel.org>
Cc: lgirdwood@gmail.com, Xiubo Li <Li.Xiubo@freescale.com>,
        alsa-devel@alsa-project.org, kuninori.morimoto.gx@renesas.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: simple-card: simplify code
Message-ID: <20140114171258.2d027ee5@armhf>
In-Reply-To: <20140114142014.GM15567@sirena.org.uk>
References: <20140114123606.2241d8ab@armhf>
	<20140114142014.GM15567@sirena.org.uk>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Jan 2014 14:20:14 +0000
Mark Brown <broonie@kernel.org> wrote:

> On Tue, Jan 14, 2014 at 12:36:06PM +0100, Jean-Francois Moine wrote:
> > This patch
> > - removes the fields of the platform data which are of no use to the
> >   non-DT platform callers,
> > - uses a new private structure to handle all the sound card information,
> > - simplifies the code and make easier a possible multi-DAI links extension.
> > 
> > Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
> > ---
> > Xiubo, I also removed 'of_device_is_available' which seems really
> > useless: the module is not probed when the DT status is not "okay".
> 
> Please send this as a patch series to aid review, one patch doing four
> different changes is much harder to review.

As there are other bugs to fix, I may put back the 'of_device_is_available',
but there are not 3 different changes: I just explain the visible
effects of the patch. The patch itself is, as the subject says,
'simplify code', that is, 'have a simpler code with no change in the
logic'.

> >  		ret = asoc_simple_card_sub_parse_of(np,
> > -						  &info->cpu_dai,
> > -						  of_cpu);
> > +						  &priv->cpu_dai,
> > +					  (struct device_node **)
> > +						  &dai_link->cpu_of_node,
> > +						  &dai_link->cpu_dai_name);
> 
> 
> What's this cast here for?  That code doesn't look at all safe.

dai_link->cpu_of_node is 'const struct device_node *' and both
of_clk_get() and of_node_put() want 'struct device_node *'. So, there
must be a cast somewhere.

Do you prefer I put these ones when calling the 'of_xx' functions?

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
