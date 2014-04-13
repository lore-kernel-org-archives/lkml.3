Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906AbaDMFtz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 01:49:55 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40312 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbaDMFtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 01:49:53 -0400
Date: Sun, 13 Apr 2014 06:49:48 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>, Rob Landley <rob@landley.net>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Christoph Hellwig <hch@infradead.org>, Karel Zak <kzak@redhat.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [RFC][PATCH] vfs: In mntput run deactivate_super on a shallow
 stack.
Message-ID: <20140413054948.GN18016@ZenIV.linux.org.uk>
References: <20140409023027.GX18016@ZenIV.linux.org.uk>
 <20140409023947.GY18016@ZenIV.linux.org.uk>
 <87sipmbe8x.fsf@x220.int.ebiederm.org>
 <20140409175322.GZ18016@ZenIV.linux.org.uk>
 <20140409182830.GA18016@ZenIV.linux.org.uk>
 <87txa286fu.fsf@x220.int.ebiederm.org>
 <87fvlm860e.fsf_-_@x220.int.ebiederm.org>
 <20140409232423.GB18016@ZenIV.linux.org.uk>
 <87lhva5h4k.fsf@x220.int.ebiederm.org>
 <20140413053956.GM18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140413053956.GM18016@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 13, 2014 at 06:39:56AM +0100, Al Viro wrote:
> 	type = get_fs_type("proc");
> 	ns = kmalloc(...);
> 	/* fill *ns */
> 	mnt = kern_mount_data(type, p);
s/p/ns/
> 	...
> 	if (error) {
> 		kern_unmount(mnt);
> 		kfree(p);
ditto.
> 		put_filesystem(type);
> 	}

BTW, miklos seems to have a  buggered gmail setup - every posting to that
thread triggers a bounce that appears to come from some kind of spam filters
there...
