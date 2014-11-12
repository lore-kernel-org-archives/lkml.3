Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707AbaKLNPu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 08:15:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39030 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752406AbaKLNPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 08:15:49 -0500
Date: Wed, 12 Nov 2014 14:15:46 +0100
From: Michal Kubecek <mkubecek@suse.cz>
To: David Miller <davem@davemloft.net>
Cc: vfalico@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        j.vosburgh@gmail.com, andy@greyhouse.net, jiri@resnulli.us
Subject: Re: [PATCH net-next 0/3] dev_disable_lro() improvements for stacked
 devices
Message-ID: <20141112131546.GA8745@unicorn.suse.cz>
References: <cover.1415692212.git.mkubecek@suse.cz>
 <20141111090522.GB20586@raspberrypi>
 <20141111093457.GA30178@unicorn.suse.cz>
 <20141111.214752.266800170368088905.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141111.214752.266800170368088905.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 09:47:52PM -0500, David Miller wrote:
> 
> Please do it generically.
> 
> Having a special stanza for each layered device type in
> dev_disable_lro() is beyond stupid.  Especially when it
> can in fact be done cleanly.

I gave it some thought and I would like ask one question first:

Does the upper-lower relationship always mean that upper device receives
packets through its lower device(s) so that LRO should always be
disabled for lower devices whenever there are some? Or should it be
limited only to an explicit list of device types (vlan, macvlan, bond,
team)?

                                                         Michal Kubecek

