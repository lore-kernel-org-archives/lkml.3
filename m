Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691Ab3CTEST (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 00:18:19 -0400
Received: from mail.lang.hm ([64.81.33.126]:53820 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751290Ab3CTESS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 00:18:18 -0400
X-Greylist: delayed 725 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Mar 2013 00:18:13 EDT
Date: Tue, 19 Mar 2013 21:04:15 -0700 (PDT)
From: David Lang <david@lang.hm>
X-X-Sender: dlang@asgard.lang.hm
To: Martin Steigerwald <Martin@lichtvoll.de>
cc: tux3@phunq.net, Daniel Phillips <daniel.raymond.phillips@gmail.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-kernel@vger.kernel.org, tux3@tux3.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: Tux3 Report: Initial fsck has landed
In-Reply-To: <201303200000.33356.Martin@lichtvoll.de>
Message-ID: <alpine.DEB.2.02.1303192102350.31505@nftneq.ynat.uz>
References: <CAEsagEgeaHC_2ULhr_yAtOuNUxk+PZC=aPXU4PQyY9NnUC=TyQ@mail.gmail.com> <20130129014000.GA7003@thunk.org> <CAEsagEhZkkr+G0gFr6rnsyjFmCckNMkOnTVcUMvaj8EHD-qGQw@mail.gmail.com> (sfid-20130129_203331_599683_707322ED)
 <201303200000.33356.Martin@lichtvoll.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Mar 2013, Martin Steigerwald wrote:

> Am Dienstag, 29. Januar 2013 schrieb Daniel Phillips:
>> On Mon, Jan 28, 2013 at 5:40 PM, Theodore Ts'o <tytso@mit.edu> wrote:
>>> On Mon, Jan 28, 2013 at 04:20:11PM -0800, Darrick J. Wong wrote:
>>>> On Mon, Jan 28, 2013 at 03:27:38PM -0800, David Lang wrote:
>>>>> The situation I'm thinking of is when dealing with VMs, you make a
>>>>> filesystem image once and clone it multiple times. Won't that end up
>>>>> with the same UUID in the superblock?
>>>>
>>>> Yes, but one ought to be able to change the UUID a la tune2fs
>>>> -U.  Even still... so long as the VM images have a different UUID
>>>> than the fs that they live on, it ought to be fine.
>>>
>>> ... and this is something most system administrators should be
>>> familiar with.  For example, it's one of those things that Norton
>>> Ghost when makes file system image copes (the equivalent of "tune2fs
>>> -U random /dev/XXX")
>>
>> Hmm, maybe I missed something but it does not seem like a good idea
>> to use the volume UID itself to generate unique-per-volume metadata
>> hashes, if users expect to be able to change it. All the metadata hashes
>> would need to be changed.
>
> I believe that is what BTRFS is doing.
>
> And yes, AFAIK there is no easy way to change the UUID of a BTRFS filesystems
> after it was created.

In a world where systems are cloned, and many VMs are started from one master 
copy of a filesystem, a UUID is about as far from unique as anything you can 
generate.

BTRFS may have this problem, but why should Tux3 copy the problem?

David Lang
