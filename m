Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816AbaJ0NUi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 09:20:38 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:30210 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbaJ0NUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 09:20:35 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX180P3es0fXbzLfLXlcX1XgrbLZRiVNOJGA=
X-DKIM: OpenDKIM Filter v2.0.1 titan 94D956093D5
Date: Mon, 27 Oct 2014 09:20:31 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Eric Rost <eric.rost@mybabylon.net>
Cc: gregkh@linuxfoundation.org, jake@lwn.net, antonysaraev@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 0/7] staging: skein: CryptoAPI and Module Support
Message-ID: <20141027132031.GB15252@titan.lakedaemon.net>
References: <cover.1414189566.git.eric.rost@mybabylon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1414189566.git.eric.rost@mybabylon.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

On Fri, Oct 24, 2014 at 05:29:09PM -0500, Eric Rost wrote:
> Adds CryptoAPI and loadable module support to the Skein Hashing
> Algorithm. Collapses threefish module into skein module. Renames skein.c
> and skein.h to skein_base.c and skein_base.h so module can be named
> skein.ko. Inlines rotl_64 macro. Removes unneeded #define and
> skein_debug.h include.
> 
> Eric Rost (7):
>   staging: skein: Collapses threefish module
>   staging: skein: Renames skein to skein_base
>   staging: skein: Adds CryptoAPI Support
>   staging: skein: Adds Loadable Module Support
>   staging: skein: Inlines rotl_64
>   staging: skein: Removes unneeded #define

For patches 1 through 6,

Reviewed-by: Jason Cooper <jason@lakedaemon.net>

We'll keep working on #7, but feel free to take the first six when you
get a moment Greg.

thx,

Jason.

>   staging: skein: Removes skein_debug include
> 
>  drivers/staging/skein/Kconfig                   |  24 +--
>  drivers/staging/skein/Makefile                  |  13 +-
>  drivers/staging/skein/skein_api.h               |   2 +-
>  drivers/staging/skein/{skein.c => skein_base.c} |   5 +-
>  drivers/staging/skein/{skein.h => skein_base.h} |  31 ++--
>  drivers/staging/skein/skein_block.c             |   2 +-
>  drivers/staging/skein/skein_block.h             |   2 +-
>  drivers/staging/skein/skein_generic.c           | 216 ++++++++++++++++++++++++
>  drivers/staging/skein/skein_iv.h                |   2 +-
>  drivers/staging/skein/threefish_api.h           |   2 +-
>  10 files changed, 249 insertions(+), 50 deletions(-)
>  rename drivers/staging/skein/{skein.c => skein_base.c} (99%)
>  rename drivers/staging/skein/{skein.h => skein_base.h} (95%)
>  create mode 100644 drivers/staging/skein/skein_generic.c
> 
> -- 
> 2.1.1
> 
