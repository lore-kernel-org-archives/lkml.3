Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933521Ab3JPUif (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 16:38:35 -0400
Received: from sam.nabble.com ([216.139.236.26]:50512 "EHLO sam.nabble.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932336Ab3JPUie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 16:38:34 -0400
Date: Wed, 16 Oct 2013 13:38:30 -0700 (PDT)
From: Jim Mostek <jim.mostek@quantum.com>
To: linux-kernel@vger.kernel.org
Message-ID: <1381955910743-738511.post@n7.nabble.com>
In-Reply-To: <20060329155719.GA22092@zk3.dec.com>
References: <20060329155719.GA22092@zk3.dec.com>
Subject: Re: [PATCH] inotify: IN_DELETE events missing in -mm
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


You cannot move this line of code after dentry_iput(dentry); without
considerations for locking.

Another thread can get this dentry and be changing dentry->d_flags at the
same time!
We have hit this in testing. The code must be changed to have locks (if this
field needs to be changed or ...)

In our tests, the flag 0x10 in __d_drop goes missing because this line of
code executed at the same time on another processor.



--
View this message in context: http://linux-kernel.2935.n7.nabble.com/PATCH-inotify-IN-DELETE-events-missing-in-mm-tp105372p738511.html
Sent from the Linux Kernel mailing list archive at Nabble.com.
