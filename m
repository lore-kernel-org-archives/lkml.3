Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496AbaEEExL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 00:53:11 -0400
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:62294 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750882AbaEEExJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 00:53:09 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: At8WAHsYZ1NXQyvn/2dsb2JhbABZgwarTQEBAQEBAQUBmgYCAoEWF3SCJQEBBAE6HCMFCwgDDgouOR4GE4g5DAHKOheFVoh8B4Q/AQOPGooZAYp+h3aDNjs
Date: Mon, 5 May 2014 06:53:01 +0200
From: Fabian Frederick <fabf@skynet.be>
To: Jeff Layton <jlayton@poochiereds.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>, Steve French <sfrench@samba.org>,
        linux-cifs <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH 1/1] FS/CIFS: remove obsolete __constant
Message-Id: <20140505065301.bbb1fe3e579d27dacd3292c9@skynet.be>
In-Reply-To: <CAOhYWNJ5JRt9KH-Z3K_zBW2axs5c5KJQYXb8_vYLQTEdr=ZeEg@mail.gmail.com>
References: <20140503221539.e4857ef93d6c875bbded5938@skynet.be>
	<CAOhYWNJ5JRt9KH-Z3K_zBW2axs5c5KJQYXb8_vYLQTEdr=ZeEg@mail.gmail.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 May 2014 18:52:43 -0400
Jeff Layton <jlayton@poochiereds.net> wrote:

> On Sat, May 3, 2014 at 4:15 PM, Fabian Frederick <fabf@skynet.be> wrote:
> > Replacing all __constant_foo to foo()
> > except in smb2status.h (1700 lines to update).
> >
> > Cc: linux-cifs@vger.kernel.org
> > Cc: Steve French <sfrench@samba.org>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Fabian Frederick <fabf@skynet.be>
> > ---
> >  fs/cifs/cifsacl.c  |  2 +-
> >  fs/cifs/cifssmb.c  | 20 ++++++++++----------
> >  fs/cifs/sess.c     |  2 +-
> >  fs/cifs/smb2misc.c | 38 +++++++++++++++++++-------------------
> >  fs/cifs/smb2ops.c  |  2 +-
> >  fs/cifs/smb2pdu.c  |  2 +-
> >  fs/cifs/smb2pdu.h  | 28 ++++++++++++++--------------
> >  7 files changed, 47 insertions(+), 47 deletions(-)
> >
> > diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
> > index 7ff866d..54ac0e8 100644
> > --- a/fs/cifs/cifsacl.c
> > +++ b/fs/cifs/cifsacl.c
> > @@ -38,7 +38,7 @@ static const struct cifs_sid sid_everyone = {
> >         1, 1, {0, 0, 0, 0, 0, 1}, {0} };
> >  /* security id for Authenticated Users system group */
> >  static const struct cifs_sid sid_authusers = {
> > -       1, 1, {0, 0, 0, 0, 0, 5}, {__constant_cpu_to_le32(11)} };
> > +       1, 1, {0, 0, 0, 0, 0, 5}, {cpu_to_le32(11)} };
> 
> 
> Does the build still work on BE arches with this? I know at one point
> the above wouldn't compile on those
> arches. See commit 536abdb0802f, for an explanation.

Untested on BE but it would mean checkpatch 
"don't use __constant<foo> functions outside of include/uapi/" stuff is wrong ?
