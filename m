Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459Ab3JHASP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 20:18:15 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:47127 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591Ab3JHASM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 20:18:12 -0400
MIME-Version: 1.0
In-Reply-To: <1381191145.2081.230.camel@joe-AO722>
References: <1381184340-11190-1-git-send-email-geyslan@gmail.com>
	<1381185204.2081.221.camel@joe-AO722>
	<CAGG-pURYyCV4waC8Z+5qAd1mAB2ZHhEkRaGspFuyEDrvj_dTdQ@mail.gmail.com>
	<1381191145.2081.230.camel@joe-AO722>
Date: Mon, 7 Oct 2013 21:18:11 -0300
Message-ID: <CAGG-pUQJCGcY=hAobBodH-dTLLohUpe6KJbuMvwWkhdt3RSk+A@mail.gmail.com>
Subject: Re: [PATCH] 9p: unsigned/signed wrap in p9/unix modes.
From: =?UTF-8?Q?Geyslan_Greg=C3=B3rio_Bem?= <geyslan@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Eric Van Hensbergen <ericvh@gmail.com>, rminnich@sandia.gov,
        lucho@ionkov.net, v9fs-developer@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, kernel-br <kernel-br@googlegroups.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe,

Nice, I'll wait their reply, there are other p9 patches that I have
already sent and am awaiting Eric's.

Thank you again.

Geyslan Gregório Bem
hackingbits.com


2013/10/7 Joe Perches <joe@perches.com>:
> On Mon, 2013-10-07 at 21:09 -0300, Geyslan Gregório Bem wrote:
>> Joe,
>>
>> Thank you for reply.
>>
>> What do you think about:
>>
>>                  strncpy(ext, stat->extension, sizeof(ext));
>> +                 if (sscanf(ext, "%c %u %u", &type, &major, &minor) < 3) {
>> +                                  p9_debug(P9_DEBUG_ERROR,
>> +                                  "It's necessary define type, major
>> and minor values when using P9_DMDEVICE");
>> +                                  return res;
>> +                 }
>>                  switch (type) {
>>                  case 'c':
>>                          res |= S_IFCHR;
>>                          break;
>> ...
>>                  *rdev = MKDEV(major, minor);
>
> I think the plan 9 folk should figure out what's right.
>
>
