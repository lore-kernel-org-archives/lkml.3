Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935400Ab3DPB35 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 21:29:57 -0400
Received: from ozlabs.org ([203.10.76.45]:37494 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934897Ab3DPB3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 21:29:55 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>,
        Kent Overstreet <koverstreet@google.com>
Cc: linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, lsf-pc@lists.linux-foundation.org,
        Zach Brown <zab@redhat.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        Jens Axboe <axboe@kernel.dk>,
        Asai Thambi S P <asamymuthupa@micron.com>,
        Selvan Mani <smani@micron.com>, Sam Bradshaw <sbradshaw@micron.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Benjamin LaHaise <bcrl@kvack.org>,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: New AIO API
In-Reply-To: <20130415153113.e91625d754cb60c73e60abff@linux-foundation.org>
References: <20130412222856.GB31761@localhost> <20130415153113.e91625d754cb60c73e60abff@linux-foundation.org>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Tue, 16 Apr 2013 10:48:35 +0930
Message-ID: <87sj2r6zo4.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:
> On Fri, 12 Apr 2013 15:28:56 -0700 Kent Overstreet <koverstreet@google.com> wrote:
>> Those are the main changes (besides adding attributes, of course) that
>> I've made so far. 
>> 
>>  * Get rid of the parallel syscall interface 
>> 
>>    AIO really shouldn't be implementing its own slightly different
>>    syscalls; it should be a mechanism for doing syscalls asynchronously.
>
> Yes.  We got about a twelfth of the way there many years ago
> (google("syslets")) but it died.  A shame.

Yeah, letting the current process keep waiting and creating a new one
which returns is a fascinating idea, but you really need to swizzle the
PIDs so that the "new" one is identical to the old.  Otherwise the API
is unbearable...

Good luck!
Rusty.
