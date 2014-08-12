Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039AbaHLGbd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 02:31:33 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:51628 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbaHLGbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 02:31:31 -0400
Date: Mon, 11 Aug 2014 23:31:26 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Sanjeev Sharma <sanjeev_sharma@mentor.com>, hdegoede@redhat.com,
        kraxel@redhat.com, mdharm-usb@one-eyed-alien.net,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2] uas: replace WARN_ON_ONCE() with lockdep_assert_held()
Message-ID: <20140812063126.GA9075@roeck-us.net>
References: <1407823717-17265-1-git-send-email-sanjeev_sharma@mentor.com>
 <20140812060153.GB13231@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140812060153.GB13231@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 02:01:53PM +0800, Greg KH wrote:
> On Tue, Aug 12, 2014 at 11:38:37AM +0530, Sanjeev Sharma wrote:
> > spin_is_locked() always return false in uniprocessor configuration and therefore it
> > would be advise to replace with lockdep_assert_held().
> 
> Add "on some architectures" in here somewhere, as it's not broken on the
> large majority of UP cpus :)
> 
FWIW, it is confirmed broken on mips (32 and 64 bit), ppc, and sparc64.
I have not tested on x86. Might be worth trying. arm64 seems to be ok,
unless I did something wrong in my test, as well as at least some of
the architectures which don't support smp to start with (such as sparc32
or microblaze).

Guenter
