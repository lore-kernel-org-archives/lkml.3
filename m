Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829Ab3KRWbC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 17:31:02 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59145 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717Ab3KRWbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 17:31:01 -0500
Date: Mon, 18 Nov 2013 14:30:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jason Baron <jbaron@akamai.com>
Cc: mingo@kernel.org, benh@kernel.crashing.org, paulus@samba.org,
        ralf@linux-mips.org, linux-kernel@vger.kernel.org,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: Re: [PATCH v2] panic: Make panic_timeout configurable
Message-Id: <20131118143059.afe17d2faced16171a05eb10@linux-foundation.org>
In-Reply-To: <20131118210436.233B5202A@prod-mail-relay06.akamai.com>
References: <20131118210436.233B5202A@prod-mail-relay06.akamai.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Nov 2013 21:04:36 +0000 (GMT) Jason Baron <jbaron@akamai.com> wrote:

> The panic_timeout value can be set via the command line option 'panic=x', or via
> /proc/sys/kernel/panic, however that is not sufficient when the panic occurs
> before we are able to set up these values. Thus, add a CONFIG_PANIC_TIMEOUT
> so that we can set the desired value from the .config.
> 
> The default panic_timeout value continues to be 0 - wait forever, except for
> powerpc and mips, which have been defaulted to 180 and 5 respectively. This
> is in keeping with the fact that these arches already set panic_timeout in
> their arch init code. However, I found three exceptions- two in mips and one in
> powerpc where the settings didn't match these default values. In those cases, I
> left the arch code so it continues to override, in case the user has not changed
> from the default. It would nice if these arches had one default value, or if we
> could determine the correct setting at compile-time.

Felipe is proposing a simpler patch ("panic: setup panic_timeout
early") which switches to early_param().  Is that sufficient for the
(undescribed!) failure which you are presumably observing?

