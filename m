Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666Ab3JSRgm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 13:36:42 -0400
Received: from mail-qe0-f44.google.com ([209.85.128.44]:53067 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381Ab3JSRgl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 13:36:41 -0400
References: <CAGG-pUTXC+6O-wyYp0FZxKH-XWqP++jLEn-Km5kixQFcKsWRZA@mail.gmail.com> <CAGG-pUT=qrYxOQ5jeU=9KipYO+MAA9oJj=241YMqo54S7K+xsA@mail.gmail.com>
In-Reply-To: <CAGG-pUT=qrYxOQ5jeU=9KipYO+MAA9oJj=241YMqo54S7K+xsA@mail.gmail.com>
Mime-Version: 1.0 (1.0)
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
	charset=utf-8
Message-Id: <DA7AE80C-302D-4B9D-9C0E-BA980E25DFCE@gmail.com>
Cc: Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
X-Mailer: iPad Mail (10B329)
From: Vlad Yasevich <vyasevich@gmail.com>
Subject: Re: net: sctp: possible dereference after freeing
Date: Sat, 19 Oct 2013 13:36:35 -0400
To: =?utf-8?Q?Geyslan_Greg=C3=B3rio_Bem?= <geyslan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Oct 19, 2013, at 7:49 AM, Geyslan Gregório Bem <geyslan@gmail.com> wrote:

> 2013/10/19 Geyslan Gregório Bem <geyslan@gmail.com>:
>> Hi maintainers,
>> 
>> I would like to know if these are catches:
>> 
>> /net/sctp/endpointola.c (281)
>> static void sctp_endpoint_destroy(struct sctp_endpoint *ep)
>> {
>>    struct sock *sk;
>> ...
>>    kfree(ep);
>>    SCTP_DBG_OBJCNT_DEC(ep);
>> }
>> 
>> The 'ep' object counter is being decremented?! Is the kfree to be there indeed?
>> Let me know what was intended here.
>> 
>> Same here:
>> /net/sctp/endpointola.c (165)
>> static void sctp_transport_destroy_rcu(struct rcu_head *head)
>> {
>>    struct sctp_transport *transport;
>> ...
>>    kfree(transport);
>>    SCTP_DBG_OBJCNT_DEC(transport);
>> }
>> 
>> Regards,
>> 
>> Geyslan Gregório Bem
>> hackingbits.com
> 
> Oops. I got it. ;)
> 
> extern atomic_t sctp_dbg_objcnt_ep;
> http://lxr.free-electrons.com/source/include/net/sctp/sctp.h#L269
> extern atomic_t sctp_dbg_objcnt_transport;
> http://lxr.free-electrons.com/source/arch/x86/include/asm/atomic.h#L105
> 
> Cheers.

There is no reference here since the macro turns variable name to string using ## name.
So the order doesn't matter really.

-vlad 