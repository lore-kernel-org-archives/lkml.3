Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564Ab3FMOvg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 10:51:36 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:57050 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978Ab3FMOvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 10:51:35 -0400
Date: Thu, 13 Jun 2013 16:51:33 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, David Howells <dhowells@redhat.com>,
        Orion Poplawski <orion@cora.nwra.com>
Subject: Re: Strange intermittent EIO error when writing to stdout since
 v3.8.0
Message-ID: <20130613145133.GC519@x4>
References: <20130606115417.GA520@x4>
 <51B09A26.3080603@hurleysoftware.com>
 <20130606143750.GB520@x4>
 <51B1FEB1.8040103@hurleysoftware.com>
 <20914.9444.867518.719403@pilspetsen.it.uu.se>
 <20130613103950.GB519@x4>
 <51B9D43D.6000008@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51B9D43D.6000008@hurleysoftware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013.06.13 at 10:16 -0400, Peter Hurley wrote:
> On 06/13/2013 06:39 AM, Markus Trippelsdorf wrote:
> > On 2013.06.07 at 20:22 +0200, Mikael Pettersson wrote:
> >> Peter Hurley writes:
> >>   > Based on the other reports from Mikael and David, I suspect this problem
> >>   > may have to do with my commit 699390354da6c258b65bf8fa79cfd5feaede50b6:
> >>   >
> >>   >    pty: Ignore slave pty close() if never successfully opened
> >>   >
> >>   > This commit poisons the pty under certain error conditions that may
> >>   > occur from parallel open()s (or parallel close() with pending write()).
> >>   >
> >>   > It's unclear to me which error condition is triggered and how user-space
> >>   > got an open file descriptor but that seems the most likely. Is the problem
> >>   > reproducible enough that a debug patch would likely trigger?
> >>
> >> In my case the problem occurred frequently enough that I've been forced
> >> to change my build procedures to avoid it.  I'd welcome a debug patch.
> >
> > Since apparently no debugging patch is forthcoming, maybe it's time to
> > test the simple revert of commit 699390354da.
> 
> I apologize for the delay.
> 
> Here's a debug patch which I hope will narrow down the circumstances of
> this error condition.

Unfortunately it doesn't apply:

markus@x4 linux % git describe
v3.10-rc5-167-g26e0446
markus@x4 linux % patch -p1 --dry-run < /home/markus/tty.patch
checking file drivers/tty/pty.c
Hunk #1 succeeded at 25 with fuzz 2.
Hunk #2 FAILED at 256.
1 out of 2 hunks FAILED
checking file drivers/tty/tty_io.c
Hunk #1 FAILED at 105.
Hunk #2 FAILED at 424.
Hunk #3 FAILED at 448.
Hunk #4 FAILED at 1020.
Hunk #5 FAILED at 1197.
5 out of 5 hunks FAILED

-- 
Markus
