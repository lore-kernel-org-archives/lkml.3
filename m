Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215AbaEOVnf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 17:43:35 -0400
Received: from mail-yh0-f43.google.com ([209.85.213.43]:45330 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755508AbaEOVnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 17:43:20 -0400
MIME-Version: 1.0
X-Originating-IP: [84.208.78.118]
In-Reply-To: <20140515143202.53ca8033@nehalam.linuxnetplumber.net>
References: <1399970908-9973-1-git-send-email-teg@jklm.no> <20140515143202.53ca8033@nehalam.linuxnetplumber.net>
From: Tom Gundersen <teg@jklm.no>
Date: Thu, 15 May 2014 23:42:58 +0200
Message-ID: <CAG-2HqWeJKbipVm+1oxKQYQfFyqu4SdSH15BP-4OAaUbJBCVdg@mail.gmail.com>
Subject: Re: [PATCH] net: tunnels - enable module autoloading
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Patrick McHardy <kaber@trash.net>, yoshfuji@linux-ipv6.org,
        jmorris@namei.org, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 11:32 PM, Stephen Hemminger
<stephen@networkplumber.org> wrote:
> On Tue, 13 May 2014 10:48:28 +0200
> Tom Gundersen <teg@jklm.no> wrote:
>
>> Enable the module alias hookup to allow tunnel modules to be autoloaded on demand.
>>
>> This is in line with how most other netdev kinds work, and will allow userspace
>> to create tunnels without having CAP_SYS_MODULE.
>>
>> Signed-off-by: Tom Gundersen <teg@jklm.no>
>> Tested-by: Susant Sahani <susant@redhat.com>
>> ---
>>  net/ipv4/ipip.c       | 1 +
>>  net/ipv6/ip6_tunnel.c | 1 +
>>  net/ipv6/sit.c        | 1 +
>>  3 files changed, 3 insertions(+)
>
> But tunnel modules are autoloaded now.
> If I create a tunnel with ip tunnel based on the existing MODULE_ALIAS_NETDEV().

Hm, please correct me if I'm wrong, but this only works if you create
a tunnel with one of the hardcoded tunnel names, right? And also, if I
read the code correctly, it only works if you use the ioctl interface
and not the rtnl interface?

What we'd like to do is to use the rtnl interface to create tunnels
with arbitrary names, is there a way this can already be done that I
have missed?

Cheers,

Tom
