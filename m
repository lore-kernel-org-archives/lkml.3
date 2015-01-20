Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910AbbATXsd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 18:48:33 -0500
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:42301 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbbATXsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 18:48:32 -0500
Date: Tue, 20 Jan 2015 23:48:21 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stefan Agner <stefan@agner.ch>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Mark Salter <msalter@redhat.com>, Kees Cook <keescook@chromium.org>,
        Laura Abbott <lauraa@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v2] ARM: early fixmap support for earlycon
Message-ID: <20150120234821.GN26493@n2100.arm.linux.org.uk>
References: <1421797064-2989-1-git-send-email-stefan@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421797064-2989-1-git-send-email-stefan@agner.ch>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 12:37:44AM +0100, Stefan Agner wrote:
> Add early fixmap support, initially to support permanent, fixed
> mapping support for early console. A temporary, early pte is
> created which is migrated to a permanent mapping in paging_init.
> This is also needed since the attributs may change as the memory
> types are initialized. The 3MiB range of fixmap spans two pte
> tables, but currently only one pte is created for early fixmap
> support.

I think this needs to be done more carefully - I think the entry(ies)
should be removed, the TLBs flushed, and the new entry established.
So:

> +static void __init early_fixmap_shutdown(void)
> +{
> +	int i;
> +
> +	pte_offset_fixmap = &pte_offset_late_fixmap;
> +	pmd_clear(fixmap_pmd(fix_to_virt(__end_of_permanent_fixed_addresses - 1)));

I think you should flush tlbs here.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
