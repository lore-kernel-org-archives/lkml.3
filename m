Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450AbaCKQk2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 12:40:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.130]:58720 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbaCKQk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 12:40:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH v3 1/5] bug: When !CONFIG_BUG, simplify WARN_ON_ONCE and family
Date: Tue, 11 Mar 2014 17:40:25 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <469b5dc113cb468232291527642f8dc47663e945.1393385236.git.josh@joshtriplett.org> <6915585.VegnvotSUi@wuerfel> <17c859aa7dcccec43df0a0c8908911b982764c76.1394412745.git.josh@joshtriplett.org>
In-Reply-To: <17c859aa7dcccec43df0a0c8908911b982764c76.1394412745.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201403111740.25606.arnd@arndb.de>
X-Provags-ID: V02:K0:7SCI134t7knr3KjzWwN9TlPpCb2APqcwHPcWkVajHIa
 hYLCeME+SWnD1j6abevCDfSvjmPllaRmauyB+gR4h8kaQU5lWH
 1lHuUOsHwFaokQq1pD29rzR4elfWgOXsI7AtNXRTN8rm4MHZbr
 RXp8dH4akfw2HnsmzzsovjI3unesENIRlADnrPgWkKg3jS1ZO+
 tsxS8LStchbWHOxqndjzIcMAtC29FogyICel5+QnpkFMaWAFDi
 jiu/qiKSk4JcdjU5j/sF7RIQhvMLmkhprqoQCMKlTHTT9CWLVp
 H8AUCxhl3iyTGPxTXd6RveLcejHFORWK72qrqZhBB7AaSNcqk3
 Ho1F1+ognzfSr3hcO66RyZBILwfKkgg1g3glFpYta
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 March 2014, Josh Triplett wrote:
> 
> When !CONFIG_BUG, WARN_ON and family become simple passthroughs of their
> condition argument; however, WARN_ON_ONCE and family still have
> conditions and a boolean to detect one-time invocation, even though the
> warning they'd emit doesn't exist.  Make the existing definitions
> conditional on CONFIG_BUG, and add definitions for !CONFIG_BUG that map
> to the passthrough versions of WARN and WARN_ON.
> 
> This saves 4.4k on a minimized configuration (smaller than
> allnoconfig), and 20.6k with defconfig plus CONFIG_BUG=n.
> 
> Signed-off-by: Josh Triplett <josh@joshtriplett.org>
> ---
> v3: Patch unchanged from v2.
> 
> Andrew, can you please replace the entire v2 series currently in -mm
> with this new series?


[all patches]
Acked-by: Arnd Bergmann <arnd@arndb.de>
