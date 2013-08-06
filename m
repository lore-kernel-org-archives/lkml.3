Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630Ab3HFWLa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 18:11:30 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:37066 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754513Ab3HFWL3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 18:11:29 -0400
Message-ID: <1375827089.2424.37.camel@joe-AO722>
Subject: Re: [PATCH] kernel/sysctl_binary.c: improve the usage of return
 value 'result'
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chen Gang <gang.chen@asianux.com>, Al Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>, xi.wang@gmail.com,
        nicolas.dichtel@6wind.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 06 Aug 2013 15:11:29 -0700
In-Reply-To: <20130806144339.182beb0a2abddc0782015487@linux-foundation.org>
References: <5200A5E6.9020803@asianux.com>
	 <20130806144339.182beb0a2abddc0782015487@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-06 at 14:43 -0700, Andrew Morton wrote:
> On Tue, 06 Aug 2013 15:29:42 +0800 Chen Gang <gang.chen@asianux.com> wrote:
> 
> > Improve the usage of return value 'result', so not only can make code
> > clearer to readers, but also can improve the performance.
> 
> It used to be pervasive kernel style do to
> 
> 	ret = -ENOMEM;
> 	foo = alloc(...);
> 	if (!foo)
> 		goto out;
> 
> whereas nowadays people usually do the more straightforward
> 
> 	foo = alloc(...);
> 	if (!foo) {
> 		ret = -ENOMEM;
> 		goto out;
> 	}
> 
> The thinking was that the old style generated better code, but for the
> life of me I can't remember why :(

https://lkml.org/lkml/2008/12/16/383


