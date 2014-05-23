Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825AbaEWPoG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 11:44:06 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:48807 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701AbaEWPoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 11:44:05 -0400
Message-ID: <537F6CC1.2000503@hp.com>
Date: Fri, 23 May 2014 08:44:01 -0700
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: =?UTF-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>,
        Jim Baxter <jim_baxter@mentor.com>
CC: David Miller <davem@davemloft.net>, eric.dumazet@gmail.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, kamal@canonical.com, edumazet@google.com,
        mszeredi@suse.cz, fw@strlen.de
Subject: Re: skbuff truesize incorrect.
References: <537E4AFD.20304@mentor.com> <1400792295.5367.174.camel@edumazet-glaptop2.roam.corp.google.com> <1400792601.5367.176.camel@edumazet-glaptop2.roam.corp.google.com> <20140522.171033.1040508444998374401.davem@davemloft.net> <87ppj5vupf.fsf@nemi.mork.no> <537F0DCA.6030901@mentor.com> <87vbsw4z5x.fsf@nemi.mork.no>
In-Reply-To: <87vbsw4z5x.fsf@nemi.mork.no>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2014 02:33 AM, Bjørn Mork wrote:
> Jim Baxter <jim_baxter@mentor.com> writes:
>
>>> I'll create and test a patch for the cdc_ncm host driver unless someone
>>> else wants to do that. I haven't really played with the gadget driver
>>> before, so I'd prefer if someone knowing it (Jim maybe?) could take care
>>> of it.  If not, then I can always make an attempt using dummy_hcd to
>>> test it.
>> I can create a patch for the host driver, I will issue the gadget patch
>> first to resolve any issues, the fix would be similar.
>
> Well, I couldn't help myself.  I just had to test it.  The attached
> patch works for me, briefly tested with an Ericsson H5321gw NCM device.
> I have no ideas about the performance impact as that modem is limited to
> 21 Mbps HSDPA.

If you are measuring performance with the likes of netperf, you should 
be able to get an idea of the performance effect from the change in 
service demand (CPU consumed per unit of work) even if the maximum 
throughput remains capped.

You can run a netperf TCP_STREAM test along the lines of:

netperf -H <otherguy> -c -C -t TCP_STREAM

and also

netperf -H <otherguy> -c -C -t TCP_RR

For extra added credit you can consider either multiple runs and 
post-processing, or adding a -i 30,3 to the command line to tell netperf 
to run at least three iterations, no more than thirty and it will try to 
achieve a 99% confidence that the reported means for throughput, local 
and remote CPU utilization are within +/- 2.5% of the actual mean.  You 
can narrow or widen that with a -I 99,<width>.  A width of 5% is what 
gives the +/- 2.5% (and/or demonstrates my lack of accurate statistics 
knowledge :) )

happy benchmarking,

rick jones

