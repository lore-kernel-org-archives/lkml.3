Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421Ab3DVOW3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 10:22:29 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:21098 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837Ab3DVOW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 10:22:28 -0400
Date: Mon, 22 Apr 2013 17:22:18 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Shankar Brahadeeswaran <shankoo77@gmail.com>
Cc: Robert Love <rlove@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Bjorn Bringert <bringert@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>, devel@driverdev.osuosl.org,
        Hugh Dickins <hughd@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, anjanavk12@gmail.com
Subject: Re: [BUG] staging: android: ashmem: Deadlock during ashmem_shrink
Message-ID: <20130422142218.GA26760@mwanda>
References: <CAJsYZ5kk=J_Sc7w5dbMbkWWv8dXEU0ojKjEKNqH=Q6Tf2f7mQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJsYZ5kk=J_Sc7w5dbMbkWWv8dXEU0ojKjEKNqH=Q6Tf2f7mQg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Read Al's email again:  https://lkml.org/lkml/2013/3/20/458

I don't know much about VFS locking, but the ashmem locking seems
pretty bogus to me.  Why can't multiple threads read() at the same
time?

One thing is that it should probably be broken into different locks
instead of a mini-BKL.  Instead of taking a bad design and trying to
hack it until it doesn't crash I think it would be better to redo
the locking from scratch.

regards,
dan carpenter

