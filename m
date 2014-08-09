Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874AbaHIPsR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 11:48:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37847 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828AbaHIPsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 11:48:14 -0400
Date: Sat, 9 Aug 2014 08:47:42 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Oleg Drokin <green@linuxhacker.ru>
Cc: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Peng Tao <bergwolf@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lai Siyao <lai.siyao@intel.com>
Subject: Re: [PATCH] staging/lustre: use rcu_dereference to access rcu
 protected current->real_parent field
Message-ID: <20140809154742.GA22689@kroah.com>
References: <20140806214216.GA16530@kroah.com>
 <CAGDhxoe4+jU=vCDedMC4VXfuNMmqP3-E1Lu3LLStbFLbd=BRSA@mail.gmail.com>
 <20140808034951.GA6626@kroah.com>
 <DFF36154-06AC-4D7E-87F5-259B73CB059B@linuxhacker.ru>
 <20140808044246.GA3084@kroah.com>
 <1FE03450-A256-4A18-85AB-6332A28E3EF5@linuxhacker.ru>
 <20140808053246.GA13588@kroah.com>
 <CA+a=Yy4SqXSe667DkU3KA80tAt5D=KG-9mfccvEwtJzuFr6vBA@mail.gmail.com>
 <20140809140426.GA20995@kroah.com>
 <A562EF9C-0B1E-48B2-BAB5-544C9AAC6DD0@linuxhacker.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A562EF9C-0B1E-48B2-BAB5-544C9AAC6DD0@linuxhacker.ru>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 09, 2014 at 10:34:36AM -0400, Oleg Drokin wrote:
> 
> > Because maybe these stats preceed the introduction of perf and other
> > tracing/debug tools?  I don't know, it's really low down on the list of
> > reasons why lustre can't be merged out of staging at the moment, you all
> > have much bigger issues to address first.
> 
> I wonder what is the prioritized list you have in mind?

Do I really have to spell out what is wrong with that codebase that
needs to be fixed up?  It took me 50+ patches for 3.17-rc1 to just fix
up a _portion_ of the include file mess that is in there.  Now is the
first time the code actually _builds_ properly in the kernel tree (i.e.
no magic header file include path modifications in Makefiles preventing
individual files from being built correctly.)

If you all don't know what needs to be done here, then I might as well
just delete the drivers/staging/lustre/ tree right now.

greg k-h
