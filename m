Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147Ab3EMPXG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 11:23:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31069 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755051Ab3EMPXC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 11:23:02 -0400
Message-ID: <51910552.5050507@redhat.com>
Date: Mon, 13 May 2013 11:22:58 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Luiz Capitulino <lcapitulino@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, aquini@redhat.com,
        amit.shah@redhat.com, anton@enomsg.org
Subject: Re: [RFC 2/2] virtio_balloon: auto-ballooning support
References: <1368111229-29847-1-git-send-email-lcapitulino@redhat.com> <1368111229-29847-3-git-send-email-lcapitulino@redhat.com> <20130512143054.GI10144@redhat.com> <518FC4F9.5010505@redhat.com> <20130512184934.GA16334@redhat.com> <20130513110303.33dbaba6@redhat.com> <20130513151624.GB1992@redhat.com>
In-Reply-To: <20130513151624.GB1992@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2013 11:16 AM, Michael S. Tsirkin wrote:

> However, there's a big question mark: host specifies
> inflate, guest says deflate, who wins?

If we're dealing with a NUMA guest, they could both win :)

The host could see reduced memory use of the guest in one
place, while the guest could see increased memory availability
in another place...

I also suspect that having some "churn" could help sort out
exactly what the working set is.

> At some point Google sent patches that gave guest
> complete control over the balloon.
> This has the advantage that management isn't involved.

I believe the Google patches still included some way for the
host to initiate balloon inflation on the guest side, because
the guest internal state alone is not enough to see when the
host is under memory pressure.

I discussed the project with the Google developers in question
a little over a year ago, but I do not remember whether their
pressure notification went through qemu, or directly from the
host kernel to the guest kernel...

> And at some level it seems to make sense: why set
> an upper limit on size of the balloon?
> The bigger it is, the better.

Response time.

If too much of a guest's memory has been removed, it can take
too long for the guest to react to user requests, be it over
the web or ssh or something else...

-- 
All rights reversed
