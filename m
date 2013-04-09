Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937625Ab3DIK1U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 06:27:20 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:64289 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935762Ab3DIK1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 06:27:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Vivek Gautam <gautam.vivek@samsung.com>
Subject: Re: [PATCH] usb: ehci-s5p: fix: Fix null pointer dereferencing
Date: Tue, 9 Apr 2013 12:26:58 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        stern@rowland.harvard.edu, kgene.kim@samsung.com,
        Manjunath Goudar <manjunath.goudar@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>
References: <1365499312-14232-1-git-send-email-gautam.vivek@samsung.com>
In-Reply-To: <1365499312-14232-1-git-send-email-gautam.vivek@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304091226.58822.arnd@arndb.de>
X-Provags-ID: V02:K0:cBbSYg4JZxrxZeN3LzMzVK/UJKqC1ZKMvRvrcSLblaB
 3ilku85vv8vdKvKqbQtP4cYu1MqL8GL9bJWn8pcQuIwJQqNkpy
 Yd0qD0/ulPNLqL/CXhmU9x0Mx4Uujz+rShDD4g8eLnG4fn5YRZ
 dnnXAjTMSBVO8hMBg1heldxrKEJ3GcfXDhxhqVC/Pm07+I3hxr
 YUrRbj6QBNSludlVFqeh44jmR7OR5/Uz7zys5Tz+HHLVGsO0N7
 PFyBupB6mtgGP9vwKFi5LtSTCiyeFwzj/6e8k9bQd2fuVj38oL
 MpOJSTKuG9VyGggIS2wqJQWU90ZX2e1qtmNSpNDv8IUti1/QHf
 kwHkhYSbA1z4OQdFkuZw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 April 2013, Vivek Gautam wrote:
> 
> 7edb3da makes ehci-s5p as a separate driver. But,
> it raised an issue with its driver data.
> Now that 's5p_ehci_hcd' doesn't maintain pointer to 'usb_hcd'
> and s5p_ehci is nothing but a pointer to hcd->priv;
> add hcd to the driver data rather than s5p_ehci.
> 
> This fixes issues with null pointer dereferencing in
> s5p_ehci_shutdown(), s5p_ehci_suspend(), s5p_ehci_resume().

Right, sorry for not spotting this during review.

> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> CC: Manjunath Goudar <manjunath.goudar@linaro.org>
> CC: Arnd Bergmann <arnd@arndb.de>
> CC: Jingoo Han <jg1.han@samsung.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
