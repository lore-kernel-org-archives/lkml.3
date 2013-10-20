Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985Ab3JTW6F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 18:58:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:9768 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816Ab3JTW6D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 18:58:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="414176148"
From: Andi Kleen <andi@firstfloor.org>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        herrmann.der.user@googlemail.com, ming.lei@canonical.com,
        tigran@aivazian.fsnet.co.uk
Subject: Re: [PATCH 0/2] Improve firmware loading times on AMD and Intel
References: <1382304926-1641-1-git-send-email-prarit@redhat.com>
Date: Sun, 20 Oct 2013 15:58:01 -0700
In-Reply-To: <1382304926-1641-1-git-send-email-prarit@redhat.com> (Prarit
	Bhargava's message of "Sun, 20 Oct 2013 17:35:24 -0400")
Message-ID: <87eh7fturq.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prarit Bhargava <prarit@redhat.com> writes:
>
> Using request_firmware_nowait() seems more appropriate here and then we
> can avoid these delays, resulting in very quick load times for the
> microcode.

It would  be probably also good to remember if the loading failed for a 
given CPU and then don't try it on any other.

Just need to cache the exact stepping too to handle different steppings.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
