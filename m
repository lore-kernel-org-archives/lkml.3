Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166AbbAPKUD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 05:20:03 -0500
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:39793 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638AbbAPKUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 05:20:00 -0500
Message-ID: <54B8E5C9.5090006@linux.vnet.ibm.com>
Date: Fri, 16 Jan 2015 11:19:53 +0100
From: Laurent Dufour <ldufour@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Michael Ellerman <mpe@ellerman.id.au>,
        Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
CC: linuxppc-dev@lists.ozlabs.org, paulus@samba.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pseries/le: Fix another endiannes issue in RTAS call
 from xmon
References: <1421295950.11409.3.camel@ellerman.id.au> <1421342627-7214-1-git-send-email-ldufour@linux.vnet.ibm.com> <54B8188D.1060907@linux.vnet.ibm.com> <1421360377.23332.1.camel@ellerman.id.au> <54B85016.4080906@linux.vnet.ibm.com> <1421377361.18166.2.camel@ellerman.id.au>
In-Reply-To: <1421377361.18166.2.camel@ellerman.id.au>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15011610-0021-0000-0000-000002911FFF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/01/2015 04:02, Michael Ellerman wrote:
> On Thu, 2015-01-15 at 15:41 -0800, Tyrel Datwyler wrote:
>> On 01/15/2015 02:19 PM, Michael Ellerman wrote:
>> If this was on a powerkvm guest set-indicator should be present for
>> hotplug (DLPAR) support. However, the surveillance indicator would not
>> be implemented. I know sometimes I forget if I'm on a powervm or
>> powerkvm guest. Just a thought.
> 
> Right that does explain it. I went looking for the KVM kernel/qemu code that
> implements set-indicator but couldn't find it. Presumably it's in some branch
> other than the one I was looking at, or I was grepping for the wrong thing.
> 
> So I guess a printf there is probably not helpful, because it will fire always
> on PowerKVM (at least at the moment).

FWIW, the PAPR mentions that the surveillance indicator may not be
implemented. In that case -3 is returned.? I double checked that on my LPAR.

One option would be to warn only if the returned value is different from
0 and -3.

Cheers

