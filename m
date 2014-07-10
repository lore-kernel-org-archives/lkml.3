Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842AbaGJKrU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 06:47:20 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:56202 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbaGJKrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 06:47:19 -0400
MIME-Version: 1.0
X-Originating-IP: [84.208.72.173]
In-Reply-To: <1404982886.30660.4.camel@hastur.hellion.org.uk>
References: <1404980258-30853-1-git-send-email-teg@jklm.no>
 <1404980258-30853-16-git-send-email-teg@jklm.no> <1404982886.30660.4.camel@hastur.hellion.org.uk>
From: Tom Gundersen <teg@jklm.no>
Date: Thu, 10 Jul 2014 12:46:58 +0200
Message-ID: <CAG-2HqV+suLoSnge4dG4HUPbAS6EqC9rjy0W9G9AZqaVgRFF+A@mail.gmail.com>
Subject: Re: [PATCH v7 15/33] net: xen-netback - set name assign type
To: Ian Campbell <ian.campbell@citrix.com>
Cc: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        David Herrmann <dh.herrmann@gmail.com>, Kay Sievers <kay@vrfy.org>,
        Wei Liu <wei.liu2@citrix.com>,
        xen-devel <xen-devel@lists.xenproject.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 11:01 AM, Ian Campbell <ian.campbell@citrix.com> wrote:
> On Thu, 2014-07-10 at 10:17 +0200, Tom Gundersen wrote:
>> The name contains then xen handle, which is not guaranteed to be
>> stable between restarts, so label this NET_NAME_ENUM.
>
> FWIW the N'th interface for domain with domid D will always be named
> vifD.N.
>
> If you reboot domain D then it's domid will change to E and the new
> device will be vifE.N.
>
> I don't know if that counts as predictable as far as the interface you
> are introducing is concerned.

That was my understanding, thanks for confirming.

The idea is that the same interface on the same machine must get the
same name between reboots in order to be considered predictable. So
under the assumption that a rebooted domain should be considered "the
same machine" (i.e., it still has the same local configuration,
possibly referencing the interface names), then we should consider the
names not predictable, so NET_NAME_ENUM.

Cheers,

Tom
