Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141AbaIEHuw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 03:50:52 -0400
Received: from navarro.puc.rediris.es ([130.206.18.131]:39824 "EHLO
	navarro.puc.rediris.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbaIEHuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 03:50:51 -0400
X-Greylist: delayed 2195 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Sep 2014 03:50:51 EDT
X-Envelope-From: paubert@iram.es
Date: Fri, 5 Sep 2014 09:13:44 +0200
From: Gabriel Paubert <paubert@iram.es>
To: Michael Neuling <mikey@neuling.org>
Cc: Michal Marek <mmarek@suse.cz>, Ben Hutchings <ben@decadent.org.uk>,
        Leann Ogasawara <leann.ogasawara@canonical.com>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Anton Blanchard <anton@samba.org>, linux-kbuild@vger.kernel.org
Subject: Re: deb-pkg: Add support for powerpc little endian
Message-ID: <20140905071344.GA16024@visitor2.iram.es>
References: <1409894927.11359.26.camel@ale.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409894927.11359.26.camel@ale.ozlabs.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spamina-Bogosity: Ham
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 03:28:47PM +1000, Michael Neuling wrote:
> The Debian powerpc little endian architecture is called ppc64le.  This

Huh? ppc64le or ppc64el?

> is the default architecture used by Ubuntu for powerpc.
> 
> The below checks the kernel config to see if we are compiling little
> endian and sets the Debian arch appropriately.
> 
> Signed-off-by: Michael Neuling <mikey@neuling.org>
> 
> diff --git a/scripts/package/builddeb b/scripts/package/builddeb
> index 35d5a58..6f4a1af 100644
> --- a/scripts/package/builddeb
> +++ b/scripts/package/builddeb
> @@ -37,7 +37,7 @@ create_package() {
>  	s390*)
>  		debarch=s390$(grep -q CONFIG_64BIT=y $KCONFIG_CONFIG && echo x || true) ;;
>  	ppc*)
> -		debarch=powerpc ;;
> +		debarch=$(grep -q CPU_LITTLE_ENDIAN=y $KCONFIG_CONFIG && echo ppc64el || echo powerpc) ;;
>  	parisc*)
>  		debarch=hppa ;;
>  	mips*)


	Gabriel
