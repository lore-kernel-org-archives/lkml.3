Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351Ab3JBE5p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 00:57:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59412 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab3JBE5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 00:57:43 -0400
Date: Tue, 1 Oct 2013 21:57:49 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: Mathieu =?iso-8859-1?Q?Rh=E9aume?= <mathieu@codingrhemes.com>,
        arve@android.com, dan.carpenter@oracle.com, mirsal@mirsal.fr,
        serban.constantinescu@arm.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: android: binder.c: Fixed 80 characters warnings
 from checkpatch.pl
Message-ID: <20131002045749.GA15121@kroah.com>
References: <1380677988-9329-1-git-send-email-mathieu@codingrhemes.com>
 <1380678404.2081.21.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1380678404.2081.21.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 01, 2013 at 06:46:44PM -0700, Joe Perches wrote:
> On Tue, 2013-10-01 at 21:39 -0400, Mathieu Rhéaume wrote:
> > Fixed a lot of warnings from checkpatch.pl about the 80 characters per line limitation.
> 
> I'd prefer
> 	s/binder_user_error/binder_user_err/
> or
> 	s/binder_user_error/binder_err/
> 
> without doing the strange wrapping
> 
> checkpatch will then exclude these long line formats from
> line length checking.
> 
> > diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
> []
> > @@ -663,7 +663,8 @@ static struct binder_buffer *binder_alloc_buf(struct binder_proc *proc,
> >  		ALIGN(offsets_size, sizeof(void *));
> >  
> >  	if (size < data_size || size < offsets_size) {
> > -		binder_user_error("%d: got transaction with invalid size %zd-%zd\n",
> > +		binder_user_error(
> > +		"%d: got transaction with invalid size %zd-%zd\n",
> >  				proc->pid, data_size, offsets_size);
> 
> IMO - not an improvement
> 

I agree, checkpatch is a guide, not a hard and fast rule.  For stuff
like this, it gets the line length wrong, so it's safe to leave it
alone.

greg k-h
