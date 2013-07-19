Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760445Ab3GSNPw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 09:15:52 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:3664 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755845Ab3GSNPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 09:15:51 -0400
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
Message-ID: <51E93BFA.4090808@broadcom.com>
Date: Fri, 19 Jul 2013 15:15:38 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US;
 rv:1.9.2.24) Gecko/20111103 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: "Jiri Slaby" <jslaby@suse.cz>
cc: brcm80211-dev-list@broadcom.com,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Linux kernel mailing list" <linux-kernel@vger.kernel.org>
Subject: Re: brcm80211: machine freezing hard with rfkill on
References: <51E8E482.30505@suse.cz>
In-Reply-To: <51E8E482.30505@suse.cz>
X-WSS-ID: 7DF7E49331W53692303-01-01
Content-Type: text/plain;
 charset=iso-8859-2;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/13 09:02, Jiri Slaby wrote:
> Hi,
>
> our users report [1] that their machines freeze hard when they have
> rfkill turned on and try to run wpa_supplicant or enable network
> otherwise. This is with BCM43225 over PCI chip.
>
> Any ideas what that could be or how to fix this?
>
> [1] https://bugzilla.novell.com/show_bug.cgi?id=787649
>
> thanks,

Hi Jiri,

Looking in the bug report it seems to be on 3.4 kernel. The commit below 
is done later.

Regards,
Arend
---------------
commit 82d8eba358badb466a4e988ecabf0668a8d92e9c
Author: Piotr Haber <phaber@broadcom.com>
Date:   Wed Sep 19 22:21:15 2012 +0200

     brcmsmac: don't start device when RfKill is engaged

     This patch fixes a bug when device is being started
     while RfKill switch is engaged, leading to hang
     due to partial initialization of hardware.

     Tested-by: <dragonn@op.pl>
     Reviewed-by: Arend van Spriel <arend@broadcom.com>
     Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
     Signed-off-by: Piotr Haber <phaber@broadcom.com>
     Signed-off-by: Arend van Spriel <arend@broadcom.com>
     Signed-off-by: John W. Linville <linville@tuxdriver.com>


