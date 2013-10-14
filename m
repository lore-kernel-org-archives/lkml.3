Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758673Ab3JNUv1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:51:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56989 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757423Ab3JNUtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:49:49 -0400
Message-ID: <525C58D3.1060705@zytor.com>
Date: Mon, 14 Oct 2013 13:49:23 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Zhang Yanfei <zhangyanfei.yes@gmail.com>, Tejun Heo <tj@kernel.org>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Toshi Kani <toshi.kani@hp.com>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH part2 v2 0/8] Arrange hotpluggable memory as ZONE_MOVABLE
References: <5258E560.5050506@cn.fujitsu.com> <525B19C3.9040907@gmail.com> <20131014133835.GG4722@htj.dyndns.org> <525BFCF3.5010908@gmail.com> <20131014142719.GI4722@htj.dyndns.org> <525C02DC.4050706@gmail.com> <20131014145131.GJ4722@htj.dyndns.org> <525C0866.2010808@gmail.com> <20131014151902.GL4722@htj.dyndns.org> <525C0EFE.2010409@gmail.com> <CAE9FiQX0xeR61ehPy2SfWfN-fgSZVS=dtaWT-QQ+RR12tx+A0w@mail.gmail.com> <525C55A6.1030406@zytor.com> <CAE9FiQUQaB2RAPyNjW8vF1uEigCEaxVFH1PBs=xgYNRRCpZPuw@mail.gmail.com>
In-Reply-To: <CAE9FiQUQaB2RAPyNjW8vF1uEigCEaxVFH1PBs=xgYNRRCpZPuw@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2013 01:42 PM, Yinghai Lu wrote:
>>
>> However, I don't understand how we can avoid #2, given that it is
>> fundamentally a sysadmin-driven tradeoff between performance and
>> reliability.
> 
> If we make all numa systems support nodes hot-remove logically.
> like we boot system with node0, and hot add other nodes one by one,
> we should hot remove them later.
> 

No, it doesn't work that way for memory.  You can't do nonmovable
allocations from a node that you may need to yank, unless you can
migrate that memory node transparently (which hardware can do.)

	-hpa


