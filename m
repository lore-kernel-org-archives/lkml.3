Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337AbaEMWPs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 18:15:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55946 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687AbaEMWPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 18:15:42 -0400
Date: Tue, 13 May 2014 15:15:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Valdis.Kletnieks@vt.edu
Cc: Fabian Frederick <fabf@skynet.be>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Joel Becker <jlbec@evilplan.org>
Subject: Re: [PATCH 2/2] FS/CONFIGFS: Use pr_fmt
Message-Id: <20140513151541.a4e5649a657569e8847b3d84@linux-foundation.org>
In-Reply-To: <75410.1400018810@turing-police.cc.vt.edu>
References: <20140513202428.77c59d530a2c2154a9902cb3@skynet.be>
	<20140513135049.2d160a63d662b3aab6ba3c03@linux-foundation.org>
	<75410.1400018810@turing-police.cc.vt.edu>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2014 18:06:50 -0400 Valdis.Kletnieks@vt.edu wrote:

> On Tue, 13 May 2014 13:50:49 -0700, Andrew Morton said:
> > On Tue, 13 May 2014 20:24:28 +0200 Fabian Frederick <fabf@skynet.be> wrote:
> 
> > > +#ifdef pr_fmt
> > > +#undef pr_fmt
> > > +#endif
> >
> > Why this?
> >
> > > +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> 
> Won't GCC whinge by default about the #define if it doesn't exactly match the
> previous definition?

Yes, if there's already a pf_fmt defined.  That's what I'm asking about
- what pr_fmt are we overriding here?  Seems wrong.

