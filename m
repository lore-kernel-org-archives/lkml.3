Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932526Ab3KOFrP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 00:47:15 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57968 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758428Ab3KOFqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 00:46:04 -0500
Date: Fri, 15 Nov 2013 13:13:24 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peng Tao <bergwolf@gmail.com>
Cc: linux-kernel@vger.kernel.org, "John L. Hammond" <john.hammond@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: Re: [PATCH 05/40] staging/lustre: validate open handle cookies
Message-ID: <20131115041324.GA28088@kroah.com>
References: <1384445622-12346-1-git-send-email-bergwolf@gmail.com>
 <1384445622-12346-6-git-send-email-bergwolf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384445622-12346-6-git-send-email-bergwolf@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 12:13:07AM +0800, Peng Tao wrote:
> From: "John L. Hammond" <john.hammond@intel.com>
> 
> Add a const void *h_owner member to struct portals_handle. Add a const
> void *owner parameter to class_handle2object() which must be matched
> by the h_owner member of the handle in addition to the cookie.

Ick ick ick.

NEVER use a void pointer if you can help it, and for a "handle", never.
This isn't other operating systems, sorry.  We know what types our
pointers to structures are, use them, so that the compiler can catch our
problems, and don't try to cheat by using void *.

> Adjust
> the callers of class_handle2object() accordingly, using NULL as the
> argument to the owner parameter, except in the case of
> mdt_handle2mfd() where we add an explicit mdt_export_data parameter
> which we use as the owner when searching for a MFD. When allocating a
> new MFD, pass a pointer to the mdt_export_data into mdt_mfd_new() and
> store it in h_owner. This allows the MDT to validate that the client
> has not sent the wrong open handle cookie, or sent the right cookie to
> the wrong MDT.

This changelog entry doesn't even match up with the code below.  ALl
callers of class_handle2object are passing NULL here, which makes this
patch pretty pointless, right?

And that's a _very_ generic global symbol name, please don't do that, it
needs to be "lustre_*" at the front to even expect it to be acceptable.

thanks,

greg k-h
