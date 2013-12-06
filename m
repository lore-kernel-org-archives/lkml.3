Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758542Ab3LFOzt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 09:55:49 -0500
Received: from mail-db9lp0251.outbound.messaging.microsoft.com ([213.199.154.251]:15087
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751347Ab3LFOzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 09:55:47 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(z579ehz98dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6h1082kzz1de097hz2dh2a8h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h1155h)
Date: Fri, 6 Dec 2013 22:38:17 +0800
From: Nicolin Chen <b42378@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: <lgirdwood@gmail.com>, <alsa-devel@alsa-project.org>, <tiwai@suse.de>,
        <perex@perex.cz>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <rob@landley.net>, <ijc+devicetree@hellion.org.uk>,
        <swarren@wwwdotorg.org>, <mark.rutland@arm.com>, <pawel.moll@arm.com>,
        <rob.herring@calxeda.com>
Subject: Re: [PATCH 3/3] ASoC: fsl: imx-wm8962: Add headphone and microphone
 jack plugin/out detection
Message-ID: <20131206143817.GB29975@MrMyself>
References: <cover.1386322845.git.b42378@freescale.com>
 <82d3285b7efe1f98dbc3d9c0a423b2e5e454481f.1386322845.git.b42378@freescale.com>
 <20131206144256.GI29268@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20131206144256.GI29268@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 06, 2013 at 02:42:56PM +0000, Mark Brown wrote:
> On Fri, Dec 06, 2013 at 05:48:23PM +0800, Nicolin Chen wrote:
> 
> > Therefore, this patch mainly adds jack event detection feature and switchs I/O
> > routes accordingly. Meanwhile, for those monaural input cases, we also turn on
> > the ADC monomix features of WM8962 if needed.
> 
> No, the kernel shouldn't be doing any route switching or other
> configuration - that should be done by userspace.  This is a policy
> decision, there are situations where for example audio should go to both
> headphones and speaker when headphones are connected in order to make
> sure notifications are audible even if headpones have been removed.

I see...It seems my solution is too specific. I will re-think about it.

> > +	if (hp_status != priv->hp_active_low) {
> > +		snprintf(buf, 32, "STATE=%d", 2);
> > +		snd_soc_dapm_disable_pin(&priv->codec->dapm, "Ext Spk");
> > +		ret = imx_hp_jack_gpio.report;
> > +	} else {
> > +		snprintf(buf, 32, "STATE=%d", 0);
> > +		snd_soc_dapm_enable_pin(&priv->codec->dapm, "Ext Spk");
> > +		ret = 0;
> > +	}
> > +
> > +	envp[0] = "NAME=headphone";
> > +	envp[1] = buf;
> > +	envp[2] = NULL;
> > +	kobject_uevent_env(&pdev->dev.kobj, KOBJ_CHANGE, envp);
> 
> What's this uevent trying to do and why is it open coded in the driver?

That's a requirement from Android team of Freescale. By checking this
event they can determine whether current output is speaker or headphone
so as to place an icon on the notification area.

Sir, if you think this patch is not common enough or non-community style,
I can try to cut it down to an common one or entirely drop it.

Looking forward to your reply,
Nicolin Chen



