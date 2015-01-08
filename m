Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851AbbAHOhK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 09:37:10 -0500
Received: from smtp.citrix.com ([66.165.176.89]:42289 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753805AbbAHOhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 09:37:09 -0500
X-IronPort-AV: E=Sophos;i="5.07,723,1413244800"; 
   d="scan'208";a="212675983"
Message-ID: <54AE9604.4040901@citrix.com>
Date: Thu, 8 Jan 2015 14:36:52 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Vitaly Kuznetsov <vkuznets@redhat.com>, <x86@kernel.org>
CC: Andrew Jones <drjones@redhat.com>, <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, David Vrabel <david.vrabel@citrix.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <xen-devel@lists.xenproject.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Laszlo Ersek <lersek@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Xen-devel] [PATCH v2] x86/xen: avoid freeing static 'name' when
 kasprintf() fails
References: <1420463205-19249-1-git-send-email-vkuznets@redhat.com> <1420471671-32051-1-git-send-email-vkuznets@redhat.com>
In-Reply-To: <1420471671-32051-1-git-send-email-vkuznets@redhat.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/15 15:27, Vitaly Kuznetsov wrote:
> In case kasprintf() fails in xen_setup_timer() we assign name to the static
> string "<timer kasprintf failed>". We, however, don't check that fact before
> issuing kfree() in xen_teardown_timer(), kernel is supposed to crash with
> 'kernel BUG at mm/slub.c:3341!'
> 
> Solve the issue by making name a fixed length string inside struct
> xen_clock_event_device. 16 bytes should be enough.

Applied to stable/for-linus-3.19, thanks.

David
