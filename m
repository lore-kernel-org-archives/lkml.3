Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916AbaJQKsl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 06:48:41 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:49353 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751346AbaJQKsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 06:48:40 -0400
X-Greylist: delayed 386 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Oct 2014 06:48:39 EDT
Message-ID: <5440F282.8040306@itdev.co.uk>
Date: Fri, 17 Oct 2014 11:42:10 +0100
From: Nick Dyer <nick.dyer@itdev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Greg KH <greg@kroah.com>,
        Jonathan Cameron <jic23@kernel.org>
CC: "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Touch processing on host CPU
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi-

I'm trying to find out which subsystem maintainer I should be talking to -
apologies if I'm addressing the wrong people.

There is a model for doing touch processing where the touch controller
becomes a much simpler device which sends out raw acquisitions (over SPI 
at up to 1Mbps + protocol overheads). All touch processing is then done in
user space by the host CPU. An example of this is NVIDIA DirectTouch - see:
http://blogs.nvidia.com/blog/2012/02/24/industry-adopts-nvidia-directtouch/

In the spirit of "upstream first", I'm trying to figure out how to get a
driver accepted. Obviously it's not an input device in the normal sense. Is
it acceptable just to send the raw touch data out via a char device? Is
there another subsystem which is a good match (eg IIO)? Does the protocol
(there is ancillary/control data as well) need to be documented?

cheers

-- 
Nick Dyer
Senior Software Engineer, ITDev
Fully Managed Technology Design Services
+44 (0)23 80988855  -  http://www.itdev.co.uk

