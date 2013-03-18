Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149Ab3CRJGd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 05:06:33 -0400
Received: from smtp1.infineon.com ([203.161.181.8]:53097 "EHLO
	smtp1.infineon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585Ab3CRJGa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 05:06:30 -0400
X-Greylist: delayed 610 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Mar 2013 05:06:30 EDT
X-SBRS: None
From: <Peter.Huewe@infineon.com>
To: <dlaurie@chromium.org>, <key@linux.vnet.ibm.com>
CC: <semenzato@chromium.org>, <tpmdd-devel@lists.sourceforge.net>,
        <torvalds@linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: RE: [tpmdd-devel] [PATCH] TPM: Retry SaveState command in suspend
 path
Thread-Topic: [tpmdd-devel] [PATCH] TPM: Retry SaveState command in suspend
 path
Thread-Index: AQHOI2IV2QjzRpkQ5kWpgc++qInY+pirJHYw
Date: Mon, 18 Mar 2013 08:56:12 +0000
Message-ID: <74A44E99E3274B4CB570415926B37D4413DE67@MUCSE501.eu.infineon.com>
References: <1363557399-11822-1-git-send-email-dlaurie@chromium.org>
In-Reply-To: <1363557399-11822-1-git-send-email-dlaurie@chromium.org>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.23.8.248]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

>  The TPM is too busy to respond to the command immediately, but the
>  command could be resubmitted at a later time.  The TPM MAY return
>  TPM_RETRY for any command at any time.

> It can take several seconds before the TPM will respond again.  I measured a typical time between 3 and 4 seconds and the timeout is set at a safe 5 seconds.
> I tested a variety of TPMs from Infineon, Nuvoton, Atmel, and STMicro but was only able to reproduce this with LPC and I2C TPMs from Infineon.


Yes, our TPMs respond with TPM_RETRY if the time between two TPM_SaveState is too short to prevent wear leveling.
If I remember correctly the internal timer is set to 5sec.

As you've already said this is compliant with the TCG specification.



Nevertheless,
the patch looks good to me.

Reviewed-by: Peter Huewe <peter.huewe@infineon.com>
Acked-by: Peter Huewe <peter.huewe@infineon.com>

Thanks,
Peter






