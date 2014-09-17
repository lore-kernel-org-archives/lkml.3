Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405AbaIQSC1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 14:02:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31068 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755391AbaIQSC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 14:02:26 -0400
Date: Wed, 17 Sep 2014 19:59:44 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roman Peniaev <r.peniaev@gmail.com>
Cc: Ming Lei <ming.lei@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] init: fix race between rootfs mount and firmware
	loading
Message-ID: <20140917175944.GD19308@redhat.com>
References: <1410792308-21577-1-git-send-email-r.peniaev@gmail.com> <20140915163935.GB22768@redhat.com> <CACZ9PQXJzoczS7gN5UCFygTHrLW5Rtjew5BF-txfL=cryE331w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACZ9PQXJzoczS7gN5UCFygTHrLW5Rtjew5BF-txfL=cryE331w@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17, Roman Peniaev wrote:
>
> On Tue, Sep 16, 2014 at 1:39 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> > On 09/15, Roman Pen wrote:
> >>
> >
> > Otherwise wait_for_rootfs() can return only once, the next call will block
> > forever. And perhaps it would be better to use another primitive, even if
> > UINT_MAX/2 should be enough.
>
> And why do you think completion is not good for this?
> Seems it is impossible to have so many threads on early init, which wait
> for rootfs.

Yes, but it is not only called during init? Suppose that a user does
insmod + rmmod in a loop, and the driver calls request_firmware(). This
will hang after UINT_MAX/2 iterations. Sure, this can't happen in practice,
but still this doesn't look good imho.

Oleg.

