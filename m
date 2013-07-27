Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751632Ab3G0T35 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 15:29:57 -0400
Received: from relay.parallels.com ([195.214.232.42]:55218 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161Ab3G0T34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 15:29:56 -0400
Message-ID: <51F41FA0.6060205@parallels.com>
Date: Sat, 27 Jul 2013 23:29:36 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Cyrill Gorcunov <gorcunov@gmail.com>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] mm: Save soft-dirty bits on file pages
References: <20130726201807.GJ8661@moon> <CALCETrUJa-Y40vnb6YOPry0dCXb3zCQ0y19i2yHWdzKR75HUzg@mail.gmail.com>
In-Reply-To: <CALCETrUJa-Y40vnb6YOPry0dCXb3zCQ0y19i2yHWdzKR75HUzg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [89.169.95.100]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2013 12:55 AM, Andy Lutomirski wrote:
> On Fri, Jul 26, 2013 at 1:18 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>> Andy reported that if file page get reclaimed we loose soft-dirty bit
>> if it was there, so save _PAGE_BIT_SOFT_DIRTY bit when page address
>> get encoded into pte entry. Thus when #pf happens on such non-present
>> pte we can restore it back.
>>
> 
> Unless I'm misunderstanding this, it's saving the bit in the
> non-present PTE.  This sounds wrong -- what happens if the entire pmd
> (or whatever the next level is called) gets zapped?  (Also, what
> happens if you unmap a file and map a different file there?)

The whole pte gets zapped on vma unmap, and in this case forgetting
the soft-dirty bit completely is OK.

> --Andy
> .
> 


