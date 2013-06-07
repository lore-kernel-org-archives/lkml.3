Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289Ab3FGSuD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 14:50:03 -0400
Received: from 1wt.eu ([62.212.114.60]:36206 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757165Ab3FGSt5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 14:49:57 -0400
Date: Fri, 7 Jun 2013 20:49:48 +0200
From: Willy Tarreau <w@1wt.eu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Lotfi Manseur <lotfi.manseur@gmail.com>, stable@vger.kernel.org,
        Wojciech M Zabolotny <W.Zabolotny@elka.pw.edu.pl>,
        Nicolas Palix <nicolas.palix@imag.fr>,
        Lotfi Manseur <lotfi.manseur@imag.fr>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: serial/ftdi_sio.c Fix kernel oops
Message-ID: <20130607184948.GO19006@1wt.eu>
References: <1370610872-1309-1-git-send-email-lotfi.manseur@imag.fr> <20130607173009.GC29371@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130607173009.GC29371@kroah.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 10:30:09AM -0700, Greg Kroah-Hartman wrote:
> On Fri, Jun 07, 2013 at 03:14:32PM +0200, Lotfi Manseur wrote:
> > Handle null termios in ftdi_set_termios(), introduced in
> > commit 552f6bf1bb0eda0011c0525dd587aa9e7ba5b846
> > This has been corrected in the mainline by
> > commits c515598e0f5769916c31c00392cc2bfe6af74e55 and
> > a816e3113b63753c330ca4751ea1d208e93e3015.
> 
> Then why shouldn't we just include those commit instead of your patch,
> which looks much different from these?
> 
> I'd much rather take the originals, not something else.

Indeed. I've checked, and the second commit was just cosmetic (silence
a warning reported by sparse for ptr == 0 introduced in the first one).

The context is minimally different (original commit introduces a jump
to a label whose context has changed). I tend to think that the merged
fix has less changes of being incorrectly applied, but given their
triviality we could very well merge the original ones instead, and
keep initial authorship BTW.

Willy

