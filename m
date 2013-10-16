Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760502Ab3JPJQ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 05:16:56 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:36951 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760180Ab3JPJQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 05:16:53 -0400
Date: Wed, 16 Oct 2013 10:16:48 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Peter Jones <pjones@redhat.com>
Subject: Re: [PATCH] x86/efi: Add EFI framebuffer earlyprintk support
Message-ID: <20131016091648.GD10834@console-pimps.org>
References: <1381423261-30566-1-git-send-email-matt@console-pimps.org>
 <20131010172844.GA26430@gmail.com>
 <20131011140039.GF12321@console-pimps.org>
 <20131012174934.GA18849@gmail.com>
 <525B06CB.6090602@zytor.com>
 <20131014075726.GB20435@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131014075726.GB20435@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Oct, at 09:57:26AM, Ingo Molnar wrote:
> 
> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
> > On 10/12/2013 10:49 AM, Ingo Molnar wrote:
> > > 
> > >>>> +static void early_efi_write_char(void *dst, char c, int h)
> > >>>> +{
> > >>>> +	const u8 *src;
> > >>>> +	u32 fgcolor = 0xaaaaaa;
> > >>>
> > >>> That's RGB grey, right? Why not 0xffffff for a very visible white?
> > >>  
> > >> The VGA earlyprintk code uses the equivalent grey, AFAIK, which is why I 
> > >> picked this value.
> > > 
> > > The VGA code should be changed to white too I suspect ;-)
> > > 
> > 
> > For compatibility with the classical text console we use light grey as 
> > the default color and a double-stroked font (which was necessary on the 
> > CGA display since it didn't have enough bandwidth to handle 
> > single-stroked fonts well).  The problem with changing that to white is 
> > that you end up with a mismatch between the earlyprintk console and the 
> > "real" console, *or* we change the behavior of everyone's consoles...
> 
> Btw., I have no problem at all with making the early console look separate 
> and making it clear when we switch to the 'real' console.
> 
> earlyprintk is a debug method, and more information can only be good. 

Have we reached a consensus here? I've no strong opinion either way on
the colour of the text.

-- 
Matt Fleming, Intel Open Source Technology Center
