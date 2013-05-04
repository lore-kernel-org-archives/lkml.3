Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759513Ab3EDWXd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 May 2013 18:23:33 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:43085 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757737Ab3EDWXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 May 2013 18:23:31 -0400
MIME-Version: 1.0
In-Reply-To: <CAOS58YO2b=zFGUVqrV1dHV6gDouNJpN2Wnwo_D6f5V7G9Wz9Vg@mail.gmail.com>
References: <1367458508-9133-1-git-send-email-ccross@android.com>
	<1367458508-9133-11-git-send-email-ccross@android.com>
	<20130503000812.GY19814@mtj.dyndns.org>
	<85487641.pdFCOjE3G7@vostro.rjw.lan>
	<CAOS58YO2b=zFGUVqrV1dHV6gDouNJpN2Wnwo_D6f5V7G9Wz9Vg@mail.gmail.com>
Date: Sat, 4 May 2013 15:23:30 -0700
X-Google-Sender-Auth: VIzG48fefBfJPQAsdTu-U2EB0ns
Message-ID: <CAMbhsRSm74tsqXT7TG1h8L1DoKQV0_wKd3asxvHPR7bttWkxag@mail.gmail.com>
Subject: Re: [PATCH v2 10/10] af_unix: use freezable blocking calls in read
From: Colin Cross <ccross@android.com>
To: Tejun Heo <tj@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Al Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Gao feng <gaofeng@cn.fujitsu.com>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 4, 2013 at 1:39 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello, Rafael.
>
> On Sat, May 4, 2013 at 12:19 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>> Heh, so you are aware of the deadlock possibilities.  Good selection
>>> of spots.  For all the conversion patches.
>>>
>>>  Acked-by: Tejun Heo <tj@kernel.org>
>>
>> I wonder if that includes [3/10] (just to get the record straight)?
>
> I think we want the lockdep annotations before these go in. I'll
> review Colin's new series later today.

Just to make sure the merge order is clear, the two patches I posted
yesterday to reintroduce the lockdep warning in try_to_freeze()
(https://lkml.org/lkml/2013/5/3/488) need to be merged first, then I
will repost this series on top of that one.
