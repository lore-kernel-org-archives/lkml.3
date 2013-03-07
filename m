Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932413Ab3CGXbv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 18:31:51 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:41713 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758218Ab3CGXbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 18:31:49 -0500
Date: Fri, 8 Mar 2013 07:29:32 +0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: David Brown <davidb@codeaurora.org>
Cc: Kenneth Heitke <kheitke@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/6] platform-drivers: msm: add single-wire serial bus
 interface (SSBI) driver
Message-ID: <20130307232932.GE10304@kroah.com>
References: <1362616187-21089-1-git-send-email-davidb@codeaurora.org>
 <1362616187-21089-2-git-send-email-davidb@codeaurora.org>
 <20130307013008.GA2910@kroah.com>
 <8yawqtjvl8y.fsf@huya.qualcomm.com>
 <20130307060117.GA31687@kroah.com>
 <8yafw07ujr3.fsf@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8yafw07ujr3.fsf@huya.qualcomm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 10:50:40AM -0800, David Brown wrote:
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> 
> >> Without this device, the PMIC drivers won't work, regulators can't be
> >> turned on, and most of the other devices won't work.  I can try if it
> >> can still be made a module, and it might be good at exercising the
> >> deferred probe mechanism.
> >
> > If the PMIC drivers are dependant on the symbols in this module, there
> > should not be any problems, right?
> 
> The PMIC drivers directly will be, but the users of gpios/irqs and
> regulators coming from the PMIC will only depend on the generic APIs for
> this.  In theory, the deferred probe should handle this, and it might
> be useful for testing.
> 
> I can allow it to be a module, although I don't picture that really
> being a useful configuration.

It will allow this to get multi-arch build testing at the very least, a
very valuable thing as time goes on.  You can always specify this as 'Y'
in your defconfig for your board.

thanks,

greg k-h
