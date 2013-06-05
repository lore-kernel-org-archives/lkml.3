Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758201Ab3FEXQA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 19:16:00 -0400
Received: from vps1.hno.se ([31.192.227.87]:59531 "EHLO vps1.hno.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757250Ab3FEXP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 19:15:59 -0400
Message-ID: <1370474115.20454.26.camel@localhost>
Subject: Re: [Arm-netbook] getting allwinner SoC support upstream (was Re:
 Uploading linux (3.9.4-1))
From: Henrik =?ISO-8859-1?Q?Nordstr=F6m?= <henrik@henriknordstrom.net>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linux on small ARM machines <arm-netbook@lists.phcomp.co.uk>,
        devicetree-discuss <devicetree-discuss@ozlabs.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        debian-arm@lists.debian.org, "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        ARM Linux Mailing List <linux-arm-kernel@lists.infradead.org>,
        debian-kernel@lists.debian.org
Date: Thu, 06 Jun 2013 01:15:15 +0200
In-Reply-To: <51AFC19F.9040601@wwwdotorg.org>
References: <CAPweEDx3mAy40BZrzrKPRbvg7vKMj7KevDQ3m_v4p6Yo50eSGg@mail.gmail.com>
	  <CAKON4OxDD5orX2w-_+d5kawTGXbE3KKj2QLERo9m7=NiUSXhgQ@mail.gmail.com>
	  <51AFA6DD.3000202@wwwdotorg.org>
	  <CAPweEDz=hFxXW3XF9CSNZpEFSjayb5an1E8Xze1_uQcCZONVxg@mail.gmail.com>
	 <1370469574.18839.33.camel@localhost> <51AFC19F.9040601@wwwdotorg.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ons 2013-06-05 klockan 16:54 -0600 skrev Stephen Warren:

> 1) Put all the parameters in the U-Boot configuration header. This is
> normal.

Yes, we do so today for U-Boot SPL. But this won't fit very well with
the Allwinner ODM workflow where one binary image works on a wide range
of board configurations probed while flashing the image to the board,
but on the other hand there is no real need for them to use u-boot as
the primary boot loader, just keep using boot0 + boot1 + u-boot chain as
they have always done.

> 2) Read some data structure at run-time. This data structure could in
> theory be some SoC-specific blob format (e.g. the packed version of
> information that some tool extracts from FEX/DT), a whole FEX blob, or
> device tree.

This is likely to happen for the sunxi U-Boot SPL due to the sheer
amount of boards involved, and is done to some extents for other boards
as well. In the SPL there generally isn't room for full DT support. Main
u-boot HW configuration could be done runtime via DT alone but we are
not quite there yet, nothing major missing however other than getting it
done.

Regards
Henrik

