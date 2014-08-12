Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699AbaHLBpD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 21:45:03 -0400
Received: from linuxhacker.ru ([217.76.32.60]:34237 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763AbaHLBpB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 21:45:01 -0400
Subject: Re: [PATCH] staging/lustre: use rcu_dereference to access rcu protected current->real_parent field
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Oleg Drokin <green@linuxhacker.ru>
In-Reply-To: <20140809154742.GA22689@kroah.com>
Date: Mon, 11 Aug 2014 21:44:47 -0400
Cc: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Peng Tao <bergwolf@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lai Siyao <lai.siyao@intel.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <0E60DB89-5757-4841-A416-D12C56413C58@linuxhacker.ru>
References: <20140806214216.GA16530@kroah.com> <CAGDhxoe4+jU=vCDedMC4VXfuNMmqP3-E1Lu3LLStbFLbd=BRSA@mail.gmail.com> <20140808034951.GA6626@kroah.com> <DFF36154-06AC-4D7E-87F5-259B73CB059B@linuxhacker.ru> <20140808044246.GA3084@kroah.com> <1FE03450-A256-4A18-85AB-6332A28E3EF5@linuxhacker.ru> <20140808053246.GA13588@kroah.com> <CA+a=Yy4SqXSe667DkU3KA80tAt5D=KG-9mfccvEwtJzuFr6vBA@mail.gmail.com> <20140809140426.GA20995@kroah.com> <A562EF9C-0B1E-48B2-BAB5-544C9AAC6DD0@linuxhacker.ru> <20140809154742.GA22689@kroah.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 9, 2014, at 11:47 AM, Greg Kroah-Hartman wrote:

> On Sat, Aug 09, 2014 at 10:34:36AM -0400, Oleg Drokin wrote:
>> 
>>> Because maybe these stats preceed the introduction of perf and other
>>> tracing/debug tools?  I don't know, it's really low down on the list of
>>> reasons why lustre can't be merged out of staging at the moment, you all
>>> have much bigger issues to address first.
>> 
>> I wonder what is the prioritized list you have in mind?
> 
> Do I really have to spell out what is wrong with that codebase that
> needs to be fixed up?  It took me 50+ patches for 3.17-rc1 to just fix
> up a _portion_ of the include file mess that is in there.  Now is the
> first time the code actually _builds_ properly in the kernel tree (i.e.
> no magic header file include path modifications in Makefiles preventing
> individual files from being built correctly.)

Well, last time we discussed this topic, you said that moving most of lustre proc files
into sysfs and other suitable venues is what prevents moving lustre out of the
staging tree under fs/

There well might be include mess, but this is the first time I hear about it, and I have not seen
any build breakage or other obviously broken behavior.
I am sure there are more things too, that's why I am asking.
We are trying to deal with stuff we know about, but it's a bit harder to deal with the stuff we don't know about
that does not manifest itself in some clear way.

Bye,
    Oleg