Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760771Ab3EBRwn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 13:52:43 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:50773 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760289Ab3EBRwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 13:52:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH, RFC 16/22] USB: UHCI: clarify Kconfig dependencies
Date: Thu, 2 May 2013 19:52:34 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
References: <Pine.LNX.4.44L0.1305021304500.1436-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1305021304500.1436-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201305021952.35040.arnd@arndb.de>
X-Provags-ID: V02:K0:wtSPnFGtI0bhDSXGRvrYA7ga/KZQwyz+NGi1sxkRn4P
 V9qNBGrvlnUBQMdXohLWDSttGv1cdsi4Oa8OiIDQKCUXL/WXbe
 x8lHk5QVczAN6W8NVudWVYK1SMMYjKErzU9DnFE2hRhjsNnuDw
 /XsiHzdWphgr46FGqAJOjsOHMCPRq1k5kYJeTBHIaYQmNGMrmx
 Ikz6vUXFwtQgS84LU9QGqu0rAPvnDjM3OXPQ71vwVBAiAQun1u
 hZ1oW3CR97ANsUVRHMLlCbjy0mPxDjI1aAih00//Ik6vjkWAyp
 wnwcrqk+h1iu4B3J3fntxJD5d4FCQC6ZFQvFVBrElhiAdtVPi2
 /AGmn+d9tYri9t+OCsEc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 May 2013, Alan Stern wrote:
> On Thu, 2 May 2013, Arnd Bergmann wrote:
> 
> 	It relies more on "depends" than "select".  I don't know how 
> 	important this is in the end.

'select' is sometimes problematic, but the only use that I try to
avoid is having one Kconfig symbol that is both user-selectable
standalone and selected by something else.

> 	It doesn't add a new USB_UHCI_GRLIB symbol; instead it uses
> 	SPARC_LEON in several places.  I tend to think the new symbol
> 	is nicer.
> 
> 	It doesn't add a new USB_UHCI_PCI symbol.
> 
> 	It improves the dependency list for USB_UHCI_HCD.
> 
> 	It removes the help text for USB_UHCI_PLATFORM, thereby making
> 	that symbol not user-configurable.  I don't see any reason why
> 	the user should need to worry about this -- the choice should
> 	be a very simple one: build UHCI support or don't build it.  If
> 	the user chooses to build it then it should include support for
> 	all the compatible bus glues.  (This last decision may need to 
> 	be changed if more bus glues get added.)
>
> What do you think of my patch as compared to yours? 

I think in the end it comes down to the question where you want to
head with your driver. The way I did my version was going towards
making it similar to EHCI, with stand-alone bus glue drivers
and a core that is just a library module but does not register
a device_driver by itself.

Given that there are just three bus glues from UHCI, and at most
two of them enabled at the same time, I don't see a direct need
for UHCI to go down the same route as EHCI. If you want to just
leave this driver alone, your patch is simpler and has the same
effect in the end. Otherwise I think my patch avoids changing it
all again once the driver gets reworked.

Things might also get a little messy if we are seeing a lot
of other platforms beside VIA VT8500 use UHCI, but I think that
is rather unlikely.

	Arnd
