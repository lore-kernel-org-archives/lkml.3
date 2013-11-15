Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab3KONs5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 08:48:57 -0500
Received: from order.stressinduktion.org ([87.106.68.36]:45096 "EHLO
	order.stressinduktion.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029Ab3KONsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 08:48:13 -0500
Date: Fri, 15 Nov 2013 14:48:11 +0100
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: Kamala R <kamala@aristanetworks.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: IPv6: Blackhole route support partial ?
Message-ID: <20131115134811.GF26901@order.stressinduktion.org>
Mail-Followup-To: Kamala R <kamala@aristanetworks.com>, davem@davemloft.net,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <CAP8BHkGZ5EFxW4BNervKrOiEaQTNdSh9s2YOrFoexzQCOR=AqQ@mail.gmail.com> <20131111203954.GB3043@order.stressinduktion.org> <CAP8BHkG6=KuU9K7=sGsZftMDe58eTYByRu2DZ+j+KNqcfsOfAA@mail.gmail.com> <20131112135412.GF14929@order.stressinduktion.org> <CAP8BHkEyASA52Q4Zg4w5OqR7Hv7Y_it8SnG_tMPViza_T9TV+Q@mail.gmail.com> <20131114141149.GC26901@order.stressinduktion.org> <CAP8BHkF_axGOChL=GigyKxWY1XYr_tQhWFF21ZxpVX9YpRpQSQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAP8BHkF_axGOChL=GigyKxWY1XYr_tQhWFF21ZxpVX9YpRpQSQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Fri, Nov 15, 2013 at 03:06:28PM +0530, Kamala R wrote:
> That's right. We don't show the error for IPv4 routes as it follows a
> different path in kernel while dumping the information as compared
> with IPv6. Therefore, "ip route show" does not show an error while "ip
> -6 route show" does.  So it looks to me that this a kernel problem
> which needs to be fixed for consistent behavior. The simplest way to
> fix this seems to be to set the error to zero while dumping the
> information in the v6 path. I have tested this solution and found that
> it works fine. Do you think this is the way to go ?

If I understand you correctly you propose to drop the output of the error
attribute for IPv6 routes too? It is not that important that those two
outputs are identical and if you make a change, please introduce the
error propagation for IPv4 so one can see the socket errors for those
routes, too. I wouldn't drop those for IPv6 just for consistency reasons.

Greetings,

  Hannes

