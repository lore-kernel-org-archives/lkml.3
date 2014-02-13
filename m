Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751277AbaBMTSq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 14:18:46 -0500
Received: from gloria.sntech.de ([95.129.55.99]:48638 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbaBMTSp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 14:18:45 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>
Subject: Re: [PATCH] regulator: gpio-regulator: fix forgotten gpios-states reading
Date: Thu, 13 Feb 2014 20:17:54 +0100
Message-ID: <1528469.iBzMKAUgWB@phil>
User-Agent: KMail/4.11.3 (Linux/3.11-2-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <20140213190322.GA28112@sirena.org.uk>
References: <9348920.79Ktlcbcai@phil> <20140213190322.GA28112@sirena.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 13. Februar 2014, 19:03:22 schrieb Mark Brown:
> On Thu, Feb 13, 2014 at 12:48:52AM +0100, Heiko Stübner wrote:
> > From: Heiko Stuebner <heiko.stuebner@bqreaders.com>
> > 
> > Commit 934624d6e9f0 ("regulator: gpio-regulator: do not open-code counting
> > and access of dt array elements") forgot to convert the recently added
> > gpios-states property using the same pattern.
> 
> Morimoto-san sent a fix which did apply so I took that.

The gpio-state code also uses the pattern, that we're trying to remove (open-
coding dt element counting and exposing dtb internals, aka be32_to_cpup).

So reintroducing the "struct property" fixes the compile issue but does not 
resolve the underlying issue we're trying to improve.

So I would argue for removing this commit again in favor of my v2 sent 16:34.


Heiko
