Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676Ab3GNOdu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 10:33:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:33655 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521Ab3GNOdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 10:33:47 -0400
MIME-Version: 1.0
In-Reply-To: <1373807844.4998.10.camel@palomino.walls.org>
References: <1373533573-12272-1-git-send-email-ming.lei@canonical.com>
	<1373807844.4998.10.camel@palomino.walls.org>
Date: Sun, 14 Jul 2013 22:33:44 +0800
Message-ID: <CACVXFVPjkUwpnDCeC+y_eczGuen=qu+g74V__SXFCidPp+QYMw@mail.gmail.com>
Subject: Re: [PATCH 00/50] USB: cleanup spin_lock in URB->complete()
From: Ming Lei <ming.lei@canonical.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        Oliver Neukum <oliver@neukum.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-input@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-media@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 14, 2013 at 9:17 PM, Andy Walls <awalls@md.metrocast.net> wrote:
> On Thu, 2013-07-11 at 17:05 +0800, Ming Lei wrote:
>> Hi,
>>
>> As we are going to run URB->complete() in tasklet context[1][2],
>
> Hi,
>
> Please pardon my naivete, but why was it decided to use tasklets to
> defer work, as opposed to some other deferred work mechanism?
>
> It seems to me that getting rid of tasklets has been an objective for
> years:
>
> http://lwn.net/Articles/239633/
> http://lwn.net/Articles/520076/
> http://lwn.net/Articles/240054/

We discussed the problem in the below link previously[1], Steven
and Thomas suggested to use threaded irq handler, but which
may degrade USB mass storage performance, so we have to
take tasklet now until we rewrite transport part of USB mass storage
driver.

Also the conversion[2] has avoided the tasklet spin lock problem
already.


[1], http://marc.info/?t=137079119200001&r=1&w=2
[2], http://marc.info/?l=linux-usb&m=137286326726326&w=2


Thanks,
--
Ming Lei
