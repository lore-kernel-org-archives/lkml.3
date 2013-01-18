Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675Ab3ARV1e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 16:27:34 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:48863 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335Ab3ARV13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 16:27:29 -0500
Date: Fri, 18 Jan 2013 13:27:25 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Theodore Ts'o" <tytso@mit.edu>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Alexander Beregalov <a.beregalov@gmail.com>,
        Zheng Liu <wenqing.lz@taobao.com>
Subject: Re: [ 36/71] ext4: lock i_mutex when truncating orphan inodes
Message-ID: <20130118212725.GC13225@kroah.com>
References: <20130115225340.367496998@linuxfoundation.org>
 <20130115225343.033036403@linuxfoundation.org>
 <20130117200710.GD2872@herton-Z68MA-D2H-B3>
 <20130118004616.GA5730@kroah.com>
 <20130118034747.GF2872@herton-Z68MA-D2H-B3>
 <20130118035650.GA13785@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130118035650.GA13785@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 10:56:50PM -0500, Theodore Ts'o wrote:
> On Fri, Jan 18, 2013 at 01:47:48AM -0200, Herton Ronaldo Krzesinski wrote:
> > > > By the description and looking at commit c278531d39, this change isn't
> > > > needed for 3.0 or 3.4 kernels (anything <= 3.6), they don't contain
> > > > commit c278531d39.
> > > 
> > > Ah, good catch.  Should this be reverted from 3.0 and 3.4?
> > 
> > I judge it as unecessary from what I saw so far, can ext4 developers
> > and/or people in Cc confirm? It should be harmless, only consequence is
> > an uneeded lock being taken now in 3.0/3.4
> 
> It's not worth it to revert it.  The lock is being taken in a
> completely non-fastpath, as well as guaranteed-to-be non-contended
> code path.
> 
> We're not requiring that the lock be taken in 3.0 and 3.4, but
> arguably it's still a good idea to take it from a consistency point of
> view.

Thanks for letting me know, I'll just leave it for now.

greg k-h
