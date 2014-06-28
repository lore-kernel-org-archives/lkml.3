Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751704AbaF1Rgu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 13:36:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52677 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbaF1Rgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:36:48 -0400
Date: Sat, 28 Jun 2014 13:36:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Kiran Kankipati <kiran.kankipati@gmail.com>
Cc: "Don A. Bailey" <donb@securitymouse.com>, linux-kernel@vger.kernel.org
Subject: Re: Bug in Kernel's LZ4-HC in 64bit (kernel crypto library)
Message-ID: <20140628173636.GA6664@kroah.com>
References: <CALWnrFRO_trdJ7aL_vaWtFbdJgxRkt4+zROR_chQFNPz7v3BVQ@mail.gmail.com>
 <20140628160020.GA11019@kroah.com>
 <CALWnrFRQ_VHzPtBe04n3xfeQu=kjw=TE+wotzyoTW5P6gdZ-zQ@mail.gmail.com>
 <20140628162009.GA13161@kroah.com>
 <CALWnrFQJX2JBssSQ-CdYbcewjbTna=xKS4GRmJ4fHaactwERmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALWnrFQJX2JBssSQ-CdYbcewjbTna=xKS4GRmJ4fHaactwERmg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 28, 2014 at 10:02:19PM +0530, Kiran Kankipati wrote:
> I don't understand, are you having problems on the compress side, or the
> decompress side?  Where in the lz4 is a bug happening?
> >> Sorry sorry.
> I dont have a clue. Well the reason is, if compress is happening well and
> decomp is getting this issue. Then decomp is having a bug.
> If compression is corrupting data, then decomp may get this issue too. Hence I
> am not fully sure.
> But the error code happening in the decomp API.
> 
> 
> Do you have a data stream that I can use to run it through the lz4 code
> to see where the problem is in the compress/decompress code?
> >> Again sorry about it. Since  iam testing with real-time packets. I dont have
> it Greg.
> 
> I can copypaste the error logs of my TrafficSqueezer per-packet tests. Since  I
> am running a simulation test, I am doing each packet
> compression + decompression. This way I can test TrafficSqueezer stack. As well
> in our case we can test LZ4 too.
> 
> Kindly refer screenshot:
> 
> But please note, sometimes it works fine too. Sometimes I am getting this error
> :(
> 
> Its purely LZ4-HC error. Since the return code of
> lz4_decompress_unknownoutputsize() API is <0 i.e error !

As you are compressing and then decompressing, this doesn't look to be
the same "type" of error we have fixed recently, so I don't know what to
do here.

If you find a data stream that this can be tested with, please let me
know and I'll be glad to try it out.  Until then, I need more of a hint
as to the problem before I can do anything, sorry.

greg k-h
