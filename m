Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282AbaIEMJi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 08:09:38 -0400
Received: from e24smtp05.br.ibm.com ([32.104.18.26]:56695 "EHLO
	e24smtp05.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098AbaIEMJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 08:09:36 -0400
Date: Fri, 5 Sep 2014 09:09:25 -0300
From: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
To: Michael Neuling <mikey@neuling.org>
Cc: Gabriel Paubert <paubert@iram.es>, Michal Marek <mmarek@suse.cz>,
        linux-kbuild@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Anton Blanchard <anton@samba.org>,
        Leann Ogasawara <leann.ogasawara@canonical.com>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH v2] deb-pkg: Add support for powerpc little endian
Message-ID: <20140905120925.GB3846@oc0268524204.ibm.com>
References: <1409894927.11359.26.camel@ale.ozlabs.ibm.com>
 <20140905071344.GA16024@visitor2.iram.es>
 <1409903718.11359.30.camel@ale.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409903718.11359.30.camel@ale.ozlabs.ibm.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14090512-1798-0000-0000-000000644B9F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 05:55:18PM +1000, Michael Neuling wrote:
> On Fri, 2014-09-05 at 09:13 +0200, Gabriel Paubert wrote:
> > On Fri, Sep 05, 2014 at 03:28:47PM +1000, Michael Neuling wrote:
> > > The Debian powerpc little endian architecture is called ppc64le.  This
> > 
> > Huh? ppc64le or ppc64el?
> 
> ppc64el.  Commit message is wrong.  Fixed below.
> 
> Mikey
> 
> 

What about ppc64?

Also, I sent that already a month ago. Both linuxppc-dev and Michal
Marek were on cc.

http://marc.info/?l=linux-kernel&m=140744360328562&w=2

Cascardo.

> From: Michael Neuling <mikey@neuling.org>
> 
> deb-pkg: Add support for powerpc little endian
> 
> The Debian powerpc little endian architecture is called ppc64el.  This
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
> 
> 
> 
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev

