Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525Ab3CZSY2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 14:24:28 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:57644 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751718Ab3CZSY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 14:24:27 -0400
X-Sasl-enc: MWv6k3gAEt+ZPO3JiL6393AtXLKMJkaZCQOz6m1+wzCY 1364322258
Message-ID: <5151E77F.3050201@ladisch.de>
Date: Tue, 26 Mar 2013 19:22:55 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firewire: Enable physical DMA above 4GB
References: <1364307734-27709-1-git-send-email-peter@hurleysoftware.com>	 <5151C90A.5010108@ladisch.de> <1364317476.3866.4.camel@thor.lan>
In-Reply-To: <1364317476.3866.4.camel@thor.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Hurley wrote:
> On Tue, 2013-03-26 at 17:12 +0100, Clemens Ladisch wrote:
>> Peter Hurley wrote:
>>> Write the PhyUpperBound register with the end-of-memory value. If
>>> end-of-memory is beyond the OHCI limit of 0x0000ffff00000000,
>>> clamp to that value.
>>
>> You will have to lower this limit; there are protcols that assume that
>> addresses like 0xecc000000000 are available for software.
>
> Maybe 0x0000e80000000000 is a better maximum upper bound?

Why the space of 0x04c000000000?  ;-)

There's also 0xc007dedadada (although this address isn't used on the PC
side).  Maybe we should just round down to 0x800000000000 and revisit
the question when there are 256 TB memory machines.  (Directly accessing
the full 256 TB will not be possible in any case.)


Regards,
Clemens
