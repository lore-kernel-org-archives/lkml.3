Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678AbaHHEOL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 00:14:11 -0400
Received: from linuxhacker.ru ([217.76.32.60]:58476 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816AbaHHEOI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 00:14:08 -0400
X-Greylist: delayed 627 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Aug 2014 00:14:07 EDT
Subject: Re: [PATCH] staging/lustre: use rcu_dereference to access rcu protected current->real_parent field
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Oleg Drokin <green@linuxhacker.ru>
In-Reply-To: <20140808034951.GA6626@kroah.com>
Date: Fri, 8 Aug 2014 00:03:20 -0400
Cc: Evgeny Budilovsky <budevg@gmail.com>, devel@driverdev.osuosl.org,
        Andreas Dilger <andreas.dilger@intel.com>,
        Peng Tao <bergwolf@gmail.com>, linux-kernel@vger.kernel.org,
        Lai Siyao <lai.siyao@intel.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <DFF36154-06AC-4D7E-87F5-259B73CB059B@linuxhacker.ru>
References: <87k36ltoob.fsf@gmail.com> <20140806214216.GA16530@kroah.com> <CAGDhxoe4+jU=vCDedMC4VXfuNMmqP3-E1Lu3LLStbFLbd=BRSA@mail.gmail.com> <20140808034951.GA6626@kroah.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

On Aug 7, 2014, at 11:49 PM, Greg Kroah-Hartman wrote:
>> 
>> This is not a critical bug and in the worst case the code here may
>> cause miss of statistics counter increase.
>> This is why I think it is not worth to backport the patch at all.
> You are right, and if this is just for some random "statistics" file,
> can we just delete the whole function?

I hope not!
This is used all around the client to tally up various operations executed counts.

The statistic is then used by various userspace monitoring tools.

Bye,
    Oleg