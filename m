Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238Ab3EUIbm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 04:31:42 -0400
Received: from mga14.intel.com ([143.182.124.37]:14968 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797Ab3EUIbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 04:31:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,713,1363158000"; 
   d="scan'208";a="305577231"
Message-ID: <519B30CE.9020704@linux.intel.com>
Date: Tue, 21 May 2013 11:31:10 +0300
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Or Gerlitz <or.gerlitz@gmail.com>
CC: David Miller <davem@davemloft.net>, eilong@broadcom.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        jesse.brandeburg@intel.com, donald.c.skidmore@intel.com,
        e1000-devel@lists.sourceforge.net, willemb@google.com,
        andi@firstfloor.org, hpa@zytor.com, eliezer@tamir.org.il
Subject: Re: [PATCH v3 net-next 3/4] ixgbe: Add support for ndo_ll_poll
References: <CAJZOPZJx8vpSWqOhmN65gn=vi7hWXQO_J01+hAwGY9RwetX3DA@mail.gmail.com> <519B1A2B.4010909@linux.intel.com> <1369120003.25971.2.camel@lb-tlvb-eilong.il.broadcom.com> <20130521.001444.1361294042663568537.davem@davemloft.net> <CAJZOPZJTA9A8T4R8MtRCeqcYj3XJWFCXF+ojmEqza5TMj-6G+w@mail.gmail.com>
In-Reply-To: <CAJZOPZJTA9A8T4R8MtRCeqcYj3XJWFCXF+ojmEqza5TMj-6G+w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/05/2013 11:24, Or Gerlitz wrote:
> On Tue, May 21, 2013 at 10:14 AM, David Miller <davem@davemloft.net> wrote:
>> From: "Eilon Greenstein" <eilong@broadcom.com>
>> Date: Tue, 21 May 2013 10:06:43 +0300
>>
>>> Hopefully this series will be accepted so we can send follow up support
>>> for the bnx2x as well.
>>
>> I think in two or three more iterations it will be merged.
>>
>> There are no objections on the fundamentals, it's just implementation
>> details and coding style at this point.
>
> Dave, sorry, I might be a bit behind the rest of the reviewers, but I
> just fail to understand nor find any reference that explains the
> module param of ixgbe nor it makes sense to me to merge that piece of
> the code upstream (its not for staging, correct?), as I wrote here
> http://marc.info/?l=linux-netdev&m=136908123432072&w=2 basically, I
> know you're not a great fun of module params (to say the least) and
> surely not something named  "allow_unsafe_removal", thoughts?

from v2 0/4

6. To avoid the overhead of reference counting napi structs by skbs
and sockets in the fastpath, and increasing the size of the skb struct,
we no longer allow unloading the module once this feature has been used.

It seems that for most of the people interested in busy-polling, giving
up the ability to blindly remove the module for a slight but measurable
performance gain is a good tradeoff.
(There is a module parameter to override this behavior and if you know
what you are doing and are careful to stop the processes you can safely
unload, but we don't enforce this.)

