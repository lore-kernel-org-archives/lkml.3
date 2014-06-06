Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174AbaFFTyw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 15:54:52 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:59798 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589AbaFFTyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 15:54:50 -0400
Date: Fri, 06 Jun 2014 12:54:47 -0700 (PDT)
Message-Id: <20140606.125447.1665616708152334692.davem@davemloft.net>
To: jiri@resnulli.us
Cc: mprivozn@redhat.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net-sysfs: Report link speed only when possible
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140606085733.GJ2984@minipsycho.orion>
References: <771f792d4d4391c656305a522557c53c4e84a666.1402043894.git.mprivozn@redhat.com>
	<20140606085733.GJ2984@minipsycho.orion>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 06 Jun 2014 12:54:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Pirko <jiri@resnulli.us>
Date: Fri, 6 Jun 2014 10:57:33 +0200

> Fri, Jun 06, 2014 at 10:40:30AM CEST, mprivozn@redhat.com wrote:
>>The link speed is available at /sys/class/net/$nic/speed.
>>However, in some cases, depending on the driver, if the link is
>>not plugged, -1 is reported (this is the case of e1000e for
>>instance). To make things worse, the value is printed out as an
> 
> Actually, SPEED_UNKNOWN is also -1
> So e1000e is not any exception.

And pity the person who is handling this by evaluating that unsigned
value, we'll break them.

We can't keep changing behavior for the SPEED_UNKOWN case back and
forth.

A program that wants to work with all kernels now has to handle three
different kinds of behavior if we apply this patch, that's not making
things better, it's making things worse.

I'm not applying a patch that does this, sorry.
