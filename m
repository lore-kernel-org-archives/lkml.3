Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314AbaKSNkK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 08:40:10 -0500
Received: from mx01-fr.bfs.de ([193.174.231.67]:12334 "EHLO mx01-fr.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753300AbaKSNkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 08:40:08 -0500
Message-ID: <546C9D99.3080001@bfs.de>
Date: Wed, 19 Nov 2014 14:39:37 +0100
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: SF Markus Elfring <elfring@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH 1/1] PM-wakeup: Deletion of an unnecessary check before
 the function call "wakeup_source_unregister"
References: <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <546C7E75.9080301@users.sourceforge.net> <20141119120915.GM4905@mwanda> <546C9319.4040205@bfs.de> <20141119130553.GN4956@mwanda>
In-Reply-To: <20141119130553.GN4956@mwanda>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Am 19.11.2014 14:05, schrieb Dan Carpenter:
> On Wed, Nov 19, 2014 at 01:54:49PM +0100, walter harms wrote:
>> device_wakeup_detach returns dev->power.wakeup what is never NULL in this case.
>> (not visible here but a few line before exactly this is checked)
> 
> Huh?  I don't see a NULL check.
> 
> I think you may be confusing "dev->power.can_wakeup" with
> "dev->power.wakeup"?
> 
>

mea culpa,
you are right  dev->power.can_wakeup != dev->power.wakeup

therefore device_wakeup_detach(dev) CAN return NULL

re,
 wh
