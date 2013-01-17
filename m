Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928Ab3AQVVr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 16:21:47 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:56953 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033Ab3AQVVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 16:21:46 -0500
Subject: Re: LIO - the broken iSCSI target implementation
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Andreas Steinmetz <ast@domdv.de>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org,
        torvalds@linux-foundation.org,
        target-devel <target-devel@vger.kernel.org>
In-Reply-To: <1358456179.18551.34.camel@haakon2.linux-iscsi.org>
References: <1358385543.7040.54.camel@host028-server-9.lan.domdv.de>
	 <1358456179.18551.34.camel@haakon2.linux-iscsi.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Jan 2013 13:21:43 -0800
Message-ID: <1358457703.18551.68.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-17 at 12:56 -0800, Nicholas A. Bellinger wrote:
> Hi Andreas,
> 
> On Thu, 2013-01-17 at 02:19 +0100, Andreas Steinmetz wrote:
> > This is not a technical point of view. This is a more or less political
> > and user point of view. And for any replies, I'm not subscribed (haven't
> > been now for years).
> > 
> > As a user, I was in need for an iSCSI target. Actually, I needed to
> > export a SAS tape device (Ultrium 5) - which is one of the devices still
> > sufficiently expensive to go the iSCSI target way) - well, not any disks
> > (cheap enough, NFS available) or CD/DVD writers (I'd call these penny
> > targets nowadays).
> > 
> > Thus, lio (http://www.linux-iscsi.org/) seemed to be the politically and
> > technically favoured solution. Except: it simply doesn't work, userspace
> > utilities are seemingly not maintained,
> 
> I'm not sure what you mean.  There are targetcli+rtslib packages are
> available for virtually every distribution
> 
> http://www.linux-iscsi.org/wiki/Targetcli#Linux_distributions
> 
> >  the web site is - simply put -
> > sales talk and when one tries to write manually to configfs the results
> > are kernel panics.
> 
> Then your hitting a bug with pSCSI export with TYPE_TAPE.  That's what
> your trying to do right..?
> 
> > 
> > A little bit more detail:
> > 
> > Oh, well, maybe I do expect too much when a certain commercial
> > institution calls LIO "the standard open-source storage Target". Maybe
> > one should not expect typical hardware to be supported except, maybe,
> > when a commercial contract exists...
> > 
> > Though the only chance to get the LIO target working for me was to try
> > to write hopefully proper values to configfs manually. Without any
> > usable documentation, that is. The result was: kernel panics (@hch:
> > don't ask me how to repeat - hire some apes hacking at LIO configfs,
> > that's whats required, apes need no documentation, either).
> > 
> 
> The full API reference for rtslib is available here:
> 
> http://www.risingtidesystems.com/doc/rtslib-gpl/html/
> 
> As for targetcli, you'll want to use the in-line documenation available
> within the shell.
> 
> http://www.linux-iscsi.org/wiki/Targetcli#Display_helphttp://www.linux-iscsi.org/wiki/Targetcli#Display_help

Also, as listed under:

http://www.linux-iscsi.org/wiki/Targetcli#Quick_start_guide

The community documentation for rtsadmin/targetcli is available in the
RTS-OS Admin manual here:

http://www.risingtidesystems.com/doc/RTS%20OS%20Admin%20Manual%20CE.pdf

The sections of interest for the end-user shell are:

5. RTSadmin Quick Start Guide 
6. RTSadmin Concepts
7. RTSadmin Commands
8. RTSadmin Contexts
9. RTSadmin Examples

Again, if you've come across a bug with pSCSI + TYPE_TAPE export, please
let us know.

