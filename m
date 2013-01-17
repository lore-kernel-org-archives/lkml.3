Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737Ab3AQU4Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 15:56:25 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:39572 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814Ab3AQU4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 15:56:22 -0500
Subject: Re: LIO - the broken iSCSI target implementation
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Andreas Steinmetz <ast@domdv.de>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org,
        torvalds@linux-foundation.org,
        target-devel <target-devel@vger.kernel.org>
In-Reply-To: <1358385543.7040.54.camel@host028-server-9.lan.domdv.de>
References: <1358385543.7040.54.camel@host028-server-9.lan.domdv.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Jan 2013 12:56:19 -0800
Message-ID: <1358456179.18551.34.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andreas,

On Thu, 2013-01-17 at 02:19 +0100, Andreas Steinmetz wrote:
> This is not a technical point of view. This is a more or less political
> and user point of view. And for any replies, I'm not subscribed (haven't
> been now for years).
> 
> As a user, I was in need for an iSCSI target. Actually, I needed to
> export a SAS tape device (Ultrium 5) - which is one of the devices still
> sufficiently expensive to go the iSCSI target way) - well, not any disks
> (cheap enough, NFS available) or CD/DVD writers (I'd call these penny
> targets nowadays).
> 
> Thus, lio (http://www.linux-iscsi.org/) seemed to be the politically and
> technically favoured solution. Except: it simply doesn't work, userspace
> utilities are seemingly not maintained,

I'm not sure what you mean.  There are targetcli+rtslib packages are
available for virtually every distribution

http://www.linux-iscsi.org/wiki/Targetcli#Linux_distributions

>  the web site is - simply put -
> sales talk and when one tries to write manually to configfs the results
> are kernel panics.

Then your hitting a bug with pSCSI export with TYPE_TAPE.  That's what
your trying to do right..?

> 
> A little bit more detail:
> 
> Oh, well, maybe I do expect too much when a certain commercial
> institution calls LIO "the standard open-source storage Target". Maybe
> one should not expect typical hardware to be supported except, maybe,
> when a commercial contract exists...
> 
> Though the only chance to get the LIO target working for me was to try
> to write hopefully proper values to configfs manually. Without any
> usable documentation, that is. The result was: kernel panics (@hch:
> don't ask me how to repeat - hire some apes hacking at LIO configfs,
> that's whats required, apes need no documentation, either).
> 

The full API reference for rtslib is available here:

http://www.risingtidesystems.com/doc/rtslib-gpl/html/

As for targetcli, you'll want to use the in-line documenation available
within the shell.

http://www.linux-iscsi.org/wiki/Targetcli#Display_helphttp://www.linux-iscsi.org/wiki/Targetcli#Display_help

> The fun part of it was that I finally ended up using SCST - which was
> refrained from kernel inclusion for technical reasons beyond my
> knowledge. What makes me prefer SCST is quite simple:
> 
> It works, it is sufficiently documented and it is maintained. And, @hch:
> Beautiful in kernel code first needs to work without producing kernel
> panics (3.7.x) and it needs to be accompanied by working and
> sufficiently documented user space utilities or, it needs to have a well
> documented API (documentation needs to include a variety of examples,
> not the old IBM way of simply documenting every flag without any
> overview).
> 
> As long as LIO userspace is a not maintained and instead seemingly a
> sales playground and as long as LIO kernel code causes panics by simple
> writes to configfs LIO seems to me worse than any alpha quality code. It
> is simply useless.
> 

Of course LIO userspace is maintained.  If you find a bug, please report
it to us so it can be addressed.  Otherwise, I'm not sure what you
expect to achieve by simply hand-waving.

--nab

