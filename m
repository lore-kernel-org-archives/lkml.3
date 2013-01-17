Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026Ab3AQXBI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 18:01:08 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:59145 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754342Ab3AQXBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 18:01:05 -0500
Subject: Re: LIO - the broken iSCSI target implementation
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Andy Grover <agrover@redhat.com>
Cc: Andreas Steinmetz <ast@domdv.de>, linux-kernel@vger.kernel.org,
        hch@infradead.org, torvalds@linux-foundation.org,
        target-devel <target-devel@vger.kernel.org>,
        Ritesh Raj Sarraf <rrs@debian.org>
In-Reply-To: <50F87BCA.10201@redhat.com>
References: <1358385543.7040.54.camel@host028-server-9.lan.domdv.de>
	 <1358456179.18551.34.camel@haakon2.linux-iscsi.org>
	 <50F87BCA.10201@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Jan 2013 15:00:56 -0800
Message-ID: <1358463656.18551.158.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-17 at 14:31 -0800, Andy Grover wrote:
> On 01/17/2013 12:56 PM, Nicholas A. Bellinger wrote:
> > On Thu, 2013-01-17 at 02:19 +0100, Andreas Steinmetz wrote:
> >> This is not a technical point of view. This is a more or less political
> >> and user point of view. And for any replies, I'm not subscribed (haven't
> >> been now for years).
> >>
> >> As a user, I was in need for an iSCSI target. Actually, I needed to
> >> export a SAS tape device (Ultrium 5) - which is one of the devices still
> >> sufficiently expensive to go the iSCSI target way) - well, not any disks
> >> (cheap enough, NFS available) or CD/DVD writers (I'd call these penny
> >> targets nowadays).
> >>
> >> Thus, lio (http://www.linux-iscsi.org/) seemed to be the politically and
> >> technically favoured solution. Except: it simply doesn't work, userspace
> >> utilities are seemingly not maintained,
> > 
> > I'm not sure what you mean.  There are targetcli+rtslib packages are
> > available for virtually every distribution
> > 
> > http://www.linux-iscsi.org/wiki/Targetcli#Linux_distributions
> 
> [CCing rrs@debian.org]
> 
> No... actually upstream targetcli/rtslib are not very well maintained.
> Around 5 patches each in the last year.
> 
> Meanwhile, I have been actively maintaining branches at
> github.com/agrover/targetcli-fb and github.com/agrover/rtslib-fb. We
> have a man page and screencasts even. Feel free to file bugs against
> them and I'll respond.
> 
> But I'm only packaging for Fedora/RHEL, so random people on Debian etc.
> get a bad experience. I'd like to see upstream accept my AGPLv3-licensed
> patches, or have Debian package the -fb versions, either instead or in
> addition to the upstream versions.
> 

So would I, but we've (RTS) been too busy having to work on other stuff
to pay the extensive legal bills from the fallout that your previous
public accusations have wrought. 

Even though your over it, it doesn't mean other opportunists did not try
to take advantage of the situation once you got tired and moved onto
other target userspace related things.

> (I'd kinda been waiting to bring it up until upstream had no commits in
> a year, but since you mentioned it...)

In any event, I don't really have a problem with merging the two if your
finally over the fact the userspace code is AGPL licensed. 

But please do this in a separate thread than piling on here.  Of course,
your more than welcome to fix rtslib for pSCSI, which is broken on
recent v3.x kernels.

(Hint: it's because /sys/class/scsi_device/H:C:T:L/device/block/$BLOCK_DEV
 no longer exists in upstream sysfs, which is what we use to match the passed
 /dev/$SCSI_DEV to H:C:T:L, and nothing related to TCM ABI changes)

Thanks,

--nab

