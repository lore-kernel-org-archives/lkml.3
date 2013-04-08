Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935514Ab3DHSUp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 14:20:45 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:42730 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934794Ab3DHSUo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 14:20:44 -0400
Date: Mon, 08 Apr 2013 13:14:13 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH] driver core: add uid and gid to devtmpfs
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay@vrfy.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
In-Reply-To: <20130406165600.GA29660@kroah.com> (from
	gregkh@linuxfoundation.org on Sat Apr  6 11:56:00 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1365444853.18069.51@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2013 11:56:00 AM, Greg KH wrote:
> From: Kay Sievers <kay@vrfy.org>
> 
> Some drivers want to tell userspace what uid and gid should be used  
> for
> their device nodes, so allow that information to percolate through the
> driver core to userspace in order to make this happen.  This means  
> that
> some systems (i.e.  Android and friends) will not need to even run a
> udev-like daemon for their device node manager and can just rely in
> devtmpfs fully, reducing their footprint even more.

Wasn't the entire "devfsd" saga because this was policy and didn't  
belong in kernel space? I guess it's not policy if Android wants it?  
It's just The One True Way?

Or is this because containers allow UID/GID to be redefined, and thus  
imposing magic values on userspace can now be mapped away or something?

(I studied this fairly closely before writing busybox mdev way back,  
and I'm really not following the change in rationale here.)

Rob