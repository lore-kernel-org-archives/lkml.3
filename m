Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937674Ab3DJWwP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 18:52:15 -0400
Received: from mga11.intel.com ([192.55.52.93]:58930 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937417Ab3DJWwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:52:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,450,1363158000"; 
   d="scan'208";a="320558745"
Date: Thu, 11 Apr 2013 00:52:05 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Tomas Winkler <tomas.winkler@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [char-misc-next 1/3] mei: nfc: Initial nfc implementation
Message-ID: <20130410225205.GN4874@zurbaran>
References: <1365464495-17642-1-git-send-email-tomas.winkler@intel.com>
 <20130410200312.GC5681@kroah.com>
 <20130410211513.GJ4874@zurbaran>
 <201304110029.38938.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201304110029.38938.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Thu, Apr 11, 2013 at 12:29:38AM +0200, Arnd Bergmann wrote:
> On Wednesday 10 April 2013, Samuel Ortiz wrote:
> > > > That works fine with the typical case where your pn544 is directly accessible
> > > > through i2c. But if it's sitting behind the ME, you will need to send
> > > > commands exported through this file to fetch the vendor and radio IDs, but
> > > > also to send those HCI frames that the vanilla Android stack builds after
> > > > encapsulating them into a struct mei_nfc_cmd. And this is all done through the
> > > > /dev/mei interface.
> > > 
> > > No NFC data should be going through /dev/mei, use the proper kernel apis
> > > please.
> > Not my choice, I'm sorry. And I'm not the one who's going to implement the
> > adaptation layer for the Android stack to properly work over /dev/mei, other
> > folks at Intel will.
> > If an Android OEM decides he wants a pn544 NFC chipset behind an x86 ME, then
> > NFC data will go through /dev/mei. I don't like it, but this is a business
> > decision I have no control over.
> 
> Welcome to the crap that we have to deal with on ARM all the time. Seriously,
> you may not be able to stop people from doing something stupid, but you
> should not pave their way. Exporting a header file to user space, when the
> only possible use of that header is to do the wrong thing helps nobody.
Although I'm pretty sure the reasons for Android not to use the kernel NFC APIs
and stack are all but technical ones, I agree with your statement here.


> If someone seriously wants to use /dev/mei in that way, they can easily
> provide the header file themselves, or patch the kernel in any way necessary.
I'm fine with moving nfc.h back to drivers/misc/mei/

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
