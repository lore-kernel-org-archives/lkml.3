Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab3CCDyH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 22:54:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42658 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752634Ab3CCDyG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 22:54:06 -0500
Message-ID: <5132C94B.5090701@zytor.com>
Date: Sat, 02 Mar 2013 19:53:47 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Ulrich Drepper <drepper@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: sendfile and EAGAIN
References: <CAOPLpQcs5GgVRqXhnxF0Ui0k-39-xX5N2nYWYY4DhVWMYCMQ7w@mail.gmail.com>
In-Reply-To: <CAOPLpQcs5GgVRqXhnxF0Ui0k-39-xX5N2nYWYY4DhVWMYCMQ7w@mail.gmail.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/2013 09:22 AM, Ulrich Drepper wrote:
> When using sendfile with a non-blocking output file descriptor for a
> socket the operation can cause a partial write because of capacity
> issues.  This is nothing critical and the operation could resume after
> the output queue is cleared.  The problem is: there is no way to
> determine where to resume.
> 
> The system call just returns -EAGAIN without any further indication.
> The caller doesn't know what to resend.

This is IMO just a bug.  EAGAIN should only be used in the zero-byte
case and in other cases it should return the number of bytes
transferred, just like all the read/write system calls.

This was clearly also the intent.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

