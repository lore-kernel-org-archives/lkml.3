Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758997Ab3BTLQT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 06:16:19 -0500
Received: from miso.sublimeip.com ([203.12.5.51]:52840 "EHLO
	miso.sublimeip.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756494Ab3BTLQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 06:16:18 -0500
Subject: Re: prctl(PR_SET_MM)
To: gorcunov@openvz.org (Cyrill Gorcunov)
Date: Wed, 20 Feb 2013 22:16:16 +1100 (EST)
Cc: rostedt@goodmis.org (Steven Rostedt), u3557@dialix.com.au,
        oleg@redhat.com (Oleg Nesterov), palves@redhat.com (Pedro Alves),
        dvlasenk@redhat.com (Denys Vlasenko),
        jan.kratochvil@redhat.com (Jan Kratochvil),
        xemul@parallels.com (Pavel Emelyanov),
        fweisbec@gmail.com (Frederic Weisbecker),
        mingo@redhat.com (Ingo Molnar),
        a.p.zijlstra@chello.nl (Peter Zijlstra), linux-kernel@vger.kernel.org
Reply-To: u3557@dialix.com.au
In-Reply-To: <20130220105109.GW20312@moon>
X-Mailer: ELM [version 2.5 PL8]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20130220111616.12EF559206F@miso.sublimeip.com>
From: u3557@miso.sublimeip.com (Amnon Shiloh)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Cyrill,

Cyrill Gorcunov wrote:

> I see. Thanks for explanation! Thus we need some new config option which would
> enable this prctl opcodes (y by default), in turn config-checkpoint-restore
> kconfig option need to select this feature if set. Sounds reasonable?

Yes, This would be one possible way to do it.
Another possibility is to not have an #ifdef at all around this code.
Another possibility is to have a dual #if:

#if defined(CONFIG_CHECKPOINT_RESTORE) || defined(CONFIG_MM_FIELDS_SETTING)

Best Regards,
Amnon.
