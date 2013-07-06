Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751220Ab3GFW3O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 18:29:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35187 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721Ab3GFW3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 18:29:10 -0400
Date: Sat, 6 Jul 2013 15:30:03 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        tiwai@suse.de
Subject: Re: dell_rbu: Select CONFIG_FW_LOADER_USER_HELPER explicitly
Message-ID: <20130706223003.GA10697@kroah.com>
References: <20130702192749.A2E7E660D9B@gitolite.kernel.org>
 <20130706221401.GA3652@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130706221401.GA3652@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 06, 2013 at 06:14:01PM -0400, Dave Jones wrote:
> On Tue, Jul 02, 2013 at 07:27:49PM +0000, Linux Kernel wrote:
>  > Gitweb:     http://git.kernel.org/linus/;a=commit;h=d05c39ea67f5786a549ac9d672d2951992b658c6
>  > Commit:     d05c39ea67f5786a549ac9d672d2951992b658c6
>  > Parent:     a3b2c8c7aa1ca860edcf0b0afa371d9eb2269c3c
>  > Author:     Takashi Iwai <tiwai@suse.de>
>  > AuthorDate: Wed May 22 18:28:37 2013 +0200
>  > Committer:  Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>  > CommitDate: Mon Jun 3 13:57:29 2013 -0700
>  > 
>  >     dell_rbu: Select CONFIG_FW_LOADER_USER_HELPER explicitly
>  >     
>  >     The usermode helper is mandatory for this driver.
>  >     
>  >     Signed-off-by: Takashi Iwai <tiwai@suse.de>
>  >     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>  > ---
>  >  drivers/firmware/Kconfig |    1 +
>  >  1 files changed, 1 insertions(+), 0 deletions(-)
>  > 
>  > diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
>  > index 9387630..0747872 100644
>  > --- a/drivers/firmware/Kconfig
>  > +++ b/drivers/firmware/Kconfig
>  > @@ -64,6 +64,7 @@ config DELL_RBU
>  >  	tristate "BIOS update support for DELL systems via sysfs"
>  >  	depends on X86
>  >  	select FW_LOADER
>  > +	select FW_LOADER_USER_HELPER
>  >  	help
>  >  	 Say m if you want to have the option of updating the BIOS for your
>  >  	 DELL system. Note you need a Dell OpenManage or Dell Update package (DUP)
> 
> 
> This is pretty crappy. Now every distro kernel has to have that enabled,
> which screws up for eg, the x86 microcode driver. (It takes 1 minute per cpu
> when this is enabled).

I'll let you and Takashi battle this one out, for some reason I thought
he added it _because_ a distro kernel needed it...

Takashi?

