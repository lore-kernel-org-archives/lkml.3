Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab3HVDsW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 23:48:22 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:40851 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402Ab3HVDsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 23:48:20 -0400
Date: Wed, 21 Aug 2013 20:48:19 -0700 (PDT)
Message-Id: <20130821.204819.740022331426748929.davem@davemloft.net>
To: gregkh@linuxfoundation.org
Cc: daniel@gimpelevich.san-francisco.ca.us, j.dumon@option.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] hso: Fix stack corruption on some architectures
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130821162447.GC14364@kroah.com>
References: <1377074599.4530.9.camel@chimera>
	<20130821162447.GC14364@kroah.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 21 Aug 2013 20:48:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>
Date: Wed, 21 Aug 2013 09:24:47 -0700

> On Wed, Aug 21, 2013 at 01:43:19AM -0700, Daniel Gimpelevich wrote:
>> As Sergei Shtylyov explained in the #mipslinux IRC channel: 
>> [Mon 2013-08-19 12:28:21 PM PDT] <headless> guys, are you sure it's not "DMA off stack" case?
>> [Mon 2013-08-19 12:28:35 PM PDT] <headless> it's a known stack corruptor on non-coherent arches
>> [Mon 2013-08-19 12:31:48 PM PDT] <DonkeyHotei> headless: for usb/ehci?
>> [Mon 2013-08-19 12:34:11 PM PDT] <DonkeyHotei> headless: explain
>> [Mon 2013-08-19 12:35:38 PM PDT] <headless> usb_control_msg() (or other such func) should not use buffer on stack. DMA from/to stack is prohibited
>> [Mon 2013-08-19 12:35:58 PM PDT] <headless> and EHCI uses DMA on control xfers (as well as all the others)
>> 
>> Signed-off-by: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
> 
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Applied.
