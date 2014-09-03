Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950AbaICTrM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 15:47:12 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:35124 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753434AbaICTrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 15:47:08 -0400
Message-ID: <1409773623.21827.102.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH v2 2/3] integrity: move integrity subsystem options to a
 separate menu
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.kasatkin@gmail.com
Date: Wed, 03 Sep 2014 15:47:03 -0400
In-Reply-To: <54070FD8.6060409@samsung.com>
References: <cover.1409728926.git.d.kasatkin@samsung.com>
	 <bce4893d9928b4c6ba9e69e8b4d858489acf6e9e.1409728926.git.d.kasatkin@samsung.com>
	 <1409747724.21827.48.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <54070FD8.6060409@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14090319-0928-0000-0000-0000049C624A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-09-03 at 15:55 +0300, Dmitry Kasatkin wrote: 
> On 03/09/14 15:35, Mimi Zohar wrote:
> > On Wed, 2014-09-03 at 10:29 +0300, Dmitry Kasatkin wrote: 
> >> Integrity subsystem got lots of options and takes more than half
> >> of security menu.
> >>
> >> This patch moves integrity subsystem options to a separate menu.
> >> It does not affect existing configuration. Re-configuration is
> >> not needed.
> >>
> >> Changes in v2:
> >> - previous patch moved integrity out of the 'security' menu.
> >>   This version keeps integrity as a security option (Mimi).
> >>
> >> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
> >> ---
> >>  security/integrity/Kconfig     | 14 ++++++++++++--
> >>  security/integrity/evm/Kconfig |  9 +--------
> >>  security/integrity/ima/Kconfig |  3 +--
> >>  3 files changed, 14 insertions(+), 12 deletions(-)
> >>
> >> diff --git a/security/integrity/Kconfig b/security/integrity/Kconfig
> >> index f79d853..a734a83 100644
> >> --- a/security/integrity/Kconfig
> >> +++ b/security/integrity/Kconfig
> >> @@ -1,7 +1,13 @@
> >>  #
> >>  config INTEGRITY
> >> -	def_bool y
> >> -	depends on IMA || EVM
> >> +	bool "Integrity subsystem support"
> >> +	depends on SECURITY
> >> +	default y
> >> +
> >> +if INTEGRITY
> >> +
> >> +menu "Options"
> >> +
> > Instead of moving everything to a separate menu, I would leave the
> > ability to enable/disable IMA and EVM on the security page, but move
> > their options to separate pages.  So unless someone wants to change the
> > default options, they're hidden.
> >
> > There are Kconfig examples for enabling the option in the parent
> > directory and clicking on the option brings up a separate menu (eg. NET,
> > WIRELESS).
> 
> Hi,
> 
> I posted this patch already 3 times before. This is 4th time.
> 
> In last post you answered:
> 
> "Agreed, but this patch moves integrity out of the 'security' menu.  The
> following keeps integrity as a security option."
> 
> Now you tell me this?

The current change just doesn't look right.

[] Integrity subsystem support
   [] Options

I should be able to just click on "Integrity subsystem support", not the
"Options", to bring up the integrity menu.  Unfortunately, "menuconfig"
moves the integrity option out of the security menu.

Bringing everything under INTEGRITY is fine.  All of the other security
subsystems are listed in the security menu.  I really don't see a
problem with leaving integrity there too.  For now, lets just drop the
"Options" menu.

Mimi

> 
> - Dmitry
> 
> >>  config INTEGRITY_SIGNATURE
> >>  	boolean "Digital signature verification using multiple keyrings"
> >> @@ -46,3 +52,7 @@ config INTEGRITY_AUDIT
> >>
> >>  source security/integrity/ima/Kconfig
> >>  source security/integrity/evm/Kconfig
> >> +
> >> +endmenu
> >> +
> >> +endif   # if INTEGRITY
> >> diff --git a/security/integrity/evm/Kconfig b/security/integrity/evm/Kconfig
> >> index d606f3d..df20a2f 100644
> >> --- a/security/integrity/evm/Kconfig
> >> +++ b/security/integrity/evm/Kconfig
> >> @@ -1,6 +1,6 @@
> >>  config EVM
> >>  	boolean "EVM support"
> >> -	depends on SECURITY
> >> +	depends on INTEGRITY
> > By adding the "if INTEGRITY",  the "depends on INTEGRITY" is redundant.
> > Please remove the depends here and in the other places.
> >
> > Mimi
> >
> >>  	select KEYS
> >>  	select ENCRYPTED_KEYS
> >>  	select CRYPTO_HMAC
> >> @@ -12,10 +12,6 @@ config EVM
> >>
> >>  	  If you are unsure how to answer this question, answer N.
> >>
> >> -if EVM
> >> -
> >> -menu "EVM options"
> >> -
> >>  config EVM_ATTR_FSUUID
> >>  	bool "FSUUID (version 2)"
> >>  	default y
> >> @@ -47,6 +43,3 @@ config EVM_EXTRA_SMACK_XATTRS
> >>  	  additional info to the calculation, requires existing EVM
> >>  	  labeled file systems to be relabeled.
> >>
> >> -endmenu
> >> -
> >> -endif
> >> diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
> >> index 08758fb..2477d1e 100644
> >> --- a/security/integrity/ima/Kconfig
> >> +++ b/security/integrity/ima/Kconfig
> >> @@ -2,8 +2,7 @@
> >>  #
> >>  config IMA
> >>  	bool "Integrity Measurement Architecture(IMA)"
> >> -	depends on SECURITY
> >> -	select INTEGRITY
> >> +	depends on INTEGRITY
> >>  	select SECURITYFS
> >>  	select CRYPTO
> >>  	select CRYPTO_HMAC
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


