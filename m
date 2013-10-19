Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab3JSS1t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 14:27:49 -0400
Received: from mout.gmx.net ([212.227.15.15]:54548 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752447Ab3JSS1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 14:27:46 -0400
Message-ID: <5262CF20.20301@gmx.de>
Date: Sat, 19 Oct 2013 20:27:44 +0200
From: Helge Deller <deller@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
CC: Linux Kernel Development <linux-kernel@vger.kernel.org>,
        NFS list <linux-nfs@vger.kernel.org>,
        linux-parisc <linux-parisc@vger.kernel.org>
Subject: Re: 3.12-rcX - NFS regression - kswapd0 / kswapd1 stays using 100%
 CPU?
References: <52604BA9.20104@gmx.de>		 <1382044045.3216.44.camel@leira.trondhjem.org> <52618B5F.4000508@gmx.de>	 <1382124981.20461.4.camel@leira.trondhjem.org> <5261940A.4090101@gmx.de> <1382127133.20461.9.camel@leira.trondhjem.org>
In-Reply-To: <1382127133.20461.9.camel@leira.trondhjem.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-7
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:9J74NhDL1uhEU60YTE1RYBzaa6lAg1v7KLQoHG/RO84bzXppcd1
 oyxBhapjqrX0aSmeT7UIfxXgYdAO2K/v6S0tehfuAd/+LB8OA5gVf1MWJ9b2zGhLIPWLZeB
 1j21wcyFUfe65bEmuWsPd0l/I4/YbTLDect/N/bCUCR7IsVPelFeXzpp6Klfpxxe9NArA1p
 j6EJw24WyqivMqRTDjAVw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2013 10:12 PM, Myklebust, Trond wrote:
> On Fri, 2013-10-18 at 22:03 +0200, Helge Deller wrote:
>> On 10/18/2013 09:36 PM, Myklebust, Trond wrote:
>>> Also, could you please try a sysRQ-t the next time it happens, so that
>>> we can get a trace of where the mount program is hanging. Knowing that
>>> the mount is stuck in "__schedule()" is not really interesting unless we
>>> know from where that was called.
>>
>> Actually, the machine was still running in this state.
>> Here is sysrq-t:
>> [112009.084000] mount           S 00000000401040c0     0 25331      1 0x00000010
>> [112009.084000] Backtrace:
>> [112009.084000]  [<0000000040113a68>] __schedule
>> [112009.232000]
>> [112009.232000] mount.nfs       D 00000000401040c0     0 25332  25331 0x00000010
>> [112009.232000] Backtrace:
>> [112009.232000]  [<0000000040113a68>] __schedule
> 
> That makes no sense unless sysrq-t works differently on parisc than on
> other platforms. I'd expect the backtrace to at least include a system
> call. Parisc experts?

sysrq-t doesn't work differently on parisc. For other processes I do get
a backtrace like the one on x86_64.
That's the main reason why I asked for ideas here on the list.
I do see the stuck process, but don't see any indications where it comes from.

Helge
