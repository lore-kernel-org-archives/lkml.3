Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763583Ab3DDGRe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 02:17:34 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:44119 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756663Ab3DDGRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 02:17:32 -0400
Message-ID: <515D1AF5.3010900@hitachi.com>
Date: Thu, 04 Apr 2013 15:17:25 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: oskar.andero@sonymobile.com
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net,
        anil.s.keshavamurthy@intel.com, ananth@in.ibm.com,
        radovan.lekanovic@sonymobile.com, bjorn.davidsson@sonymobile.com,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [PATCH 2/4] kprobes: split blacklist into common and arch
References: <1364977734-32267-1-git-send-email-oskar.andero@sonymobile.com> <1364977734-32267-3-git-send-email-oskar.andero@sonymobile.com>
In-Reply-To: <1364977734-32267-3-git-send-email-oskar.andero@sonymobile.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/04/03 17:28), oskar.andero@sonymobile.com wrote:
> Some blackpoints are only valid for specific architectures. To let each
> architecture specify its own blackpoints the list has been split in two
> lists: common and arch. The common list is kept in kernel/kprobes.c and
> the arch list is kept in the arch/ directory.

Hmm, I think you'd better merge this with patch 3/4.

[...]
> +static const size_t common_kprobes_blacksyms_size =
> +			ARRAY_SIZE(common_kprobes_blacksyms);
> +
> +extern const char * const arch_kprobes_blacksyms[];
> +extern const size_t arch_kprobes_blacksyms_size;
> +
> +static struct kprobe_blackpoint **kprobe_blacklist;
> +static size_t kprobe_blacklist_size;

Since the blacklist is allocated once and never be updated,
we just need an array of struct kprobe_blackpoint, no need
to allocate each entry.

Other parts are good for me! :)

Thank you!

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


