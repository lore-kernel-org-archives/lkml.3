Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529AbaILK0b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 06:26:31 -0400
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:45117 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbaILK0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 06:26:30 -0400
Date: Fri, 12 Sep 2014 11:26:19 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dave Airlie <airlied@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: vga and 64-bit memcpy's
Message-ID: <20140912112619.50d3b651@www.etchedpixels.co.uk>
In-Reply-To: <CAPM=9tyZF2S7PJcLyc=KH_NBFXju8UwvMBOF_MocNK8pPVXDYw@mail.gmail.com>
References: <CAPM=9tyZF2S7PJcLyc=KH_NBFXju8UwvMBOF_MocNK8pPVXDYw@mail.gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Sep 2014 13:57:20 +1000
Dave Airlie <airlied@gmail.com> wrote:

> Got an bug report from someone using a silicon motion video card in
> VGA mode about corruption that they tracked down to 64-bit memory
> operations not being supported by the video card, it appears that we
> probably shouldn't be using > 32-bit copies on VGA memory.

VGA memory is write combining usually so the answer in general would be
no. You may also find its a combination of bridge and card and one or the
other is somehow out of spec.
 
> The include/linux/vt_buffer.h defaults scr_memcpyw defaults to using
> memcpy, which on 64-bit x86 machines ends up as rep movsq. Is there
> any way to make this use a 32-bit memcpy instead?

Please don't - you'll reduce performance for everyone else with saner
video cards.

Alan
