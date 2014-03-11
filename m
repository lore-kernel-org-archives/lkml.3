Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248AbaCKO0i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 10:26:38 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:51913 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751590AbaCKO0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 10:26:37 -0400
Message-ID: <531F1D18.4060109@mev.co.uk>
Date: Tue, 11 Mar 2014 14:26:32 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Chase Southwood <chase.southwood@yahoo.com>, gregkh@linuxfoundation.org
CC: hsweeten@visionengravers.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] Staging: comedi: convert while loops to timeouts
 in s626.c
References: <20140309030056.GA10867@kroah.com> <1394337654-27379-1-git-send-email-chase.southwood@yahoo.com>
In-Reply-To: <1394337654-27379-1-git-send-email-chase.southwood@yahoo.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-03-09 04:00, Chase Southwood wrote:
> This patch changes a handful of while loops to timeouts to prevent
> infinite looping on hardware failure. A couple such loops are in a
> function (s626_debi_transfer()) which is called from critical sections,
> so comedi_timeout() is unusable for them, and an iterative timeout is
> used instead. For the while loops in a context where comedi_timeout() is
> allowed, a new callback function, s626_send_dac_eoc(), has been defined
> to evaluate the conditions that the while loops are testing.  The new
> callback employs a switch statement based on a simple new enum so that
> it is usable for all of the different conditions tested in while loops
> in s626_send_dac().  The proper comedi_timeout() calls are then used.
>
> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
> ---
> Ian, here is a version of this patchset employing the enum you recommended.
> The second patch has been rebased on top of this one.
>
> 2: Used comedi_timeout() where appropriate, introduce callback function
>
> 3: Updated callback to switch on new enum.

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

For future reference, for patches affecting a single comedi driver, we 
usually title the patches like this:

staging: comedi: name_of_driver: summary of patch

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
