Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbaKLUIc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 15:08:32 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:46119 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190AbaKLUIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 15:08:31 -0500
Date: Wed, 12 Nov 2014 15:08:28 -0500 (EST)
Message-Id: <20141112.150828.421966825872572028.davem@davemloft.net>
To: mkubecek@suse.cz
Cc: vfalico@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        j.vosburgh@gmail.com, andy@greyhouse.net, jiri@resnulli.us
Subject: Re: [PATCH net-next 0/3] dev_disable_lro() improvements for
 stacked devices
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141112131546.GA8745@unicorn.suse.cz>
References: <20141111093457.GA30178@unicorn.suse.cz>
	<20141111.214752.266800170368088905.davem@davemloft.net>
	<20141112131546.GA8745@unicorn.suse.cz>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 12 Nov 2014 12:08:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Kubecek <mkubecek@suse.cz>
Date: Wed, 12 Nov 2014 14:15:46 +0100

> On Tue, Nov 11, 2014 at 09:47:52PM -0500, David Miller wrote:
>> 
>> Please do it generically.
>> 
>> Having a special stanza for each layered device type in
>> dev_disable_lro() is beyond stupid.  Especially when it
>> can in fact be done cleanly.
> 
> I gave it some thought and I would like ask one question first:
> 
> Does the upper-lower relationship always mean that upper device receives
> packets through its lower device(s) so that LRO should always be
> disabled for lower devices whenever there are some? Or should it be
> limited only to an explicit list of device types (vlan, macvlan, bond,
> team)?

This should be the case, anyone else?
