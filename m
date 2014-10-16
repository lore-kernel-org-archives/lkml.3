Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978AbaJPU6R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 16:58:17 -0400
Received: from vader.hardeman.nu ([95.142.160.32]:33788 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750867AbaJPU6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 16:58:15 -0400
X-Greylist: delayed 534 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Oct 2014 16:58:15 EDT
Date: Thu, 16 Oct 2014 22:49:20 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Tomas Melin <tomas.melin@iki.fi>
Cc: m.chehab@samsung.com, james.hogan@imgtec.com, a.seppala@gmail.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend] [media] rc-core: fix protocol_change regression
 in ir_raw_event_register
Message-ID: <20141016204920.GB16402@hardeman.nu>
Mail-Followup-To: Tomas Melin <tomas.melin@iki.fi>, m.chehab@samsung.com,
	james.hogan@imgtec.com, a.seppala@gmail.com,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1412879436-7513-1-git-send-email-tomas.melin@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412879436-7513-1-git-send-email-tomas.melin@iki.fi>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2014 at 09:30:36PM +0300, Tomas Melin wrote:
>IR reciever using nuvoton-cir and lirc was not working anymore after
>upgrade from kernel 3.16 to 3.17-rcX.
>Bisected regression to commit da6e162d6a4607362f8478c715c797d84d449f8b
>("[media] rc-core: simplify sysfs code").
>
>The regression comes from adding function change_protocol in
>ir-raw.c. During registration, ir_raw_event_register enables all protocols
>by default. Later, rc_register_device also tests dev->change_protocol and
>changes the enabled protocols based on rc_map type. However, rc_map type
>only defines a single specific protocol, so in the case of a more generic
>driver, this disables all protocols but the one defined by the map.
>
>Changed back to original behaviour by removing empty function
>change_protocol in ir-raw.c. Instead only calling change_protocol for
>drivers that actually have the function set up.

I think this is already addressed in this thread:
http://www.spinics.net/lists/linux-media/msg79865.html

