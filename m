Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758979Ab3CETS7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 14:18:59 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:50518 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847Ab3CETS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 14:18:57 -0500
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Mandeep Singh Baines <msb@chromium.org>
Subject: Re: [PATCH] thinkpad-acpi: fix potential suspend blocking issue
Date: Tue, 5 Mar 2013 20:18:52 +0100
User-Agent: KMail/1.13.7 (Linux/3.9.0-rc1; KDE/4.8.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        ibm-acpi@hmh.eng.br, ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, Aaron Lu <aaron.lu@intel.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
References: <201303042055.38040.maciej.rutecki@gmail.com> <1362504883-9180-1-git-send-email-msb@chromium.org>
In-Reply-To: <1362504883-9180-1-git-send-email-msb@chromium.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201303052018.52320.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wtorek, 5 marca 2013 o 18:34:43 Mandeep Singh Baines wrote:
> Fixes the following lockdep error:
> 
> [ BUG: ktpacpi_nvramd/446 still has locks held! ]
> 
> hotkey_kthread() calls set_freezable() after acquiring the
> hotkey_kthread_mutex(). set_freezable() calls try_to_freeze().
> This could block suspend if we were to freeze at this point
> and another task were to block on the mutex, potentially via
> writing to one of the sysfs attrs. This race is unlikely but
> can be easily fixed by moving the set_freezable() call.
> 
> Reported-by: Maciej Rutecki <maciej.rutecki@gmail.com>
> Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
> CC: Aaron Lu <aaron.lu@intel.com>
> CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> CC: Tejun Heo <tj@kernel.org>
> CC: Oleg Nesterov <oleg@redhat.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
Tested-by: Maciej Rutecki <maciej.rutecki@gmail.com>

Patch fixes the problem. Thanks!

Regards

-- 
Maciej Rutecki
http://www.mrutecki.pl
