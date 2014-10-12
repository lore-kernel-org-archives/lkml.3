Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903AbaJLTRN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 15:17:13 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35913 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562AbaJLTRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 15:17:10 -0400
Date: Sun, 12 Oct 2014 20:17:02 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: WANG Chao <wangchao19890207@gmail.com>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Masaru Nomura <massa.nomura@gmail.com>, Peng Tao <bergwolf@gmail.com>,
        Chi Pham <fempsci@gmail.com>,
        Fredrick John Berchmans <fredrickprashanth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH resend] staging, lustre: fix a sparse error
Message-ID: <20141012191702.GS7996@ZenIV.linux.org.uk>
References: <1412850311-5727-1-git-send-email-wangchao19890207@gmail.com>
 <20141009122831.GA3300@sudip-PC>
 <20141010032116.GC9352@dhcp-17-37.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141010032116.GC9352@dhcp-17-37.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2014 at 11:21:16AM +0800, WANG Chao wrote:

> I think __user annotation is for no dereferencing in kernel space. In
> this case, I think it's fine to override this error by __force. Because
> they're pointers with identical target types.

Umm...  The real question seems to be whether iovec is the right type in
the first place.  Does ->tx_iov ever contain a vector with _userland_
pointers?  If not, it ought to be struct kvec * instead.
