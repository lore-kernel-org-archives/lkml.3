Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760713AbaJ3PLo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 11:11:44 -0400
Received: from mail.efficios.com ([78.47.125.74]:37761 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760395AbaJ3PLm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 11:11:42 -0400
Date: Thu, 30 Oct 2014 15:11:36 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@linux.intel.com>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        lttng-dev <lttng-dev@lists.lttng.org>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>
Message-ID: <864133911.4806.1414681896478.JavaMail.zimbra@efficios.com>
In-Reply-To: <20141028105458.GA9768@node.dhcp.inet.fi>
References: <1254279794.1957.1414240389301.JavaMail.zimbra@efficios.com> <465653369.1985.1414241485934.JavaMail.zimbra@efficios.com> <20141028105458.GA9768@node.dhcp.inet.fi>
Subject: Re: Progress on system crash traces with LTTng using DAX and pmem
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [173.246.22.116]
X-Mailer: Zimbra 8.0.7_GA_6021 (ZimbraWebClient - FF32 (Linux)/8.0.7_GA_6021)
Thread-Topic: Progress on system crash traces with LTTng using DAX and pmem
Thread-Index: nJK2oOzjzWDWdtzR4jvZJFWqNfbeOA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Kirill A. Shutemov" <kirill@shutemov.name>
> To: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>
> Cc: "Matthew Wilcox" <willy@linux.intel.com>, "Ross Zwisler" <ross.zwisler@linux.intel.com>, "lttng-dev"
> <lttng-dev@lists.lttng.org>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
> Sent: Tuesday, October 28, 2014 6:54:58 AM
> Subject: Re: Progress on system crash traces with LTTng using DAX and pmem
> 
> On Sat, Oct 25, 2014 at 12:51:25PM +0000, Mathieu Desnoyers wrote:
> > FYI, the main reason why my customer wants to go with a
> > "trace into memory that survives soft reboot" approach
> > rather than to use things like kexec/kdump is that they
> > care about the amount of time it takes to reboot their
> > machines. They want a solution where they can extract the
> > detailed crash data after reboot, after the machine is
> > back online, rather than requiring a few minutes of offline
> > time to extract the crash details.
> 
> IIRC, on x86 there's no guarantee that your memory content will be
> preserved over reboot. BIOS is free to mess with it.

Hi Kirill,

This is a good point,

There are a few more aspects to consider here:

- Other architectures appear to have different guarantees, for
  instance ARM which, AFAIK, does not reset memory on soft
  reboot (well at least for my customer's boards). So I guess
  if x86 wants to be competitive, it would be good for them to
  offer a similar feature,

- Already having a subset of machines supporting this is useful,
  e.g. storing trace buffers and recovering them after a crash,

- Since we are in a world of dynamically upgradable BIOS, perhaps
  if we can show that there is value in having a BIOS option to
  specify a memory range that should not be reset on soft reboot,
  BIOS vendors might be inclined to include an option for it,

- Perhaps UEFI BIOS already have some way of specifying that a
  memory range should not be reset on soft reboot ?

Thoughts ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
