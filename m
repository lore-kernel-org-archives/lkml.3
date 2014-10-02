Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928AbaJBOhb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 10:37:31 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:60592 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615AbaJBOha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 10:37:30 -0400
Message-ID: <1412260632.8045.15.camel@cyc>
Subject: Re: [PATCH] x86, MCE, AMD: save IA32_MCi_STATUS before
 machine_check_poll() resets it
From: Chen Yucong <slaoub@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: tony.luck@intel.com, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 02 Oct 2014 22:37:12 +0800
In-Reply-To: <20141002131206.GA16452@pd.tnic>
References: <1411438561-24319-1-git-send-email-slaoub@gmail.com>
	 <1411460354.25617.3.camel@debian> <20140929120546.GB6495@pd.tnic>
	 <1412037578.21488.11.camel@debian> <20140930072553.GA4639@pd.tnic>
	 <1412070991.16556.12.camel@cyc> <20140930100940.GD4639@pd.tnic>
	 <1412138102.21488.20.camel@debian> <20141002131206.GA16452@pd.tnic>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-10-02 at 15:12 +0200, Borislav Petkov wrote:
> 
> Ok, this return is still bugging me - we're logging the error which
> caused the counter overflow but we go and explicitly clear _STATUS so
> that machine_check_poll doesn't pick up the same error again.
> 
> Even though, machine_check_poll is intended to log the thresholding
> error.
> 
> Which actually makes me think that that machine_check_poll is actually
> completely useless there. IOW, how about that instead: 

amd_threshold_interrup() is just used for logging threshold events. And
any 'valid' threshold events can be checked/logged in loop body.
Moreover, machine_check_poll() is unable to check additional MCx_MISCi.
So I agree with you on this change.

Thanks!
cyc 

