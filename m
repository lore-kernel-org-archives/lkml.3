Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab3EVI7W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 04:59:22 -0400
Received: from gatzka.org ([85.214.228.118]:39468 "EHLO mail.gatzka.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752407Ab3EVI7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 04:59:21 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 May 2013 04:59:20 EDT
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Wed, 22 May 2013 10:59:19 +0200
From: Stephan Gatzka <stephan.gatzka@gmail.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Tejun Heo <tj@kernel.org>, Peter Hurley <peter@hurleysoftware.com>,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: function call =?UTF-8?Q?fw=5Fiso=5Fresource=5Fmange=28=2E=2E?=
 =?UTF-8?Q?=29=20=28core-iso=2Ec=29=20does=20not=20return?=
Reply-To: stephan.gatzka@gmail.com
Mail-Reply-To: stephan.gatzka@gmail.com
In-Reply-To: <20130522094840.472b263e@stein>
References: <8ac7ca3200325ddf85ba57aa6d000f70@gatzka.org>
 <519BA6AC.1080600@hurleysoftware.com> <20130521231847.GA6985@mtj.dyndns.org>
 <20130522094840.472b263e@stein>
Message-ID: <51145028d1c880d68e0a88d863faa71c@gatzka.org>
User-Agent: Roundcube Webmail/0.8.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> A third (fourth?) way to fix it --- feasible or not --- would be to 
> break
> the dependency between the worklets.  In this case, use a timer to 
> cancel
> outbound transactions if the request-transmit IRQ event was not 
> received
> before a timeout.  We had such a timeout in the older ieee1394 drivers 
> and
> we also had it in earlier versions of the firewire drivers, at a risk 
> of a
> race between CPU and OHCI.

Why do we need a timer? If we guarantee that bus_reset_work() always 
make progress (if we put it into its own queue), it should always be 
able to complete the corresponding completion object the other works are 
waiting for.

Regards,

Stephan
