Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757059Ab3C3UIr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 16:08:47 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:64000 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756555Ab3C3UIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 16:08:45 -0400
Subject: Re: New copyfile system call - discuss before LSF?
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20130330194933.GB1005@amd.pavel.ucw.cz>
Date: Sat, 30 Mar 2013 13:08:39 -0700
Cc: =?iso-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>,
        Andy Lutomirski <luto@amacapital.net>, Zach Brown <zab@redhat.com>,
        "Myklebust, Trond" <Trond.Myklebust@netapp.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Ric Wheeler <rwheeler@redhat.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chris L. Mason" <clmason@fusionio.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Viro <aviro@redhat.com>, "Martin K. Petersen" <mkp@mkp.net>,
        Hannes Reinecke <hare@suse.de>, Joel Becker <jlbec@evilplan.org>
Content-Transfer-Encoding: 7bit
Message-Id: <08D26E22-3856-43A4-8835-48C86CC5F71C@dilger.ca>
References: <512606DF.5050706@redhat.com> <4FA345DA4F4AE44899BD2B03EEEC2FA9235D998C@SACEXCMBX04-PRD.hq.netapp.com> <512635D2.4090207@redhat.com> <51267CEB.8070805@redhat.com> <4FA345DA4F4AE44899BD2B03EEEC2FA9235DAA99@SACEXCMBX04-PRD.hq.netapp.com> <20130221222449.GY22221@lenny.home.zabbo.net> <512BD44C.40907@amacapital.net> <20130226210232.GA19510@logfs.org> <20130330194933.GB1005@amd.pavel.ucw.cz>
To: Pavel Machek <pavel@ucw.cz>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-03-30, at 12:49 PM, Pavel Machek wrote:
> Hmm, really? AFAICT it would be simple to provide an
> open_deleted_file("directory") syscall. You'd open_deleted_file(),
> copy source file into it, then fsync(), then link it into filesystem.
> 
> That should have atomicity properties reflected.

Actually, the open_deleted_file() syscall is quite useful for many
different things all by itself.  Lots of applications need to create
temporary files that are unlinked at application failure (without a
race if app crashes after creating the file, but before unlinking).
It also avoids exposing temporary files into the namespace if other
applications are accessing the directory.

We've added a library routine that does this for Lustre in a hackish
way (magical filename created in target directory) for being able to
migrate files between data servers, HSM, defragmentation, rsync, etc.

Cheers, Andreas





