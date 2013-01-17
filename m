Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197Ab3AQRJs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 12:09:48 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:40895 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776Ab3AQRJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 12:09:47 -0500
Message-ID: <1358442582.2828.11.camel@lorien2>
Subject: Re: [PATCH] drm/radeon: fix NULL pointer dereference in UMS mode in
 radeon_cs_parser_fini()
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: Ilija Hadzic <ihadzic@research.bell-labs.com>
Cc: airlied@linux.ie, deathsimple@vodafone.de, jglisse@redhat.com,
        airlied@redhat.com, "Deucher, Alexander" <alexander.deucher@amd.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org,
        shuahkhan@gmail.com
Date: Thu, 17 Jan 2013 10:09:42 -0700
In-Reply-To: <Pine.GSO.4.64.1301162045321.898@umail>
References: <1358379788.7243.10.camel@lorien2>
	 <Pine.GSO.4.64.1301162045321.898@umail>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-16 at 21:06 -0600, Ilija Hadzic wrote:
> Actually, the code path affected by your patch is not executed in UMS mode 
> at all. Notice that radeon_cs_parser_fini is only called from 
> radeon_cs_ioctl which is a KMS-only ioctl (see radeon_kms.c).
> 
> The equivalent of the fix you are trying to do is in
> a6b7e1a02b77ab8fe8775d20a88c53d8ba55482e (function patched by that one is 
> the one used by legacy-CS ioctl), which you should go together 
> with ff4bd0827764e10a428a9d39e6814c5478863f94 if you are backporting UMS 
> fixes to 3.7. Both are needed to prevent kernel crashes in UMS mode.
> 
> -- Ilija

Thanks. I will take a look at a6b7e1a02b77ab8fe8775d20a88c53d8ba55482e.
I sent back-ported ff4bd0827764e10a428a9d39e6814c5478863f94 patch to
stable and I will back-port and send
a6b7e1a02b77ab8fe8775d20a88c53d8ba55482e as well.

-- Shuah


