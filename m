Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650Ab3B1Ks3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 05:48:29 -0500
Received: from smtp.domeneshop.no ([194.63.252.54]:43814 "EHLO
	smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab3B1Ks0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 05:48:26 -0500
X-Greylist: delayed 649 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Feb 2013 05:48:26 EST
Message-ID: <512F3369.5060201@paradoxuncreated.com>
Date: Thu, 28 Feb 2013 11:37:29 +0100
From: Ove Karlsen <ove.karlsen@paradoxuncreated.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Last thoughts on low-jitter desktop for developers and distromakers.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don´t know how many got that I did a very good low-jitter config for 
linux, and made jitter-sensitive games, like doom 3 run perfectly on 5 
yr old h/w (core 2 duo/gtx280), something that requires a modern Intel 
E5 workstation for a finely tweaked windows XP.

Low-jitter linux config: http://paradoxuncreated.com/Blog/wordpress/?p=2268

Windows tweak here: http://paradoxuncreated.com/Blog/wordpress/?p=1783

I have been testing it for a while, and it is really excellent.


Afterwards some thoughts come to me though, and that is really that, 
when everything is working optimally, one can make some considerations 
for prioritization of threads for the desktop.

Audio seems to be the one thing, that one notices immedialtely if breaks 
up, so that could be more like a realtime thing, where developers 
optimize for minimal cpu-usage at low latency. 0.2ms is probably close 
enough to hardware for most.

Graphics seem to work very well, with the low-jitter config. No 
dropouts, smooth action all the time, even on jitter-sensitive games 
like doom 3 that does 3 passes to openGL. The added complexity of 3 
passes, seems to be what makes it jitter sensitive, and the added layers 
of wine, seems indeed to cause jitter aswell, and low-jitter configs 
improve wine aswell. Here the standard kernel is obviously better than 
the BFS scheduler also. CFS is better overall, and I also tried some 
other schedulers that were useless. (rifs?)

Network connection: Many these days want the lowest possbile latency 
network connection. While for desktops it is no problem if this is 
prioritized after an audio-thread for my part, some talk about OS-bypass 
here. Maybe some consideration can be done, if some things work better, 
such as audio and network, programmed directly to the hardware, such as 
on oldskool computers, where there was "no latency".

Other than that, the ubersmooth graphics that Mark Shuttleworth wants is 
already here. That is the low-jitter config. It will be great to see the 
developments of Wayland, which ofcourse then must be an improvement.

Peace Be with You,
Ove Karlsen.

