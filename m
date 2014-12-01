Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932502AbaLAVDa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 16:03:30 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:49117 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932160AbaLAVD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 16:03:29 -0500
MIME-Version: 1.0
In-Reply-To: <547CD2C6.2060107@tabi.org>
References: <1417402251-6596-1-git-send-email-jiada_wang@mentor.com>
	<2547588.Qc4F2IfZke@wuerfel>
	<547CC89F.1030205@tabi.org>
	<3401240.VsRpsiV8WN@wuerfel>
	<547CCB78.5090007@tabi.org>
	<547CCFF7.2000205@metafoo.de>
	<CAOMZO5B7MxLSaETUW0QyajdHMMX2nLg=t=5dVCNRePb6UzizRQ@mail.gmail.com>
	<547CD2C6.2060107@tabi.org>
Date: Mon, 1 Dec 2014 19:03:27 -0200
Message-ID: <CAOMZO5Cz60D5V2uKM4ivWp9s44XXqVsuEJhpmSWoBuq+yUvNMw@mail.gmail.com>
Subject: Re: [alsa-devel] [PATCH] ASoC: fsl_ssi: free irq before irq_dispose_mapping()
From: Fabio Estevam <festevam@gmail.com>
To: Timur Tabi <timur@tabi.org>
Cc: Lars-Peter Clausen <lars@metafoo.de>, Arnd Bergmann <arnd@arndb.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Jiada Wang <jiada_wang@mentor.com>, Xiubo Li <Li.Xiubo@freescale.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Nicolin Chen <nicoleotsuka@gmail.com>, Takashi Iwai <tiwai@suse.de>,
        Mark Brown <broonie@kernel.org>, Markus Pargmann <mpa@pengutronix.de>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 1, 2014 at 6:42 PM, Timur Tabi <timur@tabi.org> wrote:

> Would the mapping continue to exist after the driver is unloaded?  Can you
> try multiple loads/unloads and see if interrupts still work?

I tried multiple loads/unloads and audio works fine with those changes.

About the ssi irq we have:

- With the ssi driver loaded:
root@freescale /home$ cat /proc/interrupts | grep ssi
 79:          0          0          0          0       GIC  79  202c000.ssi

- After removing the ssi driver:
root@freescale /home$ rmmod   snd-soc-fsl-ssi
root@freescale /home$ cat /proc/interrupts | grep ssi
root@freescale /home$

,so it seems to behave properly.
