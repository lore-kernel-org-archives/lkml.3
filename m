Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756975Ab3BRIyg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 03:54:36 -0500
Received: from chrocht.moloch.sk ([62.176.169.44]:38036 "EHLO mail.moloch.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756705Ab3BRIye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 03:54:34 -0500
Message-ID: <5121EC47.2080402@250bpm.com>
Date: Mon, 18 Feb 2013 09:54:31 +0100
From: Martin Sustrik <sustrik@250bpm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111109 Thunderbird/3.1.16
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Alexander Viro <viro@zeniv.linux.org.uk>,
        Sha Zhengju <handai.szj@taobao.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Davide Libenzi <davidel@xmailserver.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Eric Wong <normalperson@yhbt.net>
Subject: Re: [PATCH v2 1/1] eventfd: implementation of EFD_MASK flag
References: <1360311077-14474-1-git-send-email-sustrik@250bpm.com> <20130214145430.04f8750c.akpm@linux-foundation.org>
In-Reply-To: <20130214145430.04f8750c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/02/13 23:54, Andrew Morton wrote:

>> +/*  On x86-64 keep the same binary layout as on i386. */
>> +#ifdef __x86_64__
>> +#define EVENTFD_MASK_PACKED __packed
>> +#else
>> +#define EVENTFD_MASK_PACKED
>> +#endif
>> +
>> +struct eventfd_mask {
>> +	__u32 events;
>> +	__u64 data;
>> +} EVENTFD_MASK_PACKED;
>
> The x86-64 specific thing is ugly.  I can find no explanation of why it
> was done, but it should go away.  You could make `events' a u64, or
> swap the order of the two fields and make the struct __packed on all
> architectures.
>
> Given that the size of the types is fixed, I see no compat issues here.

I've just copied how the definition is done for epoll_event. The comment 
there goes like this:

/*
  * On x86-64 make the 64bit structure have the same alignment as the
  * 32bit structure. This makes 32bit emulation easier.
  *
  * UML/x86_64 needs the same packing as x86_64
  */

If you still think I should remove the #ifdef, I am happy to do so.

Martin
