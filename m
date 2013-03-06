Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758574Ab3CFPwi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 10:52:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16268 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751452Ab3CFPwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 10:52:36 -0500
Date: Wed, 6 Mar 2013 16:50:39 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mandeep Singh Baines <msb@chromium.org>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, ibm-acpi@hmh.eng.br,
        ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, Aaron Lu <aaron.lu@intel.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Tejun Heo <tj@kernel.org>, Maciej Rutecki <maciej.rutecki@gmail.com>,
        Artem Savkov <artem.savkov@gmail.com>
Subject: Re: [PATCH] thinkpad-acpi: fix potential suspend blocking issue
Message-ID: <20130306155039.GB7697@redhat.com>
References: <201303042055.38040.maciej.rutecki@gmail.com> <1362504883-9180-1-git-send-email-msb@chromium.org> <20130305141817.4e27e83aa66598115e52eb9e@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130305141817.4e27e83aa66598115e52eb9e@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05, Andrew Morton wrote:
>
> Basically the same as
> http://ozlabs.org/~akpm/mmots/broken-out/drivers-platform-x86-thinkpad_acpic-move-hotkey_thread_mutex-lock-after-set_freezable.patch.
>  I think Artem's patch is a little better.  There doesn't appear to be
> any locking protocol for tpacpi_lifecycle.

Which seems to have the same problem, hotkey_kthread() still calls
kthread_freezable_should_stop() under hotkey_thread_mutex.

IOW, we have two try_to_freeze's here, the patch moves only one of
them outside of the hotkey_thread_mutex.

Oleg.

