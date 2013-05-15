Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932495Ab3EOIkc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 04:40:32 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:45931 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932478Ab3EOIka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 04:40:30 -0400
Message-ID: <519349F1.8050607@oracle.com>
Date: Wed, 15 May 2013 16:40:17 +0800
From: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Reply-To: zhenzhong.duan@oracle.com
Organization: oracle
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: Jan Beulich <JBeulich@suse.com>, xen-devel <xen-devel@lists.xen.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tamon Shiose <tamon.shiose@oracle.com>, Feng Jin <joe.jin@oracle.com>
Subject: Re: [Xen-devel] [PATCH-v2] xen: Don't call arch_trigger_all_cpu_backtrace
 in dom0(pvm)
References: <51610A25.4010301@oracle.com>  <5162911202000078000CB38E@nat28.tlf.novell.com> <1365525374.17014.22.camel@zakaz.uk.xensource.com>
In-Reply-To: <1365525374.17014.22.camel@zakaz.uk.xensource.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2013-04-10 00:36, Ian Campbell wrote:
> On Mon, 2013-04-08 at 08:42 +0100, Jan Beulich wrote:
>>>>> On 07.04.13 at 07:54, Zhenzhong Duan <zhenzhong.duan@oracle.com> wrote:
>>> nmi isn't supported in dom0, fallback to general all cpu backtrace code.
>> Since when is sending NMIs not supported, and since when is this
>> Dom0-specific? If you want to deal with this, you should do so
>> properly: Special case sending NMIs in the respective Xen specific
>> code (using VCPUOP_send_nmi), and carry this out in a way not
>> dependent upon running (un)privileged.
> You'd also need to implement the upcall support for receiving NMIs,
> which IIRC isn't yet done for pvops.
Hi Ian,

Could you give a suggestion on which file to change to support NMI upcall?
I compare with vMCE code, made similar change.
Use VCPUOP_send_nmi to send nmi between pvm guest vcpus, but nmi isn't 
triggered.

thanks
zduan
