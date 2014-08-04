Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134AbaHDVYv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 17:24:51 -0400
Received: from mx3.wp.pl ([212.77.101.9]:36160 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751756AbaHDVYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 17:24:50 -0400
Date: Mon, 4 Aug 2014 23:24:47 +0200
From: Janek Kozicki <janek_listy@wp.pl>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [HELP (not patch)] Re: Resume from hibernation fails 40% of time,
 kernel 3.16.0 (64GB of RAM, 32 Xeon E5-2687W cores)
Message-ID: <20140804232447.5094b23e@absurd>
In-Reply-To: <20140804185644.05a56986@absurd>
References: <20140804185644.05a56986@absurd>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
X-Face: $rkfae+2_DGd"-<Fvf,vE7&hL?oJC.uN!6/loh7NMwb/Cs*h!wXg0^+WL;VPwQ0]e0\sPi~63[g*K.:C@jj9zV:L^0&vNyT+aq.9L.0V'8yV%Q/PzmqW{8{/P`>BPR=BhRod2pTifbsp+}LY@O++;u~RqNMBFJgn?R{QHO^@4;?(l5x002ZHJ$zZd~:,H{5E&LV]7X9\7Bw*fl
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAALVBMVEUBAQEtLS1KSkpRUVFXV1dYWFhjY2Nzc3N3d3eHh4eKioqdnZ24uLjLy8vc3NxVIagyAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH2AIVEzgS1fgQtQAAAjRJREFUOMtt1DFv00AUAOAzFQNbjigSyoQaRaBMhKgLUyKXpVNNeUpk9vyDqFJhQ1kiBuaqAwJCqvPtSLY7RlTn5+5IdnYkkt/AOyfxXVLe5vf53Z1875kd34tOEax8djmj6GyjhB5bxz50GdsVZr9fqRjZwAtKOJw5Wqs2MMZ16ALHsaDncF7xAHix1oEFHAB8f+pRjcO4gfZDykcYzbiucRolOLUJ6kjA0xtVt+A6TySlM0RajIpK6DzwKZ/nOYbF/gclHMo1ZOHYY/+Ha+AWuM+3oMS4eeqYzZ8FiCltgUqI8cd2wwAVpJk+8LWYjBtnJdQpHQqJMd4Oxt4bU9ESiFGc5hkqaH74asAX4iabP5I5gZ+qjgGlJCqZa3h3lxhoeVcSE1qLQC4sqKOK9MGW9E3izFqqHokoztLFEgXg31sbZEKnWi2T74A4NxfVQqlkjKtcAWD+zcArFEES01dR0E/nnV0IgugmDd/2L84sOAouRBBHEc7gtc8teDkRlE0iNQPo2w3Xhh/D4TCIQ4LRLoTvgwjj6RRgavdurxYGMaIuGOyAW/PpNlCcU9/93AHenAWYjPoAwa+G3e3to/MgFNTAEKvKDjzuCzHTnY3qqdXtx24VijzQfZ0yewZ5cwRFQaa+mIYr1uI0I76+3W4xhlvoVRwOA0Fdl64HlJnxP6T8YpX/Lga4Wv4A3ErrU5oTfN7Mu/llXMl8RXEPji/lQkN3H7qXqgC2By47EXeU/7PJ/wPxRKMnuZwIeAAAAABJRU5ErkJggg==
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-AV: skaner antywirusowy poczty Wirtualnej Polski S. A.
X-WP-SPAM: NO 0000000 [YXCV]                               
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I see that this list is extremely busy, I thought this is the
place to go asking for help in debugging hibernation. If that's not
the right place, please tell me where should I go. If that's the
right place, please get me started. First - how can I retrieve some
useful logs from failed resume attempts?

(details in my previous email)

best regards
Janek Kozicki

Janek Kozicki said:     (by the date of Mon, 4 Aug 2014 18:56:44 +0200)

> Hi,
> 
> I have an up-to-date recently installed debian wheezy. I downloaded
> https://www.kernel.org/pub/linux/kernel/v3.x/linux-3.16.tar.xz and compiled it using:
> 
>   cp /boot/config-`uname -r` ./.config
>   make menuconfig
>   fakeroot make-kpkg --initrd --append-to-version=-vanilla.1 kernel_image kernel_headers -j38
>   dpkg -i linux-image-3.16.0-vanilla.1_3.16.0-vanilla.1-10.00.Custom_amd64.deb linux-headers-3.16.0-vanilla.1_3.16.0-vanilla.1-10.00.Custom_amd64.deb
> 
> where .config was taken from debian /boot/config-3.14-0.bpo.1-amd64
> 
> my PC has 64GB of RAM, 32 Xeon E5-2687W cores and motherboard SuperMicro MBD-X9DRI
> 
> I just did 25 tries of suspend/resume cycle. I tried 4 different
> methods of hibernation, you will find a full summary of my tries
> (including how many failures for each method) in attached script
> SLEEP.sh which I always used to perform hibernation.
> 
> The failure was always a reboot after resume had almost succeeded. In
> cases when there was a success there was a ---[cut here]--- part
> which is in the attachment. All of my successes are included in the
> attachments (please note that method had 0 success rate, so no
> success logs are attached for it).
> 
> I post here to get your help, and my first question: how can I
> retrieve some useful logs from a failed resume attempt?
> 
> best regards
> -- 
> Janek Kozicki                               http://janek.kozicki.pl/  |


-- 
Janek Kozicki                               http://janek.kozicki.pl/  |
