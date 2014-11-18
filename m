Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932621AbaKRWmu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 17:42:50 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:34408 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932620AbaKRWmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 17:42:49 -0500
Date: Tue, 18 Nov 2014 14:42:44 -0800
From: josh@joshtriplett.org
To: Pieter Smith <pieter@boesman.nl>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 51/56] drivers/char/mem: support compiling out splice
Message-ID: <20141118224244.GA10089@cloud>
References: <1415913813-362-1-git-send-email-pieter@boesman.nl>
 <1415913813-362-52-git-send-email-pieter@boesman.nl>
 <20141113220911.GA546@kroah.com>
 <CAPho-_JJGy0cwBVfWKL1Gt9ZQZM+Odo7W05bKQ2JLO+TM-ABJA@mail.gmail.com>
 <20141113223150.GB30412@cloud>
 <20141113233416.GC7678@kroah.com>
 <20141114001948.GA30946@cloud>
 <20141114032722.GA31174@kroah.com>
 <CAPho-_KUc-+c=X6xtLTD2F-o4qi+YpYdnw6F1cx4kniezfs7aw@mail.gmail.com>
 <CAPho-_+ZXHYGB9-d19NR9u5tcOpN1Ytg80NZgvScF=YQ-6SdNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPho-_+ZXHYGB9-d19NR9u5tcOpN1Ytg80NZgvScF=YQ-6SdNA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 10:46:59PM +0100, Pieter Smith wrote:
> Turning all exported splice functions into static inline NOP's covers
> almost everything...
> fs/fuse and net/skbuf use an exported ops struct from fs/splice.c. Mocking
> out an exported ops struct seems way uglier than linking out the
> dependencies with a __splice_p() macro and __maybe_unused.
> 
> Any thoughts or suggestions?

You could make FUSE select SPLICE_SYSCALL.

For skbuff, what's the dependency?  Ideally NET shouldn't select
SPLICE_SYSCALL.  You might try compiling out *only* that particular
instance, and seeing how clean you can make that.

- Josh Triplett
