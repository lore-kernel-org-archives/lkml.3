Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722AbaGaR6P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 13:58:15 -0400
Received: from smtp.citrix.com ([66.165.176.89]:59427 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316AbaGaR6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 13:58:13 -0400
X-IronPort-AV: E=Sophos;i="5.01,773,1400025600"; 
   d="scan'208";a="157616638"
Message-ID: <53DA83B3.5050406@citrix.com>
Date: Thu, 31 Jul 2014 18:58:11 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: George Dunlap <George.Dunlap@eu.citrix.com>
CC: Ian Campbell <Ian.Campbell@citrix.com>,
        Frediano Ziglio <frediano.ziglio@citrix.com>,
        xen-devel <xen-devel@lists.xenproject.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        <linux-api@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 1/2] xen: Implement ioctl to restrict privcmd
 to a specific domain
References: <E1XCqEY-0005zn-RQ@lists.xen.org>	<1406814787.10395.2.camel@kazak.uk.xensource.com>	<E1XCr4p-0007Nh-Qu@lists.xen.org> <CAFLBxZYnaeEGTbuU5QoKJOU62Ck9p_B53bjAd46Z7uVgOxXH8g@mail.gmail.com>
In-Reply-To: <CAFLBxZYnaeEGTbuU5QoKJOU62Ck9p_B53bjAd46Z7uVgOxXH8g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/07/14 18:49, George Dunlap wrote:
> On Thu, Jul 31, 2014 at 10:11 AM, David Vrabel <david.vrabel@citrix.com> wrote:
>> On 31/07/14 14:53, Ian Campbell wrote:
>>> On Thu, 2014-07-31 at 14:16 +0100, Frediano Ziglio wrote:
>>>
>>>>  include/xen/interface/domctl.h     | 1090 ++++++++++++++++++++++++++++++++++++
>>>
>>> domctl is an stable toolstack only hypervisor interface, so the kernel
>>> cannot use it because it would then break.
>>
>> Ok.  I guess we'll have to resurrect the idea to do something with XSM.
> 
> What kind of thing did you have in mind for XSM?

A multicall-like hypercall that has an additional parameter for a handle
to a XSM context to use for the contained hypercalls.

> In general it seems like allowing a vcpu to switch into an XSM label
> (not sure I've got the terminology right here) when it context
> switches into a particular process might be the most flexible way for
> that to work.

I think we want something than can a different policy on a per-fd basis.

David
