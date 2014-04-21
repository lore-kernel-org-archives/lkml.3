Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214AbaDUREj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 13:04:39 -0400
Received: from elasmtp-scoter.atl.sa.earthlink.net ([209.86.89.67]:33493 "EHLO
	elasmtp-scoter.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751373AbaDUREe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 13:04:34 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=mindspring.com;
  b=MYNajLnkat3eNTRaTr6Ffn5a8kb6anvnpkTibKsbv7HHrvcqrJSe9sRlVXjZiWqu;
  h=Received:From:To:Cc:References:In-Reply-To:Subject:Date:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:X-Mailer:Thread-Index:Content-Language:X-Antivirus-Status:X-ELNK-Trace:X-Originating-IP;
From: "Frank Filz" <ffilzlnx@mindspring.com>
To: "'Christoph Hellwig'" <hch@infradead.org>,
        "'Michael Kerrisk \(man-pages\)'" <mtk.manpages@gmail.com>
Cc: "'Rich Felker'" <dalias@libc.org>,
        "'libc-alpha'" <libc-alpha@sourceware.org>,
        "'Jeff Layton'" <jlayton@redhat.com>,
        "'Carlos O'Donell'" <carlos@redhat.com>,
        <samba-technical@lists.samba.org>, <linux-kernel@vger.kernel.org>,
        "'Stefan \(metze\) Metzmacher'" <metze@samba.org>,
        <linux-fsdevel@vger.kernel.org>,
        "'Ganesha NFS List'" <nfs-ganesha-devel@lists.sourceforge.net>
References: <1398087935-14001-1-git-send-email-jlayton@redhat.com>	<20140421140246.GB26358@brightrain.aerifal.cx>	<535529FA.8070709@gmail.com> <20140421160927.GA19653@infradead.org>
In-Reply-To: <20140421160927.GA19653@infradead.org>
Subject: RE: [Nfs-ganesha-devel] [PATCH] locks: rename file-private locks to file-description locks
Date: Mon, 21 Apr 2014 10:03:33 -0700
Message-ID: <0e9701cf5d83$af0ff030$0d2fd090$@mindspring.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQGhXQr6VmqC09Ptl+VBODKb+XvaFwJqhFOOAbrSvasCHwqK1ptGKPHQ
Content-Language: en-us
X-Antivirus: avast! (VPS 140421-0, 04/21/2014), Outbound message
X-Antivirus-Status: Clean
X-ELNK-Trace: 136157f01908a8929c7f779228e2f6aeda0071232e20db4d4b76be2c88d2973008cfc8c4ac3dd6b1350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 71.236.153.111
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Apr 21, 2014 at 04:23:54PM +0200, Michael Kerrisk (man-pages)
> wrote:
> >
> > There's at least two problems to solve here:
> >
> > 1) "File private locks" is _meaningless_ as a term. Elsewhere
> >
> >
> (http://thread.gmane.org/gmane.network.samba.internals/76414/focus=16
> 8
> > 5376),
> 
> It's indeed not a very good choice, but the new name is even worse.
> Just call them non-broken locks? :)  Or not give them a name an just
append
> a 2 to the fcntls? :)

The folder name I've been archiving e-mails on this subject in is called
"good locks"...

I'd also be happy with "non-broken locks"...

I could also be happy with private locks (since in addition to resolving
broken POSIX behavior, they will ALSO allow user space servers to keep
separate sets of locks for each client lock owner - if I remember, the
addition of that capability prompted the private name).

:-)

> > 2) The new API constants (F_SETLKP, F_SETLKPW, F_GETLKP) have names
> >    that are visually very close to the traditional POSIX lock names
> >    (F_SETLK, F_SETLKW, F_GETLK). That's an accident waiting to happen
> >    when someone mistypes in code and/or misses such a misttyping
> >    when reading code. That really must be fixed.
> 
> I don't think so.  They also should have a name very similar because they
> have the same semantics with a major bug fixed.  In fact I can't think of
> anyone who would actually want the old behavior.

I'm nervous about such close names, but it's easy enough to use grep or
cscope to check a code base for typos in this case.

Frank


