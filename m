Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081AbaDXT0Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 15:26:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38730 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbaDXT0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 15:26:22 -0400
Date: Thu, 24 Apr 2014 12:29:15 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Christopher Brannon <chris@the-brannons.com>,
        Samuel Thibault <samuel.thibault@ens-lyon.org>
Subject: Re: [PATCH 6/9] drivers/staging/speakup/: avoid world-writable sysfs
 files.
Message-ID: <20140424192915.GA21617@kroah.com>
References: <1398137612-9714-1-git-send-email-rusty@rustcorp.com.au>
 <1398137612-9714-7-git-send-email-rusty@rustcorp.com.au>
 <20140422163736.GA23831@kroah.com>
 <87bnvrfj22.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bnvrfj22.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 01:57:49PM +0930, Rusty Russell wrote:
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> > On Tue, Apr 22, 2014 at 01:03:29PM +0930, Rusty Russell wrote:
> >> In line with practice for module parameters, we're adding a build-time
> >> check that sysfs files aren't world-writable.
> >
> > Then why not just use the __ATTR_RO() macro?
> 
> Hmm, I didn't know those variants existed :(
> 
> But most of these are not amenable to __ATTR_RO etc, since they call
> generic helpers, eg:
> 
> 	__ATTR(delimiters, S_IWUGO|S_IRUGO, punc_show, punc_store);
> 
> I dislike the __ATTR_RO etc macros: hiding the references to the
> function from grep is Too Much Magic.  (Sure, I do it in module_param,
> but that has the excuse that it allows typechecking as well).
> 
> > I'd prefer some "standard" permissions for all of these sysfs files,
> > it's quite confusing otherwise, don't you agree?
> 
> Agreed.  So I used S_IWUSR | S_IRUGO everywhere, which is what ATTR_RW
> uses.
> 
> Cheers,
> Rusty.
> 
> Subject: drivers/staging/speakup/: avoid world-writable sysfs files.
> 
> In line with practice for module parameters, we're adding a build-time
> check that sysfs files aren't world-writable.
> 
> Cc: Christopher Brannon <chris@the-brannons.com>
> Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
