Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760835AbbA1Ufm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:35:42 -0500
Received: from mail.skyhub.de ([78.46.96.112]:57363 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760807AbbA1Ufg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:35:36 -0500
Date: Wed, 28 Jan 2015 12:06:34 +0100
From: Borislav Petkov <bp@alien8.de>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, james@dingwall.me.uk,
        stable@vger.kernel.org.#.3.18
Subject: Re: [PATCH] x86, microcode: Return error from driver init code when
 loader is disabled
Message-ID: <20150128110634.GG12929@pd.tnic>
References: <1422411669-25147-1-git-send-email-boris.ostrovsky@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1422411669-25147-1-git-send-email-boris.ostrovsky@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 09:21:09PM -0500, Boris Ostrovsky wrote:
> Commits 65cef1311d5d ("x86, microcode: Add a disable chicken bit") and
> a18a0f6850d4 ("x86, microcode: Don't initialize microcode code on
> paravirt") allow microcode driver skip initialization when microcode
> loading is not permitted.
> 
> However, they don't prevent the driver from being loaded since the
> init code returns 0. If at some point later the driver gets unloaded
> this will result in an oops while trying to deregister the (never
> registered) device.
> 
> To avoid this, make init code return an error on paravirt or when
> microcode loading is disabled. The driver will then never be loaded.
> 
> Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> Reported-by: James Digwall <james@dingwall.me.uk>
> Cc: stable@vger.kernel.org # 3.18

Applied, thanks.

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
