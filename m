Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751688AbaBEJhT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 04:37:19 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:50798 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296AbaBEJhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 04:37:02 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org, monstr@monstr.eu
Subject: Re: [PATCH 09/10] watchdog: xilinx: Add missing binding
Date: Wed, 5 Feb 2014 10:36:19 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-doc@vger.kernel.org, Michal Simek <michal.simek@xilinx.com>,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Rob Landley <rob@landley.net>, Kumar Gala <galak@codeaurora.org>
References: <ed4cb31c9a549343e6b492cf62fc962d39034bd0.1391177880.git.michal.simek@xilinx.com> <201402042027.15898.arnd@arndb.de> <52F20387.3090709@monstr.eu>
In-Reply-To: <52F20387.3090709@monstr.eu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201402051036.19428.arnd@arndb.de>
X-Provags-ID: V02:K0:bFGgXeWhhkN8hLMbBFOMobHgRFMXeiVkznEcxbdXwlA
 hdyi6S35Ql3UMi6xtL+N4lCcY85OBPLUOCbLQppQvnPznDnq6n
 BVtQ68OufnwCklhurBAXoOTajkdCjinJ4x9OrHVYOHDGaOeEls
 GQzBIDVdjKb8VE4re5KbXDdbFU6Gr9L/UkUlShCWYYXl9XxDFM
 Wv3Dw25oV0SmSGyRlzYvlRFivsO2LP0DUUYdHRBh4sv0Gaaly0
 jIrytT2pFuuL+W3DwhnyMH/1fRNb60vE6ACTX4qmXSdcEmwsKO
 monoM9Syy6GCEgGfkHgkMU2vk29cgtDGIG+xUEi5AE7lD1qMZE
 CJCP/nzjmHKr6sCFoLir4Pw4eLWK+/72IjFERwNtB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 February 2014, Michal Simek wrote:
> I am not quite sure what you mean by reports to user space.
> If you mean to get timeout through ioctl for example - then yes it is working
> through standard watchdog ioctl interface and timeout is calculated
> from hardware setup.

Yes, that is what I meant. I believe most other watchdogs let
you program the timeout, but I don't see anything wrong with
having that fixed in the FPGA in your case.

Still, the choice of putting the timeout into DT in terms of
cycles rather than miliseconds wasn't ideal from an interface
perspective and we should change that if/when we do a generic
binding. I can definitely see where it's coming from for your
case, as the cycle count totally makes sense from an FPGA
tool perspective...

	Arnd
