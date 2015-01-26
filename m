Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519AbbAZUEI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 15:04:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44091 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbbAZUEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 15:04:05 -0500
Date: Mon, 26 Jan 2015 12:04:03 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Mandeep Sandhu <mandeep.sandhu@cyaninc.com>
Cc: hjk@hansjkoch.de, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/4] uio: Simplify the lifetime logic of struct
 uio_device.
Message-ID: <20150126200403.GA32312@kroah.com>
References: <1421434179-3650-1-git-send-email-mandeep.sandhu@cyaninc.com>
 <1421434179-3650-2-git-send-email-mandeep.sandhu@cyaninc.com>
 <20150125123316.GA9141@kroah.com>
 <CANg1-_CHd2hG=5Rw7pp8J9VXBYLs-6jZ71YMBBOGksdbAO0Zyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANg1-_CHd2hG=5Rw7pp8J9VXBYLs-6jZ71YMBBOGksdbAO0Zyw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 11:57:30AM -0800, Mandeep Sandhu wrote:
> >> +
> >> +     ret = kobject_set_name(&idev->device.kobj, "uio%d", idev->minor);
> >
> > dev_set_name()?
> 
> There's another instance of use of kobject_set_name in
> uio_major_init(). Should I change that too ,or that should be done in
> a new (unrelated) patch?

Unrelated please, one logical change per patch is the rules.
