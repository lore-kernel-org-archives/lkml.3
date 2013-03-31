Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826Ab3CaSo6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 14:44:58 -0400
Received: from mx12.netapp.com ([216.240.18.77]:11873 "EHLO mx12.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752696Ab3CaSoz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 14:44:55 -0400
X-IronPort-AV: E=Sophos;i="4.87,383,1363158000"; 
   d="scan'208";a="35739228"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Pavel Machek <pavel@ucw.cz>
CC: Andreas Dilger <adilger@dilger.ca>,
        =?iso-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>,
        Andy Lutomirski <luto@amacapital.net>, Zach Brown <zab@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Ric Wheeler <rwheeler@redhat.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chris L. Mason" <clmason@fusionio.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Viro <aviro@redhat.com>, "Martin K. Petersen" <mkp@mkp.net>,
        Hannes Reinecke <hare@suse.de>, Joel Becker <jlbec@evilplan.org>
Subject: Re: openat(..., AT_UNLINKED) was Re: New copyfile system call -
 discuss before LSF?
Thread-Topic: openat(..., AT_UNLINKED) was Re: New copyfile system call -
 discuss before LSF?
Thread-Index: AQHOECfzherspfmEjEqBTzfvhb3EUJiE2wAAgAASTQCAAFTBgIAADekAgAAaWoCABjXIAIABjuMAgDIlc4CAAAVWgIAAGvaAgAADUYCAAKHMgIAAtgEAgAABbQCAAANsgA==
Date: Sun, 31 Mar 2013 18:44:53 +0000
Message-ID: <1364755493.4771.14.camel@leira.trondhjem.org>
References: <4FA345DA4F4AE44899BD2B03EEEC2FA9235DAA99@SACEXCMBX04-PRD.hq.netapp.com>
	 <20130221222449.GY22221@lenny.home.zabbo.net>
	 <512BD44C.40907@amacapital.net> <20130226210232.GA19510@logfs.org>
	 <20130330194933.GB1005@amd.pavel.ucw.cz>
	 <08D26E22-3856-43A4-8835-48C86CC5F71C@dilger.ca>
	 <20130330214509.GB4322@amd.pavel.ucw.cz>
	 <925D663D-D8F8-4297-A642-33C732354701@netapp.com>
	 <20130331073604.GA13159@amd.pavel.ucw.cz>
	 <1364754452.4771.10.camel@leira.trondhjem.org>
	 <20130331183238.GA25751@amd.pavel.ucw.cz>
In-Reply-To: <20130331183238.GA25751@amd.pavel.ucw.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.116]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <E339A339890B4B4D869DB5984C8E519A@tahoe.netapp.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-03-31 at 20:32 +0200, Pavel Machek wrote:
> > > > > Hmm. open_deleted_file() will still need to get a directory... so it
> > > > > will still need a path. Perhaps open("/foo/bar/mnt", O_DELETED) would
> > > > > be acceptable interface?
> > > > 
> > > > ...and what's the big plan to make this work on anything other than ext4 and btrfs?
> > > 
> > > Deleted but open files are from original unix, so it should work on
> > > anything unixy (minix, ext, ext2, ...).
> > 
> > minix, ext, ext2... are not under active development and haven't been
> > for more than a decade.
> > 
> > Take a look at how many actively used filesystems out there that have
> > some variant of sillyrename(), and explain what you want to do in those
> > cases.
> 
> Well. Yes, there are non-unix filesystems around. You have to deal
> with silly files on them, and this will not be different.

So this would be a local POSIX filesystem only solution to a problem
that has yet to be formulated?

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
