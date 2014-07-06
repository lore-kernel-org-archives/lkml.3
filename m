Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816AbaGFRLT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 13:11:19 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:55465 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbaGFRLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 13:11:17 -0400
Message-ID: <53B9833D.4000600@lwfinger.net>
Date: Sun, 06 Jul 2014 12:11:25 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
CC: linux-kbuild@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: Possible bug in kbuild
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A problem with configuration of IWLWIFI has been bisected to commit 48e2934, 
where a new section was added to drivers/net/wireless/iwlwifi/Kconfig with the 
following code:

# don't call it _MODULE -- will confuse Kconfig/fixdep/...
config IWLWIFI_OPMODE_MODULAR
         bool
         default y if IWLDVM=m
         default y if IWLMVM=m

When the above section is present, 'make xconfig' fails to show a "Debugging 
options" menu' even though 'make menuconfig' displays correctly. despite the 
incorrect on-screen display, xconfig does not delete the affected info in 
.config after it was set by menuconfig, thus the bug only seems to affect the 
display in xconfig.

Is there anything wrong with that section in iwlwifi's Kconfig, or is it a bug 
in xconfig?

Thanks,

Larry
