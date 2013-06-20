Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757994Ab3FTM4C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 08:56:02 -0400
Received: from www.linutronix.de ([62.245.132.108]:32986 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757586Ab3FTM4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 08:56:00 -0400
Date: Thu, 20 Jun 2013 14:55:55 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chen Gang <gang.chen@asianux.com>
cc: "'Jiri Kosina'" <trivial@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] kernel/itimer.c: beautify code, not need check 'value',
 so save one instruction, simpler and easier for readers.
In-Reply-To: <51C2EF71.4010308@asianux.com>
Message-ID: <alpine.DEB.2.02.1306201455330.4013@ionos.tec.linutronix.de>
References: <51C2E6F9.80107@asianux.com> <51C2EF71.4010308@asianux.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Jun 2013, Chen Gang wrote:

> 
> Oh, sorry, maybe it is a trivial patch, also need send to
> trivial@kernel.org.

No. This is not a trivial patch, it's changing the code flow.
 
> 
> On 06/20/2013 07:26 PM, Chen Gang wrote:
> > 
> > Since copy_to_user() will check 'value', we do not need check it outside
> > again,  so can save one comparing instruction at least.
> > 
> > Also can let code simpler and easier for readers: if checking parameter
> > 'value', it will easily lead readers to think about why not return
> > -EINVAL instead of -EFAULT, when checking parameter failed.
> > 
> > Signed-off-by: Chen Gang <gang.chen@asianux.com>
> > ---
> >  kernel/itimer.c |   13 ++++++-------
> >  1 files changed, 6 insertions(+), 7 deletions(-)
> > 
> > diff --git a/kernel/itimer.c b/kernel/itimer.c
> > index 8d262b4..3b12271 100644
> > --- a/kernel/itimer.c
> > +++ b/kernel/itimer.c
> > @@ -102,15 +102,14 @@ int do_getitimer(int which, struct itimerval *value)
> >  
> >  SYSCALL_DEFINE2(getitimer, int, which, struct itimerval __user *, value)
> >  {
> > -	int error = -EFAULT;
> > +	int error;
> >  	struct itimerval get_buffer;
> >  
> > -	if (value) {
> > -		error = do_getitimer(which, &get_buffer);
> > -		if (!error &&
> > -		    copy_to_user(value, &get_buffer, sizeof(get_buffer)))
> > -			error = -EFAULT;
> > -	}
> > +	error = do_getitimer(which, &get_buffer);
> > +	if (!error &&
> > +	    copy_to_user(value, &get_buffer, sizeof(get_buffer)))
> > +		error = -EFAULT;
> > +
> >  	return error;
> >  }
> >  
> > 
> 
> 
> -- 
> Chen Gang
> 
> Asianux Corporation
> 
