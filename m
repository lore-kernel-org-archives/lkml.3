Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493Ab3A1X3U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 18:29:20 -0500
Received: from mail.lang.hm ([64.81.33.126]:49497 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564Ab3A1X3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 18:29:17 -0500
Date: Mon, 28 Jan 2013 15:27:38 -0800 (PST)
From: David Lang <david@lang.hm>
X-X-Sender: dlang@asgard.lang.hm
To: "Theodore Ts'o" <tytso@mit.edu>
cc: Daniel Phillips <daniel.raymond.phillips@gmail.com>,
        linux-kernel@vger.kernel.org, tux3@tux3.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: Tux3 Report: Initial fsck has landed
In-Reply-To: <20130128141209.GA22711@thunk.org>
Message-ID: <alpine.DEB.2.02.1301281526410.21503@nftneq.ynat.uz>
References: <CAEsagEgeaHC_2ULhr_yAtOuNUxk+PZC=aPXU4PQyY9NnUC=TyQ@mail.gmail.com> <alpine.DEB.2.02.1301272158450.13067@nftneq.ynat.uz> <CAEsagEjAoVNUUSotBXd0am5zZb5VMLWT2Dz9k5fj+C9-LKABnQ@mail.gmail.com> <20130128141209.GA22711@thunk.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jan 2013, Theodore Ts'o wrote:

> On Sun, Jan 27, 2013 at 10:13:37PM -0800, Daniel Phillips wrote:
>>> The thing that jumps out at me with this is the question of how you will
>>> avoid the 'filesystem image in a file' disaster that reiserfs had (where
>>> it's fsck could mix up metadata chunks from the main filesystem with
>>> metadata chunks from any filesystem images that it happened to stumble
>>> across when scanning the disk)
>>>
>> Only superficially. Deep thoughts are in order. First, there needs to be a
>> hole in the filesystem structure, before we would even consider trying to
>> plug something in there. Once we know there is a hole, we want to
>> narrow down the list of candidates to fill it. If a candidate already lies
>> within a perfectly viable file, obviously we would not want to interpret
>> that as lost metadata. Unless the filesystem is really mess up...
>>
>> That is about as far as I have got with the analysis. Clearly, much more
>> is required. Suggestions welcome.
>
> The obvious answer is what resierfs4 ultimately ended up using.  Drop
> a file system UUID in the superblock; mix the UUID into a checksum
> which protects each of the your metadata blocks.  We're mixing in the
> inode number as well as the fs uuid in in ext4's new metadata checksum
> feature to protect against an inode table block getting written to the
> wrong location on disk.  It will also mean that e2fsck won't mistake
> an inode table from an earlier mkfs with the current file system.
> This will allow us to avoid needing to zero the inode table for newly
> initialized file systems.

The situation I'm thinking of is when dealing with VMs, you make a filesystem 
image once and clone it multiple times. Won't that end up with the same UUID in 
the superblock?

David Lang
