Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521Ab3J3AGU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 20:06:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40104 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab3J3AGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 20:06:19 -0400
Date: Tue, 29 Oct 2013 17:06:18 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Peter Huewe <peterhuewe@gmx.de>
Cc: Ashley Lai <ashley@ashleylai.com>, Rajiv Andrade <mail@srajiv.net>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] tpm/tpm_i2c_stm_st33: Check return code of
 get_burstcount (fix CID: 986658)
Message-ID: <20131030000618.GA5241@kroah.com>
References: <1383090860-15901-1-git-send-email-peterhuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383090860-15901-1-git-send-email-peterhuewe@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 12:54:20AM +0100, Peter Huewe wrote:
> Coverity complains about
> "Improper use of negative value
> The negative value may be unexpected by later operations, causing
> incorrect computations.
> In tpm_stm_i2c_send: Negative value can be returned from function is not
> being checked before being used improperly (CWE-394)"
> 
> The 'get_burstcount' function can in some circumstances 'return -EBUSY' which
> in tpm_stm_i2c_send is stored in an 'u32 burstcnt'
> thus converting the signed value into an unsigned value, resulting
> in 'burstcnt' being huge.
> Changing the type to u32 only does not solve the problem as the signed
> value is converted to an unsigned in I2C_WRITE_DATA, resulting in the
> same effect.
> 
> Thus
> -> Change type of burstcnt to u32 (the return type of get_burstcount)
> -> Add a check for the return value of 'get_burstcount' and propagate a
> potential error.
> 
> This makes also sense in the 'I2C_READ_DATA' case, where the there is no
> signed/unsigned conversion.
> 
> CID: 986658

What is this field for?

thanks,

greg k-h
