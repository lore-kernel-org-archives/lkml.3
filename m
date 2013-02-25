Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161Ab3BYIuQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 03:50:16 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:36740 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757319Ab3BYIuO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 03:50:14 -0500
Date: Mon, 25 Feb 2013 09:50:18 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty vt: fix character insertion overflow
Message-ID: <20130225095018.387b165e@armhf>
In-Reply-To: <alpine.LFD.2.03.1302242001070.2213@syhkavp.arg>
References: <alpine.LFD.2.03.1302242001070.2213@syhkavp.arg>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; arm-unknown-linux-gnueabihf)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Feb 2013 20:06:09 -0500 (EST)
Nicolas Pitre <nicolas.pitre@linaro.org> wrote:

> Commit 81732c3b2f (tty vt: Fix line garbage in virtual console on
> command line edition) broke insert_char() in multiple ways.  Then
> commit b1a925f44a (tty vt: Fix a regression in command line edition)
> partially fixed it.  However, the buffer being moved is still too large
> and overflowing beyond the end of the current line, corrupting existing
> characters on the next line.

and

> One detail I didn't mention explicitly is that the cursor can be moved 
> to the last screen line, and then the sequence ESC [ <n> @ is all that 
> is needed to shovel 2*n bytes from that bottom screen line into adjacent 
> memory which could potentially be exploited in some way.

You are right, this bug is critical. Sorry.

Acked-by: Jean-François Moine <moinejf@free.fr>

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
