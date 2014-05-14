Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187AbaENNmc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 09:42:32 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:59243 "EHLO
	new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751380AbaENNmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 09:42:31 -0400
X-Greylist: delayed 427 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 May 2014 09:42:31 EDT
Message-Id: <1400074523.15916.117311749.3590532D@webmail.messagingengine.com>
X-Sasl-Enc: vJgMovh8q/E+0Be5IXsNKNGcLGcZpLWCBh1NzoaXBvmX 1400074523
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: dormando <dormando@rydia.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Mailer: MessagingEngine.com Webmail Interface - ajax-0867fb17
In-Reply-To: <alpine.DEB.2.02.1405140233210.16893@dtop>
References: <alpine.DEB.2.02.1405140233210.16893@dtop>
Subject: Re: Multitude of dst obsolescense race conditions
Date: Wed, 14 May 2014 06:35:23 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014, at 2:57, dormando wrote:
> Given a machine with frequently changing routes (ie; a router with an
> active internet BGP table and multiple interfaces), there're at least
> several places where obsolete dst's are handled improperly. If I pause
> the
> route changes, the crashes appear to stop. This first one has a crash
> utility we've made, so I was able to more quickly find a patch and test
> it. The others take time to reproduce.
> 
> I'm testing against 3.10.39, but I think if these were fixed they'd be
> backported to stable? I've also had recent 3.12's running that have
> crashed in the same spots. Anyway correct me if I'm wrong...

Just a hunch:
You use macvlan? Could you somehow try without?
Maybe... some ref overflow? (You could add some testing code in dst_hold
with atomic_inc_return and WARN_ON).

dst_release already contains such a check, so I am not sure at all if
that could happen.

Bye,

  Hannes
