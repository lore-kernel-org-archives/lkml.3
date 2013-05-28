Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964967Ab3E1SJr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 14:09:47 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:38029 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964871Ab3E1SJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 14:09:46 -0400
Date: Tue, 28 May 2013 13:09:42 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH] 9p: trace: use %*ph to dump buffer
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
        Eric Van Hensbergen <ericvh@gmail.com>
In-Reply-To: <1369730992.29283.224.camel@smile> (from
	andriy.shevchenko@linux.intel.com on Tue May 28 03:49:52 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1369764582.2776.40@driftwood>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-ugmQAijy1P1H5cceKiXm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-ugmQAijy1P1H5cceKiXm
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 05/28/2013 03:49:52 AM, Andy Shevchenko wrote:
> On Mon, 2013-04-22 at 16:01 +0300, Andy Shevchenko wrote:
> > Additionally change cast from long to unsigned long to follow =20
> specificator.
> >
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > ---
> >  include/trace/events/9p.h | 28 +++-------------------------
> >  1 file changed, 3 insertions(+), 25 deletions(-)
> >
> > diff --git a/include/trace/events/9p.h b/include/trace/events/9p.h
> > index beeaed8..a066636 100644
> > --- a/include/trace/events/9p.h
> > +++ b/include/trace/events/9p.h
> > @@ -143,31 +143,9 @@ TRACE_EVENT(9p_protocol_dump,
> >  		    __entry->tag    =3D  pdu->tag;
> >  		    memcpy(__entry->line, pdu->sdata, P9_PROTO_DUMP_SZ);
> >  		    ),
> > -	    TP_printk("clnt %lu %s(tag =3D %d)\n%.3x: "
> > -		      "%02x %02x %02x %02x %02x %02x %02x %02x "
> > -		      "%02x %02x %02x %02x %02x %02x %02x %02x\n"
> > -		      "%.3x: "
> > -		      "%02x %02x %02x %02x %02x %02x %02x %02x "
> > -		      "%02x %02x %02x %02x %02x %02x %02x %02x\n",
> > -		      (long)__entry->clnt, show_9p_op(__entry->type),
> > -		      __entry->tag, 0,
> > -		      __entry->line[0],  __entry->line[1],
> > -		      __entry->line[2],  __entry->line[3],
> > -		      __entry->line[4],  __entry->line[5],
> > -		      __entry->line[6],  __entry->line[7],
> > -		      __entry->line[8],  __entry->line[9],
> > -		      __entry->line[10], __entry->line[11],
> > -		      __entry->line[12], __entry->line[13],
> > -		      __entry->line[14], __entry->line[15],
> > -		      16,
> > -		      __entry->line[16], __entry->line[17],
> > -		      __entry->line[18], __entry->line[19],
> > -		      __entry->line[20], __entry->line[21],
> > -		      __entry->line[22], __entry->line[23],
> > -		      __entry->line[24], __entry->line[25],
> > -		      __entry->line[26], __entry->line[27],
> > -		      __entry->line[28], __entry->line[29],
> > -		      __entry->line[30], __entry->line[31])
> > +	    TP_printk("clnt %lu %s(tag =3D %d)\n%.3x: %16ph\n%.3x: =20
> %16ph\n",
> > +		      (unsigned long)__entry->clnt, =20
> show_9p_op(__entry->type),
> > +		      __entry->tag, 0, __entry->line, 16, __entry->line =20
> + 16)
> >   );
> >
> >  #endif /* _TRACE_9P_H */
>=20
> Any comment on this one, anyone?

While we're at it, here's a patch adding the rest of the 9p files to =20
the maintainers entry, in hopes that Erich and the list get pinged on =20
this stuff in future.

Rob=

--=-ugmQAijy1P1H5cceKiXm
Content-Type: text/x-patch; charset=us-ascii; name=9p.patch
Content-Disposition: attachment; filename=9p.patch

Add rest of the 9p files to the maintainers entry.

 MAINTAINERS |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index fd3a495..386fafa 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -180,6 +180,11 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs.git
 S:	Maintained
 F:	Documentation/filesystems/9p.txt
 F:	fs/9p/
+F:	net/9p/
+F:	include/net/9p/
+F:	include/uapi/linux/virtio_9p.h
+F:	include/trace/events/9p.h
+
 
 A8293 MEDIA DRIVER
 M:	Antti Palosaari <crope@iki.fi>

--=-ugmQAijy1P1H5cceKiXm--
