Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933039AbaLBVPW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 16:15:22 -0500
Received: from tex.lwn.net ([70.33.254.29]:33318 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932707AbaLBVPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 16:15:21 -0500
Date: Tue, 2 Dec 2014 16:15:19 -0500
From: Jonathan Corbet <corbet@lwn.net>
To: Srikanth Thokala <sriku.linux@gmail.com>
Cc: linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Documentation: memory-barriers: Fix typo in the first
 example
Message-ID: <20141202161519.581ea1af@lwn.net>
In-Reply-To: <CA+mB=1+4=eG6d-99+yZ6HgpqvU2uan+-13pXt1=H+GZ0HeRL1A@mail.gmail.com>
References: <1416285598-6630-1-git-send-email-sriku.linux@gmail.com>
	<CA+mB=1+4=eG6d-99+yZ6HgpqvU2uan+-13pXt1=H+GZ0HeRL1A@mail.gmail.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Nov 2014 12:19:26 +0530
Srikanth Thokala <sriku.linux@gmail.com> wrote:

> Hi,
> 
> Kindly review the patch.

To me it looks right.  Something like this, though, needs an ack from
Paul (cc'd) before I can be really confident.  Paul...?

jon

> Thanks
> Srikanth
> 
> On Tue, Nov 18, 2014 at 10:09 AM, Srikanth Thokala
> <sriku.linux@gmail.com> wrote:
> > In the first example, the loads into 'x' and 'y' on CPU 2 doesn't
> > match the sequence of events described below it.  To match the
> > sequence of events, the values of 'A' and 'B' should be loaded
> > into 'x' and 'y' respectively.
> >
> > Signed-off-by: Srikanth Thokala <sriku.linux@gmail.com>
> > ---
> >  Documentation/memory-barriers.txt | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
> > index 22a969c..2770bce 100644
> > --- a/Documentation/memory-barriers.txt
> > +++ b/Documentation/memory-barriers.txt
> > @@ -115,8 +115,8 @@ For example, consider the following sequence of events:
> >         CPU 1           CPU 2
> >         =============== ===============
> >         { A == 1; B == 2 }
> > -       A = 3;          x = B;
> > -       B = 4;          y = A;
> > +       A = 3;          x = A;
> > +       B = 4;          y = B;
> >
> >  The set of accesses as seen by the memory system in the middle can be arranged
> >  in 24 different combinations:
> > --
> > 1.9.1
> >
> 
