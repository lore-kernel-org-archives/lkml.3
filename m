Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945935Ab3BGWpF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 17:45:05 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:49319 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422729Ab3BGWpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 17:45:03 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCH 0/4] Improve CLKSRC_OF matching
Date: Thu, 7 Feb 2013 22:44:51 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-4-generic; KDE/4.3.2; x86_64; ; )
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Rob Herring <rob.herring@calxeda.com>
References: <1360264144-20714-1-git-send-email-robherring2@gmail.com>
In-Reply-To: <1360264144-20714-1-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201302072244.51588.arnd@arndb.de>
X-Provags-ID: V02:K0:JW0rne7rf6F7/bATG3/ivD4ayJVhsCySUkUfuJaXaOm
 IgHMIcFNunBSB/LqLuuVUNfOL6c6F2J+5MemIMiqVAfmsyufw7
 CIaBWSZDEIvEvUChbCuddhhcp+1E48w2EvlRS49kUuPARCJxwc
 8KO7A+asGO4c0I3WYQQP+0/IFoak1R78dkAJToN9zh4lR+WS4o
 veaIdFkT4zX3gIX2EBxJci+P4fFar5moBuBztMbaz4CVF5Dk+/
 WRIL0Pe7vxn02mjvIuPdzxDTvpWc6HxKHUH8Jjw99d4mnqXVAB
 ip+0x7FbeYthkzDQIuuMdufFKoCti+mJSk41mdBvlmLHtxpEKx
 ykWCgH1ACMo/FbFGIZsY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 February 2013, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> In the recently added support for OF based clocksource init, a device node
> will be matched twice. We can fix this by passing the device node to the
> init functions and removing the match functions within the init functions.
> 
> This is based on arm-soc for-next branch and commit "of: fix incorrect
> return value of of_find_matching_node_and_match()" in my DT for-next
> branch.
> 

Acked-by: Arnd Bergmann <arnd@arndb.de>

Conceptually this is definitely the way to go, but I noticed that
you create build warnings for the bisection points after the
first patch. I would suggest actually merging the first three
patches into one and also changing the prototype for the tegra
function in that patch to avoid this.

	Arnd
