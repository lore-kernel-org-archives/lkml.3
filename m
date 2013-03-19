Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965067Ab3CSXAl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 19:00:41 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:46371 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965026Ab3CSXAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 19:00:38 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: tux3@phunq.net
Subject: Re: Tux3 Report: Initial fsck has landed
Date: Wed, 20 Mar 2013 00:00:32 +0100
User-Agent: KMail/1.13.7 (Linux/3.9.0-rc3-tp520; KDE/4.9.5; x86_64; ; )
Cc: Daniel Phillips <daniel.raymond.phillips@gmail.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        David Lang <david@lang.hm>, linux-kernel@vger.kernel.org,
        tux3@tux3.org, linux-fsdevel@vger.kernel.org
References: <CAEsagEgeaHC_2ULhr_yAtOuNUxk+PZC=aPXU4PQyY9NnUC=TyQ@mail.gmail.com> <20130129014000.GA7003@thunk.org> <CAEsagEhZkkr+G0gFr6rnsyjFmCckNMkOnTVcUMvaj8EHD-qGQw@mail.gmail.com> (sfid-20130129_203331_599683_707322ED)
In-Reply-To: <CAEsagEhZkkr+G0gFr6rnsyjFmCckNMkOnTVcUMvaj8EHD-qGQw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303200000.33356.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 29. Januar 2013 schrieb Daniel Phillips:
> On Mon, Jan 28, 2013 at 5:40 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> > On Mon, Jan 28, 2013 at 04:20:11PM -0800, Darrick J. Wong wrote:
> >> On Mon, Jan 28, 2013 at 03:27:38PM -0800, David Lang wrote:
> >> > The situation I'm thinking of is when dealing with VMs, you make a
> >> > filesystem image once and clone it multiple times. Won't that end up
> >> > with the same UUID in the superblock?
> >> 
> >> Yes, but one ought to be able to change the UUID a la tune2fs
> >> -U.  Even still... so long as the VM images have a different UUID
> >> than the fs that they live on, it ought to be fine.
> > 
> > ... and this is something most system administrators should be
> > familiar with.  For example, it's one of those things that Norton
> > Ghost when makes file system image copes (the equivalent of "tune2fs
> > -U random /dev/XXX")
> 
> Hmm, maybe I missed something but it does not seem like a good idea
> to use the volume UID itself to generate unique-per-volume metadata
> hashes, if users expect to be able to change it. All the metadata hashes
> would need to be changed.

I believe that is what BTRFS is doing.

And yes, AFAIK there is no easy way to change the UUID of a BTRFS filesystems 
after it was created.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
