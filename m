Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757059Ab3GYTho (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 15:37:44 -0400
Received: from longford.logfs.org ([213.229.74.203]:59911 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756430Ab3GYThm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 15:37:42 -0400
Date: Thu, 25 Jul 2013 14:05:45 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Dhaval Giani <dgiani@mozilla.com>
Cc: linux-kernel@vger.kernel.org, tytso@mit.edu, tglek@mozilla.com,
        vdjeric@mozilla.com, glandium@mozilla.com, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [RFC/PATCH 0/2] ext4: Transparent Decompression Support
Message-ID: <20130725180545.GB15590@logfs.org>
References: <1374699833.7083.2.camel@localhost>
 <20130724233628.GD3641@logfs.org>
 <51F14136.30409@mozilla.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51F14136.30409@mozilla.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 July 2013 11:16:06 -0400, Dhaval Giani wrote:
> >
> >If you want to follow some other approach where userspace has one
> >interface to write the compressed data to a file and some other
> >interface to read the file uncompressed, you are likely in a world of
> >pain.
> Why? If it is going to only be a few applications who know the file
> is compressed, and read it to get decompressed data, why would it be
> painful?

It would likely require an ABI extention.  Your immediate pain would
be to get past a wall of NAK when you propose the extention.  You have
to make a rather convincing case that the ABI extention cannot cause
VFS or filesystem maintainers future pain in some dark cornercase.

Just because the one application you care about only wants to use
compression on write-once files doesn't prevent the next person from
abusing the new ABI.  Such abuse should be strictly limited,
preferrably impossible.

I am not saying that I object.  Just warning you to brace yourself for
impact.

> What about introducing a new flag, O_COMPR which tells the
> kernel, btw, we want this file to be decompressed if it can be. It
> can fallback to O_RDONLY or something like that? That gets rid of
> the chattr ugliness.

How is that different from chattr ugliness, which also comes down to a
single flag? ;)

Jörn

--
/* Keep these two variables together */
int bar;
