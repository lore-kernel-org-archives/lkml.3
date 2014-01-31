Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932258AbaAaA5q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 19:57:46 -0500
Received: from mail-bk0-f49.google.com ([209.85.214.49]:57813 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137AbaAaA5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 19:57:44 -0500
MIME-Version: 1.0
X-Originating-IP: [109.128.142.46]
In-Reply-To: <20140130142740.GC2185@casper.infradead.org>
References: <1391087144-24490-1-git-send-email-teg@jklm.no> <20140130142740.GC2185@casper.infradead.org>
From: Tom Gundersen <teg@jklm.no>
Date: Fri, 31 Jan 2014 01:57:23 +0100
Message-ID: <CAG-2HqUdAZO0X7+D=4fQmjnb7eZUigS5OnABT2fXL=gKL6jRzg@mail.gmail.com>
Subject: Re: [PATCH] rtnetlink: return the newly created link in response to newlink
To: Thomas Graf <tgraf@suug.ch>
Cc: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        John Fastabend <john.r.fastabend@intel.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

Thanks for your reply.

On Thu, Jan 30, 2014 at 3:27 PM, Thomas Graf <tgraf@suug.ch> wrote:
> On 01/30/14 at 02:05pm, Tom Gundersen wrote:
>> Userspace needs to reliably know the ifindex of the netdevs it creates,
>> as we cannot rely on the ifname staying unchanged.
>>
>> Earlier, a simlpe NLMSG_ERROR would be returned, but this returns the
>> corresponding RTM_NEWLINK on success instead.
>
> This breaks existing Netlink applications in user space. User space
> apps are not prepared to receive both a RTM_NEWLINK reply _and_
> the ACK unless they have set NLM_F_ECHO in the original request.
>
> You can already reliably retrieve the ifindex by listening to
> RTNLGRP_LINK messages and be notified about the link created
> including all follow-up renames.

Ok, we'll keep doing this instead.

Cheers,

Tom
