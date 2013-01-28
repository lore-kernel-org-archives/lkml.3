Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751348Ab3A1GNo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 01:13:44 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:35767 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab3A1GNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 01:13:40 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1301272158450.13067@nftneq.ynat.uz>
References: <CAEsagEgeaHC_2ULhr_yAtOuNUxk+PZC=aPXU4PQyY9NnUC=TyQ@mail.gmail.com>
	<alpine.DEB.2.02.1301272158450.13067@nftneq.ynat.uz>
Date: Sun, 27 Jan 2013 22:13:37 -0800
Message-ID: <CAEsagEjAoVNUUSotBXd0am5zZb5VMLWT2Dz9k5fj+C9-LKABnQ@mail.gmail.com>
Subject: Re: Tux3 Report: Initial fsck has landed
From: Daniel Phillips <daniel.raymond.phillips@gmail.com>
To: David Lang <david@lang.hm>
Cc: linux-kernel@vger.kernel.org, tux3@tux3.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 27, 2013 at 10:02 PM, David Lang <david@lang.hm> wrote:
> On Sun, 27 Jan 2013, Daniel Phillips wrote:
> The thing that jumps out at me with this is the question of how you will
> avoid the 'filesystem image in a file' disaster that reiserfs had (where
> it's fsck could mix up metadata chunks from the main filesystem with
> metadata chunks from any filesystem images that it happened to stumble
> across when scanning the disk)
>
> many people with dd if=/dev/sda2 of=filesystem.image, and if you are doing
> virtualization, you may be running out of one of these filesystem images.
> With virtualization, it's very likely that you will have many copies of a
> single image that are all identical.
>
> have you thought of how to deal with this problem?
>
> David Lang

Only superficially. Deep thoughts are in order. First, there needs to be a
hole in the filesystem structure, before we would even consider trying to
plug something in there. Once we know there is a hole, we want to
narrow down the list of candidates to fill it. If a candidate already lies
within a perfectly viable file, obviously we would not want to interpret
that as lost metadata. Unless the filesystem is really mess up...

That is about as far as I have got with the analysis. Clearly, much more
is required. Suggestions welcome.

Regards,

Daniel
