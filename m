Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613AbaCLOZZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 10:25:25 -0400
Received: from smtprelay0159.hostedemail.com ([216.40.44.159]:33308 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754588AbaCLOZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 10:25:20 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:560:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711
X-HE-Tag: crown39_2de4a59e22820
X-Filterd-Recvd-Size: 2534
Message-ID: <1394634313.28839.57.camel@joe-AO722>
Subject: Re: [PATCH v4 4/6] pinctrl: st: Use ARRAY_SIZE instead of raw value
 for number of delays
From: Joe Perches <joe@perches.com>
To: Maxime COQUELIN <maxime.coquelin@st.com>
Cc: Rob Landley <rob@landley.net>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@stlinux.com,
        lee.jones@linaro.org
Date: Wed, 12 Mar 2014 07:25:13 -0700
In-Reply-To: <1394614210-15698-5-git-send-email-maxime.coquelin@st.com>
References: <1394614210-15698-1-git-send-email-maxime.coquelin@st.com>
	 <1394614210-15698-5-git-send-email-maxime.coquelin@st.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-03-12 at 09:50 +0100, Maxime COQUELIN wrote:
> This patch replaces the raw values with ARRAY_SIZE for assigning the
> ninput_delays and noutput_delays fields of STiH416's st_pctl_data struct.

trivial note:

> diff --git a/drivers/pinctrl/pinctrl-st.c b/drivers/pinctrl/pinctrl-st.c
[]
> @@ -384,9 +384,9 @@ static unsigned int stih416_delays[] = {0, 300, 500, 750, 1000, 1250, 1500,
>  static const struct st_pctl_data  stih416_data = {
>  	.rt_style	= st_retime_style_dedicated,
>  	.input_delays	= stih416_delays,
> -	.ninput_delays	= 14,
> +	.ninput_delays	= ARRAY_SIZE(stih416_delays),
>  	.output_delays	= stih416_delays,
> -	.noutput_delays = 14,
> +	.noutput_delays = ARRAY_SIZE(stih416_delays),
>  	.alt = 0, .oe = 40, .pu = 50, .od = 60, .rt = 100,
>  };
>  

drivers/pinctrl/pinctrl-st.c-   unsigned int    *input_delays;
drivers/pinctrl/pinctrl-st.c-   unsigned int    *output_delays;

It may be better to change these to const unsigned int *
and change

static unsigned int stih416_delays[] = {

to static const


