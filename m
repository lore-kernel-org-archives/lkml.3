Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937025Ab3DJW3u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 18:29:50 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:53766 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933050Ab3DJW3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:29:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [char-misc-next 1/3] mei: nfc: Initial nfc implementation
Date: Thu, 11 Apr 2013 00:29:38 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Tomas Winkler <tomas.winkler@intel.com>, linux-kernel@vger.kernel.org
References: <1365464495-17642-1-git-send-email-tomas.winkler@intel.com> <20130410200312.GC5681@kroah.com> <20130410211513.GJ4874@zurbaran>
In-Reply-To: <20130410211513.GJ4874@zurbaran>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304110029.38938.arnd@arndb.de>
X-Provags-ID: V02:K0:7Jah2eUSAMpyp1iWNJMUp4LWOsexetsZMW1i+Az7Sy3
 39cOB0MrkY7M7vqYt5bB88NrPUjzQkBC7Q9zAJTNul9K7NDDKF
 sxBPvFy6zL/MhZ6mjn6ciaekT1doBFxOvs1TC66aJnJ/ktCvHX
 xScjyj8G9fPDwPpCqPTg0PgcyyeArjbqP1GVNJqo98NgXfDF25
 aTPkvGkBdPYOKwdU/n9IAwN69dhgoAlFxJdPIlU+oCV3m1XuhC
 jXFYXHMKsbiPITveQE2xzQbNqyyihW77ruCgeaWQSegZhm1OXR
 XyJoZ3omUmPaAyfqVvJ7WB/zikLmgrWaJlimYAEJ2gIKUiOpbC
 PPc6LOV/57YHbuivnqnA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 April 2013, Samuel Ortiz wrote:
> > > That works fine with the typical case where your pn544 is directly accessible
> > > through i2c. But if it's sitting behind the ME, you will need to send
> > > commands exported through this file to fetch the vendor and radio IDs, but
> > > also to send those HCI frames that the vanilla Android stack builds after
> > > encapsulating them into a struct mei_nfc_cmd. And this is all done through the
> > > /dev/mei interface.
> > 
> > No NFC data should be going through /dev/mei, use the proper kernel apis
> > please.
> Not my choice, I'm sorry. And I'm not the one who's going to implement the
> adaptation layer for the Android stack to properly work over /dev/mei, other
> folks at Intel will.
> If an Android OEM decides he wants a pn544 NFC chipset behind an x86 ME, then
> NFC data will go through /dev/mei. I don't like it, but this is a business
> decision I have no control over.

Welcome to the crap that we have to deal with on ARM all the time. Seriously,
you may not be able to stop people from doing something stupid, but you
should not pave their way. Exporting a header file to user space, when the
only possible use of that header is to do the wrong thing helps nobody.

If someone seriously wants to use /dev/mei in that way, they can easily
provide the header file themselves, or patch the kernel in any way necessary.

	Arnd
