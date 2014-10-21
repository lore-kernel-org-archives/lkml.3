Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932730AbaJUTHN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 15:07:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39815 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755139AbaJUTHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 15:07:11 -0400
Date: Tue, 21 Oct 2014 12:07:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>, mingo@kernel.org,
        Mark Rustad <mark.d.rustad@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel/sysctl: Resolve missing-field-initializers
 warnings
Message-Id: <20141021120711.0ddb53adb4fdecf241826473@linux-foundation.org>
In-Reply-To: <87a94szydt.fsf@x220.int.ebiederm.org>
References: <1413286868-21870-1-git-send-email-jeffrey.t.kirsher@intel.com>
	<87a94szydt.fsf@x220.int.ebiederm.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Oct 2014 17:39:10 -0700 ebiederm@xmission.com (Eric W. Biederman) wrote:

> Jeff Kirsher <jeffrey.t.kirsher@intel.com> writes:
> 
> > From: Mark Rustad <mark.d.rustad@intel.com>
> >
> > Resolve missing-field-initializers warnings in W=2 builds by
> > using designated initialization.
> 
> ick.  No.
> 
> That gcc warning makes no sense.  In this case heeding it makes the code
> significantly uglier and significantly more confusing.
> 

Yeah, it's not pretty.

> > --- a/kernel/sysctl.c
> > +++ b/kernel/sysctl.c
> > @@ -257,7 +257,7 @@ static struct ctl_table sysctl_base_table[] = {
> >  		.mode		= 0555,
> >  		.child		= dev_table,
> >  	},
> > -	{ }
> > +	{ .procname = NULL }
> >  };

We use { } to mean "all zero" in 12 squillion places.  Do they all warn
or is there something special about this site?

