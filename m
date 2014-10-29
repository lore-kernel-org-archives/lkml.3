Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509AbaJ2J4x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 05:56:53 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:58226 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756101AbaJ2J4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 05:56:51 -0400
Message-ID: <1414576607.28499.50.camel@x220>
Subject: Re: CRISv32: ETRAX_SPI_MMC_BOARD
From: Paul Bolle <pebolle@tiscali.nl>
To: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Jesper Nilsson <jespern@axis.com>,
        Valentin Rothberg <valentinrothberg@gmail.com>,
        Mikael Starvik <starvik@axis.com>,
        linux-cris-kernel <linux-cris-kernel@axis.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 29 Oct 2014 10:56:47 +0100
In-Reply-To: <20141029093320.GQ30087@axis.com>
References: <1414570854.28499.34.camel@x220>
	 <20141029093320.GQ30087@axis.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Oct 2014 09:56:47.0958 (UTC) FILETIME=[A77E4760:01CFF35E]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jesper,

On Wed, 2014-10-29 at 10:33 +0100, Jesper Nilsson wrote:
> On Wed, Oct 29, 2014 at 09:20:54AM +0100, Paul Bolle wrote:
> > Your commit be64c1ce6e79 ("CRISv32: Drop obsolete file for SPI driver")
> > landed in today's linux-next (ie, next-20141029). It removes the last
> > user of the Kconfig symbol ETRAX_SPI_MMC_BOARD. Setting that symbol is
> > now pointless.
> > 
> > Is the trivial patch to remove the entry for ETRAX_SPI_MMC_BOARD (and
> > one select statement for it) queued somewhere? If not, should I submit
> > it?
> 
> It was not, but it is now:
> 
> CRISv32: Remove last remnants of ETRAX_SPI_MMC_BOARD
> 
> There are no users of this symbol left.
> 
> Reported-by: Paul Bolle <pebolle@tiscali.nl>
> Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
> ---
>  arch/cris/arch-v32/drivers/Kconfig |    7 -------
>  1 file changed, 7 deletions(-)
> 
> diff --git a/arch/cris/arch-v32/drivers/Kconfig b/arch/cris/arch-v32/drivers/Kconfig
> index 6880f94..7068c4b 100644
> --- a/arch/cris/arch-v32/drivers/Kconfig
> +++ b/arch/cris/arch-v32/drivers/Kconfig
> @@ -361,13 +361,6 @@ config ETRAX_SPI_MMC
>  	default MMC
>  	select SPI
>  	select MMC_SPI
> -	select ETRAX_SPI_MMC_BOARD
> -
> -# For the parts that can't be a module (due to restrictions in
> -# framework elsewhere).
> -config ETRAX_SPI_MMC_BOARD
> -       boolean
> -       default n
>  
>  # While the board info is MMC_SPI only, the drivers are written to be
>  # independent of MMC_SPI, so we'll keep SPI non-dependent on the
> -- 
> 1.7.10.4
> 
> 
> I'll try to think about unreferenced kconfigs in the future,

I'm hoping that Valentin's project will automate detection of these kind
of problems for you (see
http://www.linuxplumbersconf.org/2014/ocw/sessions/1863 ).

> my suspicion is that all those SPI and MMC related configs are
> also unused, just circular references keeping them unnoticed.

Would you have an example?

(I try to check each linux-next release with a 800 line perl monster.
It's just smart enough to detect cases like this. Ie, a Kconfig entry,
whose Kconfig macro isn't used anywhere in the tree, that is not
selecting anything, but that itself is a _target_ of a select statement.

It's not entirely trivial to detect things like that. But perhaps I
could still tweak the tests of that this script to detect even more
unused Kconfig symbols.)

> Thanks for the heads up.

You're welcome. And thanks for taking care of this. Experience shows
that these cleanups go more smoothly if maintainers, actual users, etc.,
do them (instead of random contributors, like me, who are not familiar
with the subsystem they're touching).


Paul Bolle

