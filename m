Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565Ab3KHA4h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 19:56:37 -0500
Received: from intranet.asianux.com ([58.214.24.6]:63701 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756056Ab3KHA4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 19:56:35 -0500
X-Spam-Score: -100.8
Message-ID: <527C373F.5050009@asianux.com>
Date: Fri, 08 Nov 2013 08:58:39 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: josh@freedesktop.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] kernel/rcutorture.c: be sure of enough memory for
 result printing
References: <525C9256.5010002@asianux.com> <525C9FAE.4090209@asianux.com> <20131015082613.GG5790@linux.vnet.ibm.com> <525D35E9.3000604@asianux.com> <20131015144732.GG9150@linux.vnet.ibm.com> <525DF4F0.3070901@asianux.com> <525F3830.2060001@asianux.com> <5264C0DD.9060006@asianux.com> <20131106203859.GO18245@linux.vnet.ibm.com> <527AFB41.5050803@asianux.com> <20131107205930.GV18245@linux.vnet.ibm.com>
In-Reply-To: <20131107205930.GV18245@linux.vnet.ibm.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2013 04:59 AM, Paul E. McKenney wrote:
> On Thu, Nov 07, 2013 at 10:30:25AM +0800, Chen Gang wrote:
>> > If the contents is more than 4096 bytes (e.g. if have 1K cpus), current
>> > sprintf() will cause memory overflow. And this fix patch is to be sure
>> > of memory large enough.
>> > 
>> > Benefit:
>> > 
>> >  - do not truncate printing contents.
>> >  - extensible, it is large enough for printing various related contents.
>> >  - simple and clear enough for both source code readers and writers.
>> > 
>> > Shortcoming:
>> > 
>> >  - It will waste some memory:
>> > 
>> >     1 cpu now comsumes 50 - 60 bytes, and this patch provides 200 bytes.
>> >     global printing now comsumes a few KB, and this patch provide 8KB,
>> >     so for 1K cpus, it may waste 100 - 200 KB memory.
>> > 
>> >    after finish printing, it will free the related memory, quickly.
>> >    it is a test module, so wast a little memory for extensible is OK.
>> > 
>> > Related  test (Fedora16 2 CPUs, 2GB RAM x86_64)
>> > 
>> >  - as module, with/without "torture_type=srcu".
>> >  - build-in not boot runnable, with/without "torture_type=srcu".
>> >  - build-in let boot runnable, with/without "torture_type=srcu".
>> > 
>> > 
>> > Signed-off-by: Chen Gang <gang.chen@asianux.com>
> Thank you, queued for 3.14.

Thank you too.

-- 
Chen Gang
