Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696Ab3HSVnA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 17:43:00 -0400
Received: from smtp103.biz.mail.bf1.yahoo.com ([98.139.221.62]:35561 "HELO
	smtp103.biz.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751479Ab3HSVm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 17:42:58 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: NMginqIVM1kYoD0yzrYvm8WGH.tlYXEJNIh0_GilezgJmNz
 m0TpIV29zkx_xm1QFXYzxsLzn1psHPsuPNuemVT0ynAqrDhPSOjXm67qoKr6
 0pp8CusvB6gBjiq7lX9sK9AnFy9.Xy9x87eHW8RehWMN2gmIBMwbqgrn8GcZ
 NQRl9DwlcTJs18PXXKy4vFbZihR6UX1PoaMV56UEOvAO5_Y4qm81aOJJg5D5
 Wn20CbUJ9QfMybzlrgXRiR7YnzAFa27rfK3ehURP04X6I9ZyzOPLn7ITtwmE
 rF9sMOj6f76a9CRJi0FgFt3NZxxYpKsXoqNY743ZcTzzyE1Cxe.IRTIHiWua
 EirgDhbsgXxtU_7gb1awKvJDy8Q1_U1uOBuU9bBXqVnwYTS_9NQ8xpqea0zw
 Cth3xY7jNXFKV.E5sqMA22AbKygtrHqyQ_HdqxnVkbxXWiYD9ZIIm2GVx8pE
 cpMsi9OGKaEjvyjGrC3AtoByh90jcsE5TMah0gbfhlyN4f2vYVMq7nSGe3mc
 ewkayMPwdcbcAWEm_xs9DdieQXAgzlJFgPYu_tDNh
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.103] (casey@24.6.250.25 with )
        by smtp103.biz.mail.bf1.yahoo.com with SMTP; 19 Aug 2013 14:42:57 -0700 PDT
Message-ID: <5212915F.20905@schaufler-ca.com>
Date: Mon, 19 Aug 2013 14:42:55 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: amwang@redhat.com, netdev@vger.kernel.org, james.l.morris@oracle.com,
        sds@tycho.nsa.gov, eparis@parisplace.org, pmoore@redhat.com,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [Patch net-next v3 9/9] selinux: use generic union inet_addr
References: <1376907278-26377-1-git-send-email-amwang@redhat.com> <1376907278-26377-10-git-send-email-amwang@redhat.com> <52127336.3080209@schaufler-ca.com> <20130819.125026.636442915180863272.davem@davemloft.net>
In-Reply-To: <20130819.125026.636442915180863272.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/19/2013 12:50 PM, David Miller wrote:
> It's so that you can pass a generic ipv4/ipv6 address blob into
> things like printf formatting, and since there is an address family
> member present, it knows what's in there and therefore one printf
> format specifier can handle both ipv4 and ipv6 addresses.

The patch message needs to say that, then.

> Like you, I think these changes a complete waste of time too, I'm just
> relaying what I was told.

Well, they certainly don't appear to add any value on their own.
I also generally oppose doing clever things with data structures.
I recently got bitten by the "obvious" relationships between
sockaddr, sockaddr_in and sockaddr_in6, and I've been doing this
stuff since before ioctl was invented.

