Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169Ab3ARD5D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 22:57:03 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:44107 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752744Ab3ARD5A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 22:57:00 -0500
Date: Thu, 17 Jan 2013 22:56:50 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Alexander Beregalov <a.beregalov@gmail.com>,
        Zheng Liu <wenqing.lz@taobao.com>
Subject: Re: [ 36/71] ext4: lock i_mutex when truncating orphan inodes
Message-ID: <20130118035650.GA13785@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	alan@lxorguk.ukuu.org.uk,
	Alexander Beregalov <a.beregalov@gmail.com>,
	Zheng Liu <wenqing.lz@taobao.com>
References: <20130115225340.367496998@linuxfoundation.org>
 <20130115225343.033036403@linuxfoundation.org>
 <20130117200710.GD2872@herton-Z68MA-D2H-B3>
 <20130118004616.GA5730@kroah.com>
 <20130118034747.GF2872@herton-Z68MA-D2H-B3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130118034747.GF2872@herton-Z68MA-D2H-B3>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 01:47:48AM -0200, Herton Ronaldo Krzesinski wrote:
> > > By the description and looking at commit c278531d39, this change isn't
> > > needed for 3.0 or 3.4 kernels (anything <= 3.6), they don't contain
> > > commit c278531d39.
> > 
> > Ah, good catch.  Should this be reverted from 3.0 and 3.4?
> 
> I judge it as unecessary from what I saw so far, can ext4 developers
> and/or people in Cc confirm? It should be harmless, only consequence is
> an uneeded lock being taken now in 3.0/3.4

It's not worth it to revert it.  The lock is being taken in a
completely non-fastpath, as well as guaranteed-to-be non-contended
code path.

We're not requiring that the lock be taken in 3.0 and 3.4, but
arguably it's still a good idea to take it from a consistency point of
view.

						- Ted
