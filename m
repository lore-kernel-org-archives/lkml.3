Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751593AbaANN0g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 08:26:36 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:58123 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbaANN0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 08:26:33 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Leif Lindholm <leif.lindholm@linaro.org>
Subject: Re: [PATCH v4 4/5] arm: Add [U]EFI runtime services support
Date: Tue, 14 Jan 2014 14:26:15 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        grant.likely@secretlab.ca, linux-efi@vger.kernel.org,
        linux@arm.linux.org.uk, patches@linaro.org,
        Will Deacon <will.deacon@arm.com>, roy.franz@linaro.org,
        matt.fleming@intel.com, msalter@redhat.com
References: <1389445524-30623-1-git-send-email-leif.lindholm@linaro.org> <201401140752.33257.arnd@arndb.de> <20140114114419.GH30907@bivouac.eciton.net>
In-Reply-To: <20140114114419.GH30907@bivouac.eciton.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201401141426.16497.arnd@arndb.de>
X-Provags-ID: V02:K0:yayI5za+F2vrFN9oV9CbC68Y9IBDiQYy8wIPLF0FJh5
 rYUle4jz5oubEz+hDo9pCxpKB9laivuuOVOxZHQ59+iV/SxKOZ
 +acq6bf750XtHgYy+rOBptASpL4mXLk1dpu3EJxPrNfBxpuhVb
 7i3Rgp4oD6Gi5uQP8uv1sEUD+cJI2uSK+zoNUeRQP51sicZJvN
 v/YO/kRbxoWQMSb7p8XRQhKQ21UgCbayF6cdmBuDY/XA5S2LeY
 uSnKLX73mfZgqM6RZiPjLeOz865Vr4ohsdkRV4vadxSIFypUrS
 ruHPkwZ3zsBcP2gNTTUK6H24QFSfFexkwn+U9mtq7kD8p/k1qx
 8h34guCmz4BossQbBn7o=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 January 2014, Leif Lindholm wrote:
> On Tue, Jan 14, 2014 at 07:52:32AM +0100, Arnd Bergmann wrote:
> > > > > It uses the generic configuration table scanning to populate ACPI and
> > > > > SMBIOS pointers.
> > > > 
> > > > As far as I'm concerned there are no plans to have ACPI support on ARM32,
> > > > so I wonder what the code to populate the ACPI tables is about. Can
> > > > you clarify this?
> > > 
> > > Are you suggesting that I should #ifndef ARM in common code, or that I
> > > should neglect to document what the common code will do with data it is
> > > given by UEFI?
> > 
> > It would probably be good to document the fact that it won't work,
> > possibly even having a BUG_ON statement in the code for this case.
> 
> Why?
> 
> You'll only touch that pointer if you enable CONFIG_ACPI, and if you
> do you probably want that address. Sounds a bit hostile to throw a BUG
> in the face of someone who's (for example) just succeeded to get Linux
> running on a Windows RT device.

But we know that it can't work unless a lot of other things get changed
in the kernel.

> > > > > diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> > > > > index 78a79a6a..1ab24cc 100644
> > > > > --- a/arch/arm/Kconfig
> > > > > +++ b/arch/arm/Kconfig
> > > > > @@ -1853,6 +1853,20 @@ config EARLY_IOREMAP
> > > > >  	  the same virtual memory range as kmap so all early mappings must
> > > > >  	  be unapped before paging_init() is called.
> > > > >  
> > > > > +config EFI
> > > > > +	bool "UEFI runtime service support"
> > > > > +	depends on OF && !CPU_BIG_ENDIAN
> > > > 
> > > > What is the dependency on !CPU_BIG_ENDIAN?
> > > 
> > > Mainly on code not being implemented to byte-reverse UCS strings.
> > 
> > Why would you byte-reverse /strings/? They normally just come in
> > order of the characters, and UTF-16 strings are already defined
> > as being big-endian or marked by the BOM character.
> 
> Well, then that bit might just work[tm].
> 
> Although no other architectures supported by UEFI support big-endian,
> so to be honest, I don't want to have to be the first one to validate
> that in order to get the basic support into the kernel.

I think there was a project to run UEFI on PowerPC on some stage, though
I can't find any code now.

> Some of the data structures might need swizzling though...
> Again - if there is demand, this can be dealt with at a later date.

Ok.

	Arnd
