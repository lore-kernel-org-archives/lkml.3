Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab3HAI3z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 04:29:55 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:43420 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744Ab3HAI3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 04:29:52 -0400
Date: Thu, 1 Aug 2013 01:29:51 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Colin Cross <ccross@google.com>
Cc: Christoph Hellwig <hch@infradead.org>, lkml <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>, libc-alpha@sourceware.org
Subject: Re: RFC: named anonymous vmas
Message-ID: <20130801082951.GA23563@infradead.org>
References: <CAMbhsRQU=xrcum+ZUbG3S+JfFUJK_qm_VB96Vz=PpL=vQYhUvg@mail.gmail.com>
 <20130622103158.GA16304@infradead.org>
 <CAMbhsRTz246dWPQOburNor2HvrgbN-AWb2jT_AEywtJHFbKWsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMbhsRTz246dWPQOburNor2HvrgbN-AWb2jT_AEywtJHFbKWsA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Btw, FreeBSD has an extension to shm_open to create unnamed but fd
passable segments.  From their man page:

    As a FreeBSD extension, the constant SHM_ANON may be used for the path
    argument to shm_open().  In this case, an anonymous, unnamed shared
    memory object is created.  Since the object has no name, it cannot be
    removed via a subsequent call to shm_unlink().  Instead, the shared
    memory object will be garbage collected when the last reference to the
    shared memory object is removed.  The shared memory object may be shared
    with other processes by sharing the file descriptor via fork(2) or
    sendmsg(2).  Attempting to open an anonymous shared memory object with
    O_RDONLY will fail with EINVAL. All other flags are ignored.

To me this sounds like the best way to expose this functionality to the
user.  Implementing it is another question as shm_open sits in libc,
we could either take it and shm_unlink to the kernel, or use O_TMPFILE
on tmpfs as the backend.
