Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbaG3N5d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 09:57:33 -0400
Received: from tex.lwn.net ([70.33.254.29]:41883 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753286AbaG3N5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 09:57:12 -0400
Date: Wed, 30 Jul 2014 09:57:09 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: Abhijith Das <adas@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        cluster-devel@redhat.com
Subject: Re: [RFC PATCH 5/5] gfs2: Add xreaddir file operation and
 supporting functions
Message-ID: <20140730095709.62bade17@lwn.net>
In-Reply-To: <584806381.15003446.1406672757956.JavaMail.zimbra@redhat.com>
References: <1406309888-10749-1-git-send-email-adas@redhat.com>
	<1406309888-10749-6-git-send-email-adas@redhat.com>
	<20140729145808.79bec165@lwn.net>
	<584806381.15003446.1406672757956.JavaMail.zimbra@redhat.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jul 2014 18:25:57 -0400 (EDT)
Abhijith Das <adas@redhat.com> wrote:

> > > +	if ((xc->xc_xattr_mask & XSTAT_XATTR_ALL) &&
> > > +		lxd->xd_blob.xb_xattr_count) {  
> > 
> > How can that be right?  lxd is __user, it doesn't seem right to be
> > dereferencing it directly...?  
> 
> Wouldn't the call to access_ok() at the start of the syscall take care of this? All the
> __user pointers point to areas within the user supplied buffer buf and overflow past the
> end of the buffer for the last lxd is checked for.

No, dereferencing user-space pointers in the kernel is never OK.  What
if user space remapped that page after the access_ok() call?  You need
to use copy_*_user() to get at user-space structures from the kernel.

jon
