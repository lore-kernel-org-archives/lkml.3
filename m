Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823Ab3ARDr4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 22:47:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45225 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798Ab3ARDrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 22:47:55 -0500
Date: Fri, 18 Jan 2013 01:47:48 -0200
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Alexander Beregalov <a.beregalov@gmail.com>,
        Theodore Tso <tytso@mit.edu>, Zheng Liu <wenqing.lz@taobao.com>
Subject: Re: [ 36/71] ext4: lock i_mutex when truncating orphan inodes
Message-ID: <20130118034747.GF2872@herton-Z68MA-D2H-B3>
References: <20130115225340.367496998@linuxfoundation.org>
 <20130115225343.033036403@linuxfoundation.org>
 <20130117200710.GD2872@herton-Z68MA-D2H-B3>
 <20130118004616.GA5730@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130118004616.GA5730@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 04:46:16PM -0800, Greg Kroah-Hartman wrote:
> On Thu, Jan 17, 2013 at 06:07:11PM -0200, Herton Ronaldo Krzesinski wrote:
> > On Tue, Jan 15, 2013 at 02:54:33PM -0800, Greg Kroah-Hartman wrote:
> > > 3.0-stable review patch.  If anyone has any objections, please let me know.
> > > 
> > > ------------------
> > > 
> > > From: Theodore Ts'o <tytso@mit.edu>
> > > 
> > > commit 721e3eba21e43532e438652dd8f1fcdfce3187e7 upstream.
> > > 
> > > Commit c278531d39 added a warning when ext4_flush_unwritten_io() is
> > > called without i_mutex being taken.  It had previously not been taken
> > > during orphan cleanup since races weren't possible at that point in
> > > the mount process, but as a result of this c278531d39, we will now see
> > > a kernel WARN_ON in this case.  Take the i_mutex in
> > > ext4_orphan_cleanup() to suppress this warning.
> > > 
> > > Reported-by: Alexander Beregalov <a.beregalov@gmail.com>
> > > Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> > > Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > By the description and looking at commit c278531d39, this change isn't
> > needed for 3.0 or 3.4 kernels (anything <= 3.6), they don't contain
> > commit c278531d39.
> 
> Ah, good catch.  Should this be reverted from 3.0 and 3.4?

I judge it as unecessary from what I saw so far, can ext4 developers
and/or people in Cc confirm? It should be harmless, only consequence is
an uneeded lock being taken now in 3.0/3.4

> 
> thanks,
> 
> greg k-h
> 

-- 
[]'s
Herton
