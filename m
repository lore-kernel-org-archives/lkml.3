Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758545Ab3DXWLQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 18:11:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44032 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758466Ab3DXWLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 18:11:15 -0400
Date: Wed, 24 Apr 2013 15:11:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Robin Holt <holt@sgi.com>
Cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Russ Anderson <rja@sgi.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH -v6 5/5] Move arch/x86 reboot= handling to generic
 kernel.
Message-Id: <20130424151113.0b3bef9e5060eec3e8c9858b@linux-foundation.org>
In-Reply-To: <1366802333-8890-6-git-send-email-holt@sgi.com>
References: <1366802333-8890-1-git-send-email-holt@sgi.com>
	<1366802333-8890-6-git-send-email-holt@sgi.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Apr 2013 06:18:53 -0500 Robin Holt <holt@sgi.com> wrote:

> Since arch/x86 has the most extensive reboot= handling and it appears to
> have no effect on the remaining architectures.  This patch moves that
> reboot= handling from arch/x86 to the generic kernel.
> 

This seems incomplete.  These, in arch/x86/kernel/reboot.c

extern int reboot_mode;
extern enum reboot_type reboot_type;
extern int reboot_force;
extern int reboot_default;

should surely be moved into include/linux/reboot.h.  But `enum
reboot_type' remains stuck over in
arch/x86/include/asm/emergency-restart.h.
