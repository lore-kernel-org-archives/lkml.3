Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174Ab3G3OUx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 10:20:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40646 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216Ab3G3OUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 10:20:52 -0400
Date: Tue, 30 Jul 2013 07:22:09 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Shuah Khan <shuah.kh@samsung.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: Re: [char-misc 3.11 V2] mei: me: fix hardware reset flow
Message-ID: <20130730142209.GA28956@kroah.com>
References: <1375182711-10253-1-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375182711-10253-1-git-send-email-tomas.winkler@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 02:11:51PM +0300, Tomas Winkler wrote:
> Both H_IS and H_IE needs to be set to receive H_RDY 
> interrupt
> 
> 1. Assert H_IS to clear the interrupts during hw reset
> and use mei_me_reg_write instead of mei_hcsr_set as the later
> strips down the H_IS
> 
> 2. fix interrupt disablement embarrassing typo
>   hcsr |= ~H_IE -> hcsr &= ~H_IE;
> this will remove the unwanted interrupt on power down
> 
> 3. remove useless debug print outs
> 
> Cc: Shuah Khan <shuah.kh@samsung.com>
> Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---
> 
> V2: Fixed typo in Shuah email
> 
> Hope this finally resolve the ME reset issue for all

Can I get a "Tested-by:" from someone to ensure that it really does
solve the problem?

thanks,

greg k-h
