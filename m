Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757970AbaDBGiP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 02:38:15 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:53549 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756899AbaDBGiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 02:38:13 -0400
Message-ID: <533BB04E.9000206@ti.com>
Date: Wed, 2 Apr 2014 09:38:06 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        <linux-kernel@vger.kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Subject: Re: [PATCH] drivercore: deferral race condition fix
References: <1393398414-10822-1-git-send-email-peter.ujfalusi@ti.com> <20140301003320.GA31852@kroah.com> <53143CD3.30209@ti.com> <20140304045626.GK2411@sirena.org.uk>
In-Reply-To: <20140304045626.GK2411@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On 03/04/2014 06:56 AM, Mark Brown wrote:
> On Mon, Mar 03, 2014 at 10:26:59AM +0200, Peter Ujfalusi wrote:
> 
>> I think it is correct to detect this situation without the need to have non
>> related drivers to be probed.
>> The patch is doing this exactly: detects if we had successful parallel driver
>> probe(s) while another driver was probing which ends up requesting to be
>> deferred. We only try the deferred list again if this condition has been
>> detected, we do not loop on the deferred list, we do not try the list again if
>> there were no other drivers loaded since nothing happened which could satisfy
>> the driver asking to be deferred.
> 
> It's certainly the simplest approach I can think of - anything else
> would seem to involve looking to see if we're running deferred probes
> and trying to add things to the list while that's going on which seems
> like it might be hairy.

Do you want me to resend this patch in hope that it is going to be taken or do
you have other method in mind to deal with the situation I have described and
fixed with this patch?

Regards,
Péter
