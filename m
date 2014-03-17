Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933032AbaCQMTe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 08:19:34 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:55970 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932767AbaCQMTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 08:19:33 -0400
MIME-Version: 1.0
In-Reply-To: <1ebfa80c-4a68-4602-bc98-e5d5f0893998@email.android.com>
References: <1394468273-13676-1-git-send-email-david.vrabel@citrix.com>
	<531DEB11.2070709@zytor.com>
	<531DF319.6010800@citrix.com>
	<53266841.6090308@prgmr.com>
	<1ebfa80c-4a68-4602-bc98-e5d5f0893998@email.android.com>
Date: Mon, 17 Mar 2014 12:19:31 +0000
X-Google-Sender-Auth: SxzBLWN0f-Lv3QfTuOrwAmMA6Js
Message-ID: <CAFLBxZZz4Ot0CgWRHNRaM5zVkpf+QdXveFz_m3aVYnKUd9cAdQ@mail.gmail.com>
Subject: Re: [Xen-devel] [PATCHv1] x86: don't schedule when handling #NM exception
From: George Dunlap <George.Dunlap@eu.citrix.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Sarah Newman <srn@prgmr.com>, David Vrabel <david.vrabel@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2014 at 3:33 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> No, the right thing is to unf*ck the Xen braindamage and use eagerfpu as a workaround for the legacy hypervisor versions.

The interface wasn't an accident.  In the most common case you'll want
to clear the bit anyway. In PV mode clearing it would require an extra
trip up into the hypervisor.  So this saves one trip up into the
hypervisor on every context switch which involves an FPU, at the
expense of not being able to context-switch away when handling the
trap.

 -George
