Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874AbaHLFVd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 01:21:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16328 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736AbaHLFVc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 01:21:32 -0400
Message-ID: <53E9A450.7070608@redhat.com>
Date: Tue, 12 Aug 2014 07:21:20 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC: Benjamin Lee <leeben@linux.vnet.ibm.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dany@us.ibm.com, dany4madden@gmail.com, benjamin.fik.lee@gmail.com
Subject: Re: [PATCH] Made bpf_internal_load_pointer_neg_helper static: fixes
 Sparse warning
References: <1405708449.11800.2.camel@oc1318858833.ibm.com> <1407794456.12335.3.camel@oc1318858833.ibm.com> <CAADnVQKbYheiRF_fmUnUUfSQgxUupY5vrjcjwimwwy-gnGhz2w@mail.gmail.com>
In-Reply-To: <CAADnVQKbYheiRF_fmUnUUfSQgxUupY5vrjcjwimwwy-gnGhz2w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2014 02:57 AM, Alexei Starovoitov wrote:
> On Mon, Aug 11, 2014 at 3:00 PM, Benjamin Lee <leeben@linux.vnet.ibm.com> wrote:
>> I wanted to know what the current status of my patch is since my
>> internship will be ending this Friday and I want to know before then. if
>> there are any problems with it I can fix them before Thursday. Thank you
>> in advance.
>
> using scripts/get_maintainer.pl for cc list would have helped to
> receive response sooner.
>
>> On Fri, 2014-07-18 at 11:34 -0700, Benjamin Lee wrote:
>>> This patch fixes the following Sparse warning:
>>>
>>> net/core/filter.c:52:6: warning: symbol
>>> 'bpf_internal_load_pointer_neg_helper' was not declared. Should it be
>>> static?
>>>
>>> I declared bpf_internal_load_pointer_neg_helper as static because it
>>> is not referenced elsewhere in the kernel. The patched kernel boots
>
> the patch is incorrect, since this function is called out of assembler.
> Try 'git grep bpf_internal_load_pointer_neg_helper'

Agreed.
