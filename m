Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932527Ab3DBO6g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 10:58:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53130 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932492Ab3DBO6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 10:58:34 -0400
Date: Tue, 2 Apr 2013 10:58:20 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, WANG Chao <chaowang@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kexec: use Crash kernel for Crash kernel low
Message-ID: <20130402145820.GF29506@redhat.com>
References: <20130401192606.GA17951@redhat.com>
 <5159F27E.7060300@zytor.com>
 <CAE9FiQXikU8-FkYYULHx50qP_ME2bRSzCC=8ZH8iDyUr2ug66g@mail.gmail.com>
 <515A03DB.6040107@zytor.com>
 <CAE9FiQWNFbFgXafJBvORRax+GNU_uf0KFnqZ5NQit0BeZZx9LA@mail.gmail.com>
 <515A083B.7050508@zytor.com>
 <CAE9FiQXwy8nLRQAiZ+P56fokisUXAmTJWA07TZ-gSH61K5FQLA@mail.gmail.com>
 <CAE9FiQW1RzP5A_82qUP7gF_6-G3+Ceay_L1FQf7N=MMbQA4+iw@mail.gmail.com>
 <20130402135001.GC29506@redhat.com>
 <CAE9FiQVWprV4YkMq_Pu95AYk_qGzXWPVBWJVDfa=0RbqL63y4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQVWprV4YkMq_Pu95AYk_qGzXWPVBWJVDfa=0RbqL63y4Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 02, 2013 at 07:45:36AM -0700, Yinghai Lu wrote:

[..]
> No, that make the logic too complicated.
> 
> After those four patches:
> if the user still use old kexec-tools, they are still with
> crashkernel=X, nothing is changed.
> if the user want to use crashkernel=X,high, they should update kexec-tools.
>    when high is used, memblock will search from top to low.
>    if the allocated one is above 4G, kernel will try to auto allocate
> 72M under 4G for swiotlb
>        user could crashkernel=Y,low to change 72M to other value.

Hm...,

- Ok so atleast use a different delimiter. Otherwise one could specify
  rage1:size1,range2:size2,high which is confusing.

- I think one can look at above as follows.

  crashkernel=<memory_to_reserve>;[<option1>];....

where option1 specifies range of memory where to look for specified amount
of memory. Current valid values are high/low. High means look for memory
above 4G or fail. Low means look for memory below 4G or fail. We can
always extend range syntax later if need be. Similarly we can always
add option2 to emulate where to begin search (high/low). So this still
falls into the generic syntax category and extendable, if need be.

I will test your patches again.

Thanks
Vivek
