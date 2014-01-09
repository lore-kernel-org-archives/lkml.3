Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341AbaAIUOS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 15:14:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52040 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756062AbaAIUOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 15:14:05 -0500
Date: Thu, 9 Jan 2014 12:14:36 -0800
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: KY Srinivasan <kys@microsoft.com>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: Re: [PATCH 1/1] Drivers: hv: Implement the file copy service
Message-ID: <20140109201436.GA16425@kroah.com>
References: <1389224915-8737-1-git-send-email-kys@microsoft.com>
 <20140109073949.GR30234@mwanda>
 <540ecdf5cf6b47d79583f4f97788e3f0@BY2PR03MB299.namprd03.prod.outlook.com>
 <20140109200921.GT30234@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140109200921.GT30234@mwanda>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 11:09:21PM +0300, Dan Carpenter wrote:
> We've had this discussion before where you urge me to trust the host...
> 
>  Problem: This code is racy.
> Solution: The host will only send one message at a time.
> 
> Now I have to audit the user space code on the host and I don't feel
> like doing that so you win.
> 
> I wish we had a better way to do IPC.  If kdbus were ready, that might
> have worked for this, and it's a better solution because both sender and
> reciever code will be written in a less trusting way.

kdbus is almost ready, it might make 3.15, depending on the result of
work that is happening at linux.conf.au and FOSDEM.

If it would be a better solution for this, that's even more reason to
get kdbus merged soon, no need to add something that doesn't really
work.

But, how will kdbus help with this?  It's a userspace <-> userspace
message transmission bus, would you want the kernel to be a receiver or
sender here?

thanks,

greg k-h
