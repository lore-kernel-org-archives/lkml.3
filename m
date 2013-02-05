Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198Ab3BENWR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 08:22:17 -0500
Received: from merlin.infradead.org ([205.233.59.134]:47142 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686Ab3BENWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 08:22:15 -0500
Date: Tue, 5 Feb 2013 14:21:17 +0100
From: Jens Axboe <axboe@kernel.dk>
To: majianpeng <majianpeng@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: For the condition "file->f_mode", when it failed, it should
 return EACCES rather than EBADF.
Message-ID: <20130205132117.GU15092@kernel.dk>
References: <2013020410070150879010@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2013020410070150879010@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 03 2013, majianpeng wrote:
> Hi all,
> 	When I wanted to do discard operations,but i set the  openflag was O_RDONLY,it returned a EBADF rather than EACCES or EPERM.
> I searched the code and found:
> >case BLKDISCARD:
> >case BLKSECDISCARD: {
> >		uint64_t range[2];
> 
> >		if (!(mode & FMODE_WRITE))
> >			return -EBADF;
> Initial i thought there was error.But i searched all code of kernel and found some places like this.
> 
> The description of EBADF is "Bad file numbe". There are some places where returned EBADF like,
> >if (!f.file)
> >		return -EBADF;
> 
> So i think for checking file->f_mode when failed, it should return EACCESS.

But that would break the ABI at this point. I agree with you, though,
EBADF is not the right error for this case.

-- 
Jens Axboe

