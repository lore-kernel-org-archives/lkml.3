Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397AbaBMQn1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 11:43:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41118 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751758AbaBMQnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 11:43:25 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20140213162534.GB4026@tucsk.piliscsaba.szeredi.hu>
References: <20140213162534.GB4026@tucsk.piliscsaba.szeredi.hu> <1391791751-2533-1-git-send-email-miklos@szeredi.hu> <19258.1392306854@warthog.procyon.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: dhowells@redhat.com, viro@ZenIV.linux.org.uk,
        torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, bfields@fieldses.org, hch@infradead.org,
        akpm@linux-foundation.org, zab@redhat.com, jack@suse.cz,
        luto@amacapital.net, mszeredi@suse.cz
Subject: Re: [PATCH 00/13] cross rename v4
Date: Thu, 13 Feb 2014 16:42:50 +0000
Message-ID: <20106.1392309770@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> wrote:

> Regarding whiteouts, I raised a couple of questions that nobody answered
> yet, so let me ask again.
> 
> - If a filesystem containing whiteouts (fallthroughs, etc...) is mounted as
>   not part of a union, how are these special entities represented to
>   userspace?

I would suggest that whiteouts appear as otherwise negative dentries and that
they don't appear in getdents().

Fallthroughs are far more 'interesting'.  Maybe they should appear in
getdents() with a dentry type saying what they are, but give you EREMOTE or
something if you try to follow them.

Note that there is space in d_flags & DCACHE_ENTRY_TYPE for a whiteout type.
I would, however, mark fallthroughs by a separate flag.  So that the union
dentry will mirror the source dentry's type.

> - Can the user remove them?

Overwriting whiteouts and fallthroughs and unlinking fallthroughs I don't see
as a problem where they can be treated as normal negative dentries and normal
files in this regard.

However, what do you do about non-opaque directories that may or may not have
been unioned if you try and follow a dirent that would be a subdirectory that
hasn't been copied up?

David
