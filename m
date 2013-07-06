Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751524Ab3GFWOQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 18:14:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13093 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750703Ab3GFWOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 18:14:14 -0400
Date: Sat, 6 Jul 2013 18:14:01 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: gregkh@linuxfoundation.org, tiwai@suse.de
Subject: Re: dell_rbu: Select CONFIG_FW_LOADER_USER_HELPER explicitly
Message-ID: <20130706221401.GA3652@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	gregkh@linuxfoundation.org, tiwai@suse.de
References: <20130702192749.A2E7E660D9B@gitolite.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130702192749.A2E7E660D9B@gitolite.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 02, 2013 at 07:27:49PM +0000, Linux Kernel wrote:
 > Gitweb:     http://git.kernel.org/linus/;a=commit;h=d05c39ea67f5786a549ac9d672d2951992b658c6
 > Commit:     d05c39ea67f5786a549ac9d672d2951992b658c6
 > Parent:     a3b2c8c7aa1ca860edcf0b0afa371d9eb2269c3c
 > Author:     Takashi Iwai <tiwai@suse.de>
 > AuthorDate: Wed May 22 18:28:37 2013 +0200
 > Committer:  Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 > CommitDate: Mon Jun 3 13:57:29 2013 -0700
 > 
 >     dell_rbu: Select CONFIG_FW_LOADER_USER_HELPER explicitly
 >     
 >     The usermode helper is mandatory for this driver.
 >     
 >     Signed-off-by: Takashi Iwai <tiwai@suse.de>
 >     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 > ---
 >  drivers/firmware/Kconfig |    1 +
 >  1 files changed, 1 insertions(+), 0 deletions(-)
 > 
 > diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
 > index 9387630..0747872 100644
 > --- a/drivers/firmware/Kconfig
 > +++ b/drivers/firmware/Kconfig
 > @@ -64,6 +64,7 @@ config DELL_RBU
 >  	tristate "BIOS update support for DELL systems via sysfs"
 >  	depends on X86
 >  	select FW_LOADER
 > +	select FW_LOADER_USER_HELPER
 >  	help
 >  	 Say m if you want to have the option of updating the BIOS for your
 >  	 DELL system. Note you need a Dell OpenManage or Dell Update package (DUP)


This is pretty crappy. Now every distro kernel has to have that enabled,
which screws up for eg, the x86 microcode driver. (It takes 1 minute per cpu
when this is enabled).

	Dave

