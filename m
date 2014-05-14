Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932155AbaENL0g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 07:26:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51640 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755094AbaENL0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 07:26:33 -0400
Date: Wed, 14 May 2014 13:26:21 +0200
From: Mateusz Guzik <mguzik@redhat.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Josef Bacik <jbacik@fb.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        Eric Sandeen <esandeen@redhat.com>, Joe Perches <joe@perches.com>
Subject: Re: [PATCH V2 2/2] fs: print a message when freezing/unfreezing
 filesystems
Message-ID: <20140514112619.GA10637@mguzik.redhat.com>
References: <1400018683-5565-1-git-send-email-mguzik@redhat.com>
 <1400018683-5565-2-git-send-email-mguzik@redhat.com>
 <20140514111449.GB5824@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140514111449.GB5824@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 01:14:49PM +0200, Jan Kara wrote:
> On Wed 14-05-14 00:04:43, Mateusz Guzik wrote:
> > This helps hang troubleshooting efforts when only dmesg is available.
> > 
> > While here remove code duplication with MS_RDONLY case and fix a
> > whitespace nit.
>   I'm somewhat undecided here I have to say. On one hand I don't like
> printing to kernel log when everything is fine and kernel is operating
> normally. On the other hand I've seen quite a few cases where people have
> shot themselves in the foot with filesystem freezing so having some trace
> of this in the log doesn't seem like a completely bad thing either. What do
> other people think?
> 

I would like to note that the kernel already prints messages when e.g.
filesystems get mounted.

And yes, situations where I/O is frozen and hung task detector comes into
play happen more often than you may think. I can hide these behind a
sysctl if this helps.

Finally, somewhat related to the first mail, my preferred message format
(which I was somewhat reluctant to propose earlier) would be:

VFS (%s): Filesystem frozen by %s:%d

with device, process and pid respectively.

-- 
Mateusz Guzik
