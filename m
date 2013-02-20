Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964928Ab3BTVGq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 16:06:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40608 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935204Ab3BTVGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 16:06:45 -0500
Date: Wed, 20 Feb 2013 13:06:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hughd@google.com>
Cc: Greg Thelen <gthelen@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] tmpfs: fix mempolicy object leaks
Message-Id: <20130220130643.992f7c6e.akpm@linux-foundation.org>
In-Reply-To: <alpine.LNX.2.00.1302201221270.1152@eggly.anvils>
References: <1361344302-26565-1-git-send-email-gthelen@google.com>
	<1361344302-26565-2-git-send-email-gthelen@google.com>
	<alpine.LNX.2.00.1302201221270.1152@eggly.anvils>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2013 12:26:26 -0800 (PST)
Hugh Dickins <hughd@google.com> wrote:

> > @@ -2463,19 +2464,23 @@ static int shmem_parse_options(char *options, struct shmem_sb_info *sbinfo,
> >  			if (!gid_valid(sbinfo->gid))
> >  				goto bad_val;
> >  		} else if (!strcmp(this_char,"mpol")) {
> > -			if (mpol_parse_str(value, &sbinfo->mpol))
> > +			mpol_put(mpol);
> 
> I haven't tested to check, but don't we need
> 			mpol = NULL;
> here, in case the new option turns out to be bad?

We do.
