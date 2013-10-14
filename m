Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650Ab3JNH5c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 03:57:32 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:33049 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389Ab3JNH5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 03:57:31 -0400
Date: Mon, 14 Oct 2013 09:57:26 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matt Fleming <matt@console-pimps.org>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Peter Jones <pjones@redhat.com>
Subject: Re: [PATCH] x86/efi: Add EFI framebuffer earlyprintk support
Message-ID: <20131014075726.GB20435@gmail.com>
References: <1381423261-30566-1-git-send-email-matt@console-pimps.org>
 <20131010172844.GA26430@gmail.com>
 <20131011140039.GF12321@console-pimps.org>
 <20131012174934.GA18849@gmail.com>
 <525B06CB.6090602@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <525B06CB.6090602@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 10/12/2013 10:49 AM, Ingo Molnar wrote:
> > 
> >>>> +static void early_efi_write_char(void *dst, char c, int h)
> >>>> +{
> >>>> +	const u8 *src;
> >>>> +	u32 fgcolor = 0xaaaaaa;
> >>>
> >>> That's RGB grey, right? Why not 0xffffff for a very visible white?
> >>  
> >> The VGA earlyprintk code uses the equivalent grey, AFAIK, which is why I 
> >> picked this value.
> > 
> > The VGA code should be changed to white too I suspect ;-)
> > 
> 
> For compatibility with the classical text console we use light grey as 
> the default color and a double-stroked font (which was necessary on the 
> CGA display since it didn't have enough bandwidth to handle 
> single-stroked fonts well).  The problem with changing that to white is 
> that you end up with a mismatch between the earlyprintk console and the 
> "real" console, *or* we change the behavior of everyone's consoles...

Btw., I have no problem at all with making the early console look separate 
and making it clear when we switch to the 'real' console.

earlyprintk is a debug method, and more information can only be good. 

Thanks,

	Ingo
