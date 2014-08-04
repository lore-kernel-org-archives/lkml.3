Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618AbaHDNM5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 09:12:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52214 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751117AbaHDNM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 09:12:56 -0400
Date: Mon, 4 Aug 2014 15:12:49 +0200
From: Karel Zak <kzak@redhat.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-api@vger.kernel.org,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [REVIEW][PATCH 0/4] /proc/thread-self
Message-ID: <20140804131249.GD6923@x2.net.home>
References: <87oaw5caq1.fsf@x220.int.ebiederm.org>
 <1406860795.3036.3.camel@buesod1.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406860795.3036.3.camel@buesod1.americas.hpqcorp.net>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2014 at 07:39:55PM -0700, Davidlohr Bueso wrote:
> On Thu, 2014-07-31 at 17:30 -0700, Eric W. Biederman wrote:
> > This is small chance changing /proc/net and /proc/mounts will cause
> > userspace regressions (although nothing has shown up in my testing) if
> > that happens we can just point the change that moves them from
> > /proc/self/... to /proc/thread-self/...
> 
> Isn't breaking userspace a no no, no matter what? At least some
> util-linux programs makes use of both /proc/mounts and /proc/net.

Frankly, I don't care about /proc/mount, this file is more about backward
compatibility than about any real informations ;-)

The really important file is /proc/self/mountinfo. We use this file on
many places including shared libs and it seems (according to Eric's
suggestion), that the right think will be to update the libs to use
/proc/thread-self/mountinfo.


Note that I like the idea to have the magic symlink to access thread
specific /proc stuff. It's definitely nice thing for userspace.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
