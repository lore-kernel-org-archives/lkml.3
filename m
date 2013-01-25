Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337Ab3AYJ0g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 04:26:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40981 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755006Ab3AYJ0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 04:26:31 -0500
Message-ID: <51024FB1.3000206@redhat.com>
Date: Fri, 25 Jan 2013 10:26:09 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, pmatouse@redhat.com,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 06/13] sg_io: whitelist a few more commands for multimedia
 devices
References: <1359039649-17734-1-git-send-email-pbonzini@redhat.com> <1359039649-17734-7-git-send-email-pbonzini@redhat.com> <20130124225555.GC2373@mtj.dyndns.org>
In-Reply-To: <20130124225555.GC2373@mtj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 24/01/2013 23:55, Tejun Heo ha scritto:
> On Thu, Jan 24, 2013 at 04:00:42PM +0100, Paolo Bonzini wrote:
>> Strangely, a couple of MMC commands were never included.  Add them too.
> 
> What are the justifications for adding these commands to the filter?
> Are there users requesting these?

I think it's the other way round.  What's the justification for leaving
them out, if they are in the standard?  Since we're touching the
commands for other standards, it's better to be complete for MMC as well.

At least one of them (MECHANISM STATUS) is implemented in both QEMU and
Bochs, so someone is using it.  If that someone were run virtualized,
with the host /dev/sr0 passed directly to the guest rather than
emulated, it would break.

Paolo

