Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062AbaDWFGp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 01:06:45 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:36623 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993AbaDWFGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 01:06:42 -0400
Date: Wed, 23 Apr 2014 00:06:39 -0500
From: Eric Biggers <ebiggers3@gmail.com>
To: Dave Jones <davej@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] vfs: rw_copy_check_uvector() - free iov on error
Message-ID: <20140423050639.GA2755@zzz.student-wireless07.macalester.edu>
References: <20140415145749.GF10187@tucsk.piliscsaba.szeredi.hu>
 <20140416180422.GA20907@redhat.com>
 <20140421155020.GB13709@redhat.com>
 <CAJfpegs9cgVgxbYZSM=SxyJqj=N1QA5npp7ic6i80CMec+3sZw@mail.gmail.com>
 <20140422133835.GA32718@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140422133835.GA32718@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The proposed patch doesn't work because in compat_rw_copy_check_uvector(), 'iov'
is incremented in the loop before it is freed or returned.  This probably should
be changed to indexing with 'seg', like in the non-compat version...
