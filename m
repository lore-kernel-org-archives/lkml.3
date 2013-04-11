Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200Ab3DKHqI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 03:46:08 -0400
Received: from webbox1416.server-home.net ([77.236.96.61]:41697 "EHLO
	webbox1416.server-home.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753802Ab3DKHqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 03:46:06 -0400
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: Christian Ruppert <christian.ruppert@abilis.com>,
        linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Noam Camus <noamc@ezchip.com>,
        pierrick hascoet <pierrick.hascoet@abilis.com>
Subject: Re: [PATCH] Add option to disable kernel compression
Date: Thu, 11 Apr 2013 09:46:02 +0200
Message-ID: <2065777.DKEM6dSyjc@ws-stein>
User-Agent: KMail/4.10.1 (Linux/3.7.10-gentoo; KDE/4.10.1; x86_64; ; )
In-Reply-To: <51666860.5060407@synopsys.com>
References: <1365508161-32154-1-git-send-email-christian.ruppert@abilis.com> <51666860.5060407@synopsys.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thursday 11 April 2013 13:08:08, Vineet Gupta wrote:
> On 04/09/2013 05:19 PM, Christian Ruppert wrote:
> > Until now, kernel compression can only be disabled by deselecting
> > HAVE_<compression> in the architecture Kconfig. However, some
> > users/platforms within the same architecture might want to use
> > compression while others might want to disable it.
> > This patch is a solution to the dilemma.
> >
> > Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>
> > ---
> >  init/Kconfig |    8 +++++++-
> >  1 files changed, 7 insertions(+), 1 deletions(-)
> >
> > diff --git a/init/Kconfig b/init/Kconfig
> > index 5341d72..0924c51 100644
> > --- a/init/Kconfig
> > +++ b/init/Kconfig
> > @@ -101,7 +101,6 @@ config HAVE_KERNEL_LZO
> >  choice
> >  	prompt "Kernel compression mode"
> >  	default KERNEL_GZIP
> > -	depends on HAVE_KERNEL_GZIP || HAVE_KERNEL_BZIP2 || HAVE_KERNEL_LZMA || HAVE_KERNEL_XZ || HAVE_KERNEL_LZO
> >  	help
> >  	  The linux kernel is a kind of self-extracting executable.
> >  	  Several compression algorithms are available, which differ
> > @@ -120,6 +119,13 @@ choice
> >  
> >  	  If in doubt, select 'gzip'
> >  
> > +config KERNEL_UNCOMPRESSED
> > +	bool "No compression"
> 
> > +	help
> > +	  No compression at all. The kernel is huge but the compression and
> > +	  decompression times are zero.
> > +	  This is usually not what you want.
> > +
> >  config KERNEL_GZIP
> >  	bool "Gzip"
> >  	depends on HAVE_KERNEL_GZIP
> 
> FWIW, this is an issue for ARC port where one of our platforms runs on a very slow
> FPGA, hence doesn't want to spend time uncompressing the image - while others do
> want the gzip.
> 
> Reviewed-by: Vineet Gupta <vgupta@synopsys.com>

Even some other platforms, e.g. ARM you want no compression, if you can effort the additional space, if you want to boot extremely fast.

Best regards,
Alexander

