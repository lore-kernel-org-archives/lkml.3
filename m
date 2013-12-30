Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862Ab3L3MhF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 07:37:05 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:60959 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755610Ab3L3MhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 07:37:03 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19jjhq69u0UEQYt4nNVBDCamY8pZyoSpbo=
X-DKIM: OpenDKIM Filter v2.0.1 titan AE5434FE4EA
Date: Mon, 30 Dec 2013 07:37:00 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Gene Heskett <gheskett@wdtv.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG BISECTED] Phenom microcode revision mis-applied
Message-ID: <20131230123700.GS19878@titan.lakedaemon.net>
References: <201312291224.03854.gheskett@wdtv.com>
 <201312291449.16667.gheskett@wdtv.com>
 <20131229201906.GR19878@titan.lakedaemon.net>
 <201312292202.02236.gheskett@wdtv.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201312292202.02236.gheskett@wdtv.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 29, 2013 at 10:02:02PM -0500, Gene Heskett wrote:
...
> Finally done with the forward bisect:
> 
> gene@coyote:~/linux-stable$ dmesg|grep -A2 microcode
> microcode: CPU0: patch_level=0x01000065
> microcode: CPU0: new patch_level=0x01000083
> microcode: CPU1: patch_level=0x01000065
> microcode: CPU1: new patch_level=0x01000083
> microcode: CPU2: patch_level=0x01000065
> microcode: CPU2: new patch_level=0x01000083
> microcode: CPU3: patch_level=0x01000065
> microcode: CPU3: new patch_level=0x01000083
> microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
> 
> gene@coyote:~/linux-stable$ git bisect good
> 1a45c310b2102c58e37f84abba67fe21d5d6edcf is the first bad commit
> commit 1a45c310b2102c58e37f84abba67fe21d5d6edcf
> Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Date:   Thu Mar 14 11:27:14 2013 -0700
> 
>     Linux 3.8.3
> 
> :100644 100644 20d53183508e8f49253ec7e5ede0a12b4556fc32 8c49fc9b45a993a8e78cde4f9621b727b9121eac M	Makefile
> 
> The v3.8.3 Makefile?  Its just about the only thing that would be bad 
> every step from v3.8.3 to v3.8.2, and good all the way from v3.8.2 to 
> the last patch that made the v3.8.3 release.  Bisected twice, once in
> each direction.

When it works, which CONFIG_MICROCODE* options are set?  And unset when it
fails?

Also, what is the driving problem here?  I know the log entry 'new
patch_level=...' is missing, but what regression are you seeing that is
caused by not updating the microcode?

thx,

Jason.
