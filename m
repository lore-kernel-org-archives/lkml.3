Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938AbaKGOJZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 09:09:25 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:52615 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbaKGOJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 09:09:22 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Tomasz Nowicki <tomasz.nowicki@linaro.org>, catalin.marinas@arm.com,
        will.deacon@arm.com, bhelgaas@google.com, Liviu.Dudau@arm.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, rjw@rjwysocki.net,
        linaro-acpi@lists.linaro.org, linux-pci@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [RFC PATCH 2/4] x86, acpi, pci: Isolate new PCI mmconfig entry insertion.
Date: Fri, 07 Nov 2014 15:09:10 +0100
Message-ID: <1927317.6tJuq4S5Om@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1415366876-30811-3-git-send-email-tomasz.nowicki@linaro.org>
References: <1415366876-30811-1-git-send-email-tomasz.nowicki@linaro.org> <1415366876-30811-3-git-send-email-tomasz.nowicki@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:DeICbjRjn0bBQ2IdkV5jVDhH9l671Zi0Lq8yyLAhiNx
 KMgxdjH4Y8JIljMFsqMVOBXEqYfbdWPhBgmDSxZem4bZ/MvNGn
 at4hFMbVxIi+MCm+zqkWSvf+eZ4TbhTwRy/Rv8165q71sDUjLx
 h7ojrLt82v8h6JgZfH8mpxxaMDjxsDDszZMMy5BpXY8D+VxOIY
 RACGdi8/utz/ETg8I8eLXfou4asdE/9MZ2xDIkR+ilDT0hBCXX
 5WmLHj4cwthVyCBO0kLqlznBDoe+Pnhcl7N1AbKN8sJ7lLEtBZ
 t3CVW/ASaNplpqQXaJ5uznQpikIkcNu8n/t9B0i6NSldPVvqyl
 LCvlPEUQiksX0VdFbwQo=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 November 2014 14:27:54 Tomasz Nowicki wrote:
> Add special pci_mmcfg_insert_lock mutex since pci_mmcfg_lock was moved
> to common file. No functional changes.
> 
> Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
> 

What is the new lock protecting against? You no longer have a mutual
exclusion with the other code, which looks like it is a functional
change, and also incorrect.

It also sounds like the code was broken after the first patch and
you need this one to make it compile again. You can't do that, and
instead need to change the locking rules first.

	Arnd
