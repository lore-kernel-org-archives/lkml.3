Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396AbaDOPCY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 11:02:24 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:44923 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbaDOPCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 11:02:23 -0400
Date: Tue, 15 Apr 2014 16:02:13 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Emmanuel Colbus <ecolbus@manux.info>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][3/11][MANUX] Kernel compatibility : syscall numbers
Message-ID: <20140415160213.490439ea@alan.etchedpixels.co.uk>
In-Reply-To: <534D375B.9070806@manux.info>
References: <534D375B.9070806@manux.info>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Apr 2014 15:42:51 +0200
Emmanuel Colbus <ecolbus@manux.info> wrote:

> Continuing the discussion regarding syscalls, I have a question
> regarding vector 0x80.
> 
> As I mentionned earlier, my OS's internals are very different from
> Linux's, thus I have had a need for a few new syscalls. Since I wanted
> to avoid any collision with Linux, but I also wanted to keep the
> ability to put the syscall table in a single 4096-byte page on 64-bit
> computers (on which I hope to run one day), I chose to start taking
> syscall number 511, and to progress downwards - currently, I'm using
> numbers 511 through 501 included (with a hole at 503, but I'll likely
> fill it again in the future).
> 
> Is this okay for you? And in this case, if this isn't asking too much,
> could you avoid using them for now, to avoid any conflict?

I don't see why the question arises. Your non Linux ABI binaries will be
the ones to use such calls. They can have a different ELF header to Linux
binaries. Linux then won't even try and run them by mistake. At that
point your worst case is Linux calls eventually collide with your own and
you have two tables according to ABI.

Alan
