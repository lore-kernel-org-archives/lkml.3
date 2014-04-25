Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763AbaDYTFr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 15:05:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56488 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752507AbaDYTFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 15:05:40 -0400
Date: Fri, 25 Apr 2014 21:05:32 +0200
From: Mateusz Guzik <mguzik@redhat.com>
To: Kumar Gaurav <kumargauravgupta3@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org
Subject: Re: Clarification needed on use of put_user inside a loop
Message-ID: <20140425190531.GD3636@mguzik.redhat.com>
References: <535A88D5.3030008@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <535A88D5.3030008@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 09:39:57PM +0530, Kumar Gaurav wrote:
> Hence when transferring data involves loops then checking permission
> (using access_ok()) once should be good to go then after we can
> simply transfer data using __put_user(), instead of using put_user()
> itself in loop.
> 

Well, I can't tell you whether this is a good idea, but:

This looks correct and other code is doing this already.

However, put_user calls might_fault, but __put_user consumers I found
(e.g. copy_siginfo_to_user) don't do that.

While it has only debugging purposes and would not change anything for
those consumers, it seems to be a bug to not include it.

Thus I suggest adding access_ok variant which calls might_fault.

-- 
Mateusz Guzik
