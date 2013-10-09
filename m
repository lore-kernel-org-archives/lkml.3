Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953Ab3JIOPK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 10:15:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52898 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752198Ab3JIOPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 10:15:08 -0400
Message-ID: <52556486.9080109@zytor.com>
Date: Wed, 09 Oct 2013 07:13:26 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130923 Thunderbird/17.0.9
MIME-Version: 1.0
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
CC: Dave Anderson <anderson@redhat.com>, Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        kernel-hardening@lists.openwall.com, Aaron Durbin <adurbin@google.com>,
        Eric Northup <digitaleric@google.com>, Julien Tinnes <jln@google.com>,
        Will Drewry <wad@google.com>, Mathias Krause <minipli@googlemail.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        "Discussion list for crash utility usage, maintenance and development" 
	<crash-utility@redhat.com>
Subject: Re: [PATCH 6/7] x86, kaslr: report kernel offset on panic
References: <1380656245-29975-1-git-send-email-keescook@chromium.org> <CAGXu5jLVt13p2X2e1C3ha1izg6U6wbmgSyYW1wa+X4cW8aCFug@mail.gmail.com> <524BE3C5.2070302@jp.fujitsu.com> <524CBB70.2060809@jp.fujitsu.com> <1408843968.872421.1380808038820.JavaMail.root@redhat.com> <52521566.20402@jp.fujitsu.com> <1678208981.2178058.1381152105871.JavaMail.root@redhat.com> <5253D5E4.7060004@jp.fujitsu.com> <391752872.2807845.1381239492989.JavaMail.root@redhat.com> <52552A2A.8030505@jp.fujitsu.com>
In-Reply-To: <52552A2A.8030505@jp.fujitsu.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2013 03:04 AM, HATAYAMA Daisuke wrote:
>>>
>>> Sorry, I don't understand why relocation size cannot be calculated when
>>> CONFIG_PHYSICALSTART > CONFIG_PHYSICAL_ALIGN. Could you explain that?
>>
>> I just meant that when CONFIG_PHYSICAL_START > CONFIG_PHYSICAL_ALIGN,
>> the 32-bit x86 kernel
>> gets relocated (like the secondary kdump kernel), but that information
>> is not readily available
>> from the vmlinux/vmcore pair.
>>
> 
> My understanding on CONFIG_PHYSICAL_ALIGN was that starting address of
> kernel text area
> is always rounded up to CONFIG_PHYSICAL_ALIGN, only. Your explanation
> would be part I don't
> understand well. I'll reconsider it locally...
> 

If CONFIG_PHYSICAL_START == CONFIG_PHYSICAL_ALIGN, then it is very
likely that the kernel (in the absence of kASLR) will be run at the
CONFIG_PHYSICAL_START address, as the initial loading address, usually 1
MB, will be rounded up to CONFIG_PHYSICAL_ALIGN.

Since CONFIG_PHYSICAL_START is the unrelocated linking address, they end
up matching.

	-hpa


